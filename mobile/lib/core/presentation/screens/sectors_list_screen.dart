import 'package:flutter/material.dart';
import '../../data/database.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class SectorsListScreen extends StatelessWidget {
  final AppDatabase db;
  const SectorsListScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('InVolt - Chetilla', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: AppColors.cyan),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<List<Sector>>(
        stream: db.select(db.sectors).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.magenta));
          }

          final sectors = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 120, top: 10),
            itemCount: sectors.length,
            itemBuilder: (context, index) {
              final sector = sectors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: AppColors.cyan, size: 20),
                    ),
                    title: Text(sector.name, 
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w500)),
                    subtitle: Text('Sector ID: ${sector.id}', 
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
