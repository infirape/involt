import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:drift/drift.dart' as drift;
import 'package:geolocator/geolocator.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/customer_map_view.dart';
import '../screens/reading_screen.dart';
import '../screens/scanner_screen.dart';
import '../providers/app_state_provider.dart';
import '../../data/database.dart';

class SearchScreen extends StatefulWidget {
  final AppDatabase db;
  final String? initialSectorId;
  final VoidCallback? onSectorHandled;

  const SearchScreen({
    super.key, 
    required this.db, 
    this.initialSectorId,
    this.onSectorHandled,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _mapController = MapController();
  final _sectorScrollController = ScrollController();
  String _searchQuery = '';
  final Set<String> _selectedSectorIds = {};
  Customer? _selectedCustomer;
  Timer? _debounce;
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _loadPersistedSectors();
    _initLocation();
    if (widget.initialSectorId != null) {
      _selectedSectorIds.add(widget.initialSectorId!);
      widget.onSectorHandled?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedSector());
    }
  }

  Future<void> _loadPersistedSectors() async {
    final setting = await (widget.db.select(widget.db.settings)
      ..where((s) => s.key.equals('map_selected_sectors')))
      .getSingleOrNull();
    
    if (setting != null && setting.value.isNotEmpty) {
      setState(() {
        _selectedSectorIds.addAll(setting.value.split(','));
      });
      if (_selectedSectorIds.isNotEmpty) {
        _centerOnFirstUnregisteredCustomer(_selectedSectorIds.first);
      }
    }
  }

