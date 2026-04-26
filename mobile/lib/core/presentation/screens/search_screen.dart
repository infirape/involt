import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../data/database.dart';

class SearchScreen extends StatefulWidget {
  final AppDatabase db;
  const SearchScreen({super.key, required this.db});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String? _selectedSectorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Buscar Suministro', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              borderRadius: 15,
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Código o Nombre...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: AppColors.magenta),
                ),
              ),
            ),
          ),

          // Sector Filter
          SizedBox(
            height: 40,
            child: StreamBuilder<List<Sector>>(
              stream: widget.db.select(widget.db.sectors).watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final sectors = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  itemCount: sectors.length,
                  itemBuilder: (context, index) {
                    final sector = sectors[index];
                    final isSelected = _selectedSectorId == sector.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(sector.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedSectorId = selected ? sector.id : null);
                        },
                        selectedColor: AppColors.magenta.withOpacity(0.3),
                        backgroundColor: AppColors.glass,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.magenta : AppColors.textMuted,
                          fontSize: 12,
                        ),
                        shape: StadiumBorder(side: BorderSide(color: isSelected ? AppColors.magenta : AppColors.glassBorder)),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Results List
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: _getFilteredCustomers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.magenta));
                }

                final customers = snapshot.data!;
                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: AppColors.textMuted),
                        const SizedBox(height: 10),
                        Text('No se encontraron suministros', style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120, top: 10),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.magenta.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bolt, color: AppColors.magenta, size: 20),
                          ),
                          title: Text(customer.name, 
                            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          subtitle: Text('Suministro: ${customer.code}', 
                            style: TextStyle(color: AppColors.textSecondary)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                          onTap: () {
                            // TODO: Navegar a detalles de lectura
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

  Stream<List<Customer>> _getFilteredCustomers() {
    var query = widget.db.select(widget.db.customers);
    
    return query.watch().map((list) {
      return list.where((c) {
        final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                             c.code.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesSector = _selectedSectorId == null || c.sectorId == _selectedSectorId;
        return matchesSearch && matchesSector;
      }).toList();
    });
  }
}
