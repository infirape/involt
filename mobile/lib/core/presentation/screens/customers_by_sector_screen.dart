import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/database.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../providers/app_state_provider.dart';
import 'reading_screen.dart';
import 'scanner_screen.dart';

class CustomersBySectorScreen extends StatefulWidget {
  final Sector sector;
  final AppDatabase db;

  const CustomersBySectorScreen({
    super.key,
    required this.sector,
    required this.db,
  });

  @override
  State<CustomersBySectorScreen> createState() => _CustomersBySectorScreenState();
}

class _CustomersBySectorScreenState extends State<CustomersBySectorScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  final List<Customer> _customers = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  final int _limit = 20;
  
  int _measuredCount = 0;
  int _totalCount = 0;
  
  String _searchQuery = '';
  String _activeFilter = 'all'; 
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadMoreCustomers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMoreCustomers();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _resetAndLoad();
      });
    });
  }

  void _resetAndLoad() {
    setState(() {
      _customers.clear();
      _offset = 0;
      _hasMore = true;
      _isLoading = true;
    });
    _loadMoreCustomers();
  }

  Future<void> _loadStats() async {
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;
    
    final allCustomers = await (widget.db.select(widget.db.customers)
          ..where((c) => c.sectorId.equals(widget.sector.id)))
        .get();

    final readings = await (widget.db.select(widget.db.readings)
          ..where((r) => r.period.equals(selectedPeriod)))
        .get();

    final registeredIds = readings.map((r) => r.customerId).toSet();

    if (mounted) {
      setState(() {
        _totalCount = allCustomers.length;
        _measuredCount = allCustomers.where((c) => registeredIds.contains(c.id)).length;
      });
    }
  }

  Future<void> _loadMoreCustomers() async {
    if (_isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;

    // Build query
    var query = widget.db.select(widget.db.customers)
      ..where((c) => c.sectorId.equals(widget.sector.id));
    
    if (_searchQuery.isNotEmpty) {
      query.where((c) => c.name.contains(_searchQuery) | c.code.contains(_searchQuery));
    }

    final allMatching = await query.get();
    
    final readings = await (widget.db.select(widget.db.readings)
          ..where((r) => r.period.equals(selectedPeriod)))
        .get();
    final registeredIds = readings.map((r) => r.customerId).toSet();

    List<Customer> filtered = allMatching;
    if (_activeFilter == 'measured') {
      filtered = allMatching.where((c) => registeredIds.contains(c.id)).toList();
    } else if (_activeFilter == 'pending') {
      filtered = allMatching.where((c) => !registeredIds.contains(c.id)).toList();
    }

    final paged = filtered.skip(_offset).take(_limit).toList();

    if (mounted) {
      setState(() {
        _customers.addAll(paged);
        _isLoading = false;
        _isLoadingMore = false;
        _offset += _limit;
        _hasMore = filtered.length > _offset;
      });
    }
  }

  void _showPeriodPicker() {
    final appState = context.read<AppStateProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onyx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Seleccionar Periodo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              ...appState.availablePeriods.map((p) {
                final isSelected = p == appState.selectedPeriod;
                return ListTile(
                  title: Text(p, style: TextStyle(color: isSelected ? AppColors.cyan : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.cyan) : null,
                  onTap: () {
                    appState.setPeriod(p);
                    _loadStats();
                    _resetAndLoad();
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = context.watch<AppStateProvider>().selectedPeriod;

    return Scaffold(
      backgroundColor: AppColors.onyx,
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          onTap: _showPeriodPicker,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.sector.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedPeriod, style: const TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                  const Icon(Icons.arrow_drop_down, color: AppColors.cyan, size: 16),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search + Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: AppColors.cyan, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _searchQuery.isNotEmpty ? Icons.close : Icons.qr_code_scanner,
                            color: _searchQuery.isNotEmpty ? Colors.white24 : AppColors.cyan,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_searchQuery.isNotEmpty) {
                              _searchController.clear();
                              _onSearchChanged('');
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerScreen()));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.magenta.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.magenta.withOpacity(0.3)),
                  ),
                  child: Text(
                    '$_measuredCount/$_totalCount',
                    style: const TextStyle(color: AppColors.magenta, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  _buildFilterTab('Todos', 'all', Icons.people_outline),
                  _buildFilterTab('Medidos', 'measured', Icons.check_circle_outline),
                  _buildFilterTab('Pendientes', 'pending', Icons.pending_outlined),
                ],
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.magenta))
                : StreamBuilder<List<Reading>>(
                    stream: (widget.db.select(widget.db.readings)
                          ..where((r) => r.period.equals(selectedPeriod)))
                        .watch(),
                    builder: (context, snapshot) {
                      final registeredIds = (snapshot.data ?? []).map((r) => r.customerId).toSet();

                      if (_customers.isEmpty) return _buildEmptyState();

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        itemCount: _customers.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _customers.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator(color: AppColors.magenta, strokeWidth: 2)),
                            );
                          }

                          final customer = _customers[index];
                          final isMeasured = registeredIds.contains(customer.id);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isMeasured ? AppColors.cyan.withOpacity(0.2) : AppColors.magenta.withOpacity(0.1),
                                  child: Icon(
                                    isMeasured ? Icons.check_circle : Icons.pending, 
                                    color: isMeasured ? AppColors.cyan : AppColors.magenta, 
                                    size: 20
                                  ),
                                ),
                                title: Text(customer.name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text('Suministro: ${customer.code}',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReadingScreen(
                                        customer: customer,
                                        db: widget.db,
                                      ),
                                    ),
                                  );
                                  _loadStats();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value, IconData icon) {
    final isSelected = _activeFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeFilter = value;
            _resetAndLoad();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.magenta.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.magenta : Colors.white10,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: isSelected ? AppColors.magenta : Colors.white38),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 60, color: Colors.white12),
          const SizedBox(height: 15),
          Text('No se encontraron clientes', style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