  Future<void> _saveSelectedSectors() async {
    final value = _selectedSectorIds.join(',');
    await widget.db.into(widget.db.settings).insertOnConflictUpdate(
      SettingsCompanion(
        key: const drift.Value('map_selected_sectors'),
        value: drift.Value(value),
      ),
    );
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(pos.latitude, pos.longitude);
    });
    
    if (_selectedSectorIds.isEmpty) {
      _mapController.move(_userLocation!, 16);
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().length >= 2 || query.isEmpty) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  void _scrollToSelectedSector() {
    if (_selectedSectorIds.isEmpty) return;
    final firstId = _selectedSectorIds.first;
    
    widget.db.select(widget.db.sectors).get().then((sectors) {
      final index = sectors.indexWhere((s) => s.id == firstId);
      if (index != -1) {
        final position = index * 100.0;
        if (_sectorScrollController.hasClients) {
          _sectorScrollController.animateTo(
            position,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _centerOnFirstUnregisteredCustomer(String sectorId) async {
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;
    final customers = await (widget.db.select(widget.db.customers)
      ..where((c) => c.sectorId.equals(sectorId))).get();
    
    if (customers.isEmpty) return;

    final readings = await (widget.db.select(widget.db.readings)
      ..where((r) => r.period.equals(selectedPeriod))).get();
    final registeredIds = readings.map((r) => r.customerId).toSet();

    try {
      final firstUnregistered = customers.firstWhere(
        (c) => !registeredIds.contains(c.id) && c.latitude != 0,
      );
      _mapController.move(LatLng(firstUnregistered.latitude, firstUnregistered.longitude), 17);
    } catch (_) {
      final firstWithGps = customers.firstWhere((c) => c.latitude != 0, orElse: () => customers.first);
      if (firstWithGps.latitude != 0) {
        _mapController.move(LatLng(firstWithGps.latitude, firstWithGps.longitude), 17);
      }
    }
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSectorId != null && widget.initialSectorId != oldWidget.initialSectorId) {
      setState(() {
        _selectedSectorIds.add(widget.initialSectorId!);
      });
      _saveSelectedSectors();
      widget.onSectorHandled?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedSector());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _sectorScrollController.dispose();
    _debounce?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _centerOnCustomer(Customer c) {
    setState(() => _selectedCustomer = c);
    if (c.latitude != 0) {
      _mapController.move(LatLng(c.latitude, c.longitude), 17);
    }
    setState(() => _searchQuery = ''); 
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final selectedPeriod = appState.selectedPeriod;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mapa de Suministros', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Reading>>(
        stream: (widget.db.select(widget.db.readings)..where((r) => r.period.equals(selectedPeriod))).watch(),
        builder: (context, readingsSnapshot) {
          final readings = readingsSnapshot.data ?? [];

          return StreamBuilder<List<Customer>>(
            stream: _getFilteredCustomers(),
            builder: (context, customersSnapshot) {
              final customers = customersSnapshot.data ?? [];

              return Stack(
                children: [
                  StreamBuilder<List<Customer>>(
                    stream: widget.db.select(widget.db.customers).watch(),
                    builder: (context, allSnapshot) {
                      final allRawCustomers = allSnapshot.data ?? [];
                      
                      final mapCustomers = allRawCustomers.where((c) => 
                        _selectedSectorIds.contains(c.sectorId) || 
                        (_selectedCustomer != null && c.id == _selectedCustomer!.id)
                      ).toList();

                      final bool isFiltering = _searchQuery.trim().isNotEmpty;

                      return CustomerMapView(
                        db: widget.db,
                        customers: customers,
                        allCustomers: mapCustomers,
                        readings: readings,
                        isFiltering: isFiltering,
                        selectedCustomerId: _selectedCustomer?.id,
                        mapController: _mapController,
                        userLocation: _userLocation,
                        onCustomerTap: (c) {
                          _centerOnCustomer(c);
                        },
                      );
                    },
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: TextField(
                            controller: _controller,
                            onChanged: _onSearchChanged,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Buscar por código o nombre...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              border: InputBorder.none,
                              icon: const Icon(Icons.search, color: AppColors.cyan),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.qr_code_scanner, color: AppColors.cyan),
                                onPressed: () async {
                                  final String? scannedCode = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ScannerScreen()),
                                  );

                                  if (scannedCode != null) {
                                    final customer = await (widget.db.select(widget.db.customers)
                                      ..where((c) => c.code.equals(scannedCode) | c.meterNumber.equals(scannedCode))
                                      ..limit(1))
                                      .getSingleOrNull();

                                    if (customer != null) {
                                      _centerOnCustomer(customer);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('No se encontró suministro con el código: $scannedCode'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 40,
                        child: StreamBuilder<List<Sector>>(
                          stream: widget.db.select(widget.db.sectors).watch(),
                          builder: (context, sectorSnapshot) {
                            if (!sectorSnapshot.hasData) return const SizedBox();
                            final sectors = sectorSnapshot.data!;
                            return ListView.builder(
                              controller: _sectorScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 20),
                              itemCount: sectors.length,
                              itemBuilder: (context, index) {
                                final sector = sectors[index];
                                final isSelected = _selectedSectorIds.contains(sector.id);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: FilterChip(
                                    label: Text(sector.name),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedSectorIds.add(sector.id);
                                          _centerOnFirstUnregisteredCustomer(sector.id);
                                        } else {
                                          _selectedSectorIds.remove(sector.id);
                                        }
                                        _selectedCustomer = null; 
                                      });
                                      _saveSelectedSectors();
                                    },
                                    selectedColor: AppColors.volt.withOpacity(0.3),
                                    backgroundColor: AppColors.glass,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.volt : AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                    shape: StadiumBorder(side: BorderSide(color: isSelected ? AppColors.volt : AppColors.glassBorder)),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      if (_searchQuery.isNotEmpty)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: customers.isEmpty 
                              ? Center(child: Text('No se encontraron resultados', style: TextStyle(color: AppColors.textMuted)))
                              : ListView.separated(
                                  padding: const EdgeInsets.all(15),
                                  itemCount: customers.length,
                                  separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                                  itemBuilder: (context, index) {
                                    final c = customers[index];
                                    final bool hasCoords = c.latitude != 0;
                                    final bool isRegistered = readings.any((r) => r.customerId == c.id);

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: isRegistered ? AppColors.cyan.withOpacity(0.2) : AppColors.volt.withOpacity(0.1),
                                        child: Icon(
                                          isRegistered ? Icons.check_circle_outline : Icons.pending_outlined, 
                                          color: isRegistered ? AppColors.cyan : AppColors.volt, 
                                          size: 20
                                        ),
                                      ),
                                      title: Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      subtitle: Text('Suministro: ${c.code}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      trailing: hasCoords 
                                        ? const Icon(Icons.location_on, color: AppColors.cyan, size: 20)
                                        : ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ReadingScreen(
                                                    customer: c, 
                                                    db: widget.db,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.volt,
                                              foregroundColor: Colors.black,
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              minimumSize: const Size(60, 30),
                                            ),
                                            child: const Text('Registrar', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                      onTap: () {
                                        if (hasCoords) {
                                          _centerOnCustomer(c);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReadingScreen(
                                                customer: c, 
                                                db: widget.db,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                          ),
                        ),

                      if (_selectedCustomer != null && _searchQuery.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(color: AppColors.cyan.withOpacity(0.1), blurRadius: 15, spreadRadius: 5),
                              ],
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_selectedCustomer!.name, 
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('Suministro: ${_selectedCustomer!.code}', 
                                        style: TextStyle(color: AppColors.cyan, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                                  onPressed: () => setState(() => _selectedCustomer = null),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReadingScreen(
                                          customer: _selectedCustomer!, 
                                          db: widget.db,
                                        ),
                                      ),
                                    );
                                    if (mounted) setState(() => _selectedCustomer = null);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.volt,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Registrar', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Floating "My Location" Button
                  if (_userLocation != null && _searchQuery.isEmpty)
                    Positioned(
                      right: 20,
                      bottom: _selectedCustomer != null ? 220 : 100,
                      child: FloatingActionButton(
                        onPressed: () {
                          _mapController.move(_userLocation!, 17);
                        },
                        backgroundColor: Colors.black.withOpacity(0.7),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: AppColors.cyan, width: 1),
                        ),
                        child: const Icon(Icons.my_location, color: AppColors.cyan),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<Customer>> _getFilteredCustomers() {
    return widget.db.select(widget.db.customers).watch().map((list) {
      final query = _searchQuery.toLowerCase().trim();
      
      if (query.isEmpty && _selectedSectorIds.isEmpty) return [];

      final filtered = list.where((c) {
        final matchesSearch = query.isEmpty || 
                             c.name.toLowerCase().contains(query) || 
                             c.code.toLowerCase().contains(query);
        final matchesSector = _selectedSectorIds.isEmpty || _selectedSectorIds.contains(c.sectorId);
        return matchesSearch && matchesSector;
      }).toList();

      return filtered.take(10).toList();
    });
  }
}
