import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../data/database.dart';

class SyncScreen extends StatelessWidget {
  final AppDatabase db;
  const SyncScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Sincronización', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sync Status Summary
            StreamBuilder<List<Reading>>(
              stream: db.select(db.readings).watch(),
              builder: (context, snapshot) {
                final readings = snapshot.data ?? [];
                final unsynced = readings.where((r) => !r.isSynced).length;
                final synced = readings.length - unsynced;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusCard(
                            'Pendientes', 
                            unsynced.toString(), 
                            AppColors.magenta, 
                            Icons.cloud_upload_outlined
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatusCard(
                            'Sincronizados', 
                            synced.toString(), 
                            AppColors.cyan, 
                            Icons.cloud_done_outlined
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Sync Progress / Action
                    GlassCard(
                      child: Column(
                        children: [
                          const Text('Estado de la conexión', 
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi, color: AppColors.cyan, size: 16),
                              SizedBox(width: 8),
                              Text('Conectado a la red Infira', 
                                style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: unsynced > 0 ? () => _handleSync(context) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.magenta,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.white10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text('SINCRONIZAR AHORA', 
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 30),
            const Text('Actividad Reciente', 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // Recent Activity List
            Expanded(
              child: StreamBuilder<List<Reading>>(
                stream: (db.select(db.readings)..orderBy([(t) => drift.OrderingTerm.desc(t.timestamp)])).watch(),
                builder: (context, snapshot) {
                  final readings = snapshot.data ?? [];
                  if (readings.isEmpty) {
                    return Center(child: Text('Sin lecturas registradas', style: TextStyle(color: AppColors.textMuted)));
                  }
                  return ListView.builder(
                    itemCount: readings.length,
                    itemBuilder: (context, index) {
                      final reading = readings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: reading.isSynced ? AppColors.cyan.withOpacity(0.1) : AppColors.magenta.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  reading.isSynced ? Icons.check : Icons.sync,
                                  color: reading.isSynced ? AppColors.cyan : AppColors.magenta,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lectura: ${reading.currentValue} kWh', 
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Suministro: ${reading.customerId}', 
                                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}', 
                                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            ],
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
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, Color color, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  void _handleSync(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sincronizando datos con el servidor de Infira...'),
        backgroundColor: AppColors.magenta,
      ),
    );
    // TODO: Implementar llamada real al SyncService (Phase 5)
  }
}
