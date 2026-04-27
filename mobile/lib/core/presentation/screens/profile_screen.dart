import '../../data/services/sync_service.dart';
import 'package:flutter/material.dart';
import '../../data/database.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatefulWidget {
  final AppDatabase db;
  final SyncService syncService;
  
  const ProfileScreen({
    super.key, 
    required this.db,
    required this.syncService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isResetting = false;

  @override
  Widget build(BuildContext context) {
    final db = widget.db;
    final syncService = widget.syncService;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi Perfil', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ... (User Avatar & Name section remains same)
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.magenta,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.onyx,
                      child: Icon(Icons.person, size: 50, color: Colors.white24),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Jaime Landa', 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('jaime.landa@infira.pe', 
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.magenta.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.magenta.withOpacity(0.3)),
                    ),
                    child: const Text('OPERADOR SENIOR', 
                      style: TextStyle(color: AppColors.magenta, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Statistics Summary (REAL DATA)
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<List<Sector>>(
                    stream: db.select(db.sectors).watch(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _buildStatCard('Sectores', count.toString(), Icons.map_outlined);
                    }
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: StreamBuilder<List<Reading>>(
                    stream: db.select(db.readings).watch(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return _buildStatCard('Lecturas', count.toString(), Icons.bolt);
                    }
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            // Settings List
            _buildSettingItem(
              icon: Icons.history,
              title: 'Resumen de Datos Locales',
              onTap: () => _showSyncSummary(context),
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Cambiar Contraseña',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad disponible en la próxima actualización'))
              ),
            ),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Soporte Técnico',
              onTap: () => _showSupportInfo(context),
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'Acerca de InVolt v1.0.0',
              onTap: () => _showAboutDialog(context),
            ),
            
            const SizedBox(height: 20),

            // DANGER ZONE: Hard Reset
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isResetting ? null : () => _showHardResetDialog(context),
                icon: Icon(
                  _isResetting ? Icons.hourglass_empty : Icons.delete_forever, 
                  color: _isResetting ? Colors.grey : Colors.redAccent, 
                  size: 20
                ),
                label: Text(
                  _isResetting ? 'REINICIANDO...' : 'REINICIAR DATOS LOCALES', 
                  style: TextStyle(
                    color: _isResetting ? Colors.grey : Colors.redAccent, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 12
                  )
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _isResetting ? Colors.grey : Colors.redAccent),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.magenta),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('CERRAR SESIÓN', 
                  style: TextStyle(color: AppColors.magenta, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            
            const SizedBox(height: 120), // Bottom bar space
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'InVolt',
      applicationVersion: '1.0.0',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/logo.png',
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
      ),
      children: [
        const Text('Sistema de Gestión de Energía Offline-First.'),
        const SizedBox(height: 10),
        const Text('Desarrollado por Infira para operadores de campo en zonas rurales.'),
      ],
    );
  }

  void _showSupportInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.onyx,
        title: const Text('Soporte Técnico'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Tenés problemas con la app?', style: TextStyle(color: Colors.white)),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.cyan, size: 20),
                const SizedBox(width: 10),
                const Text('+51 929 202 333', style: TextStyle(color: AppColors.cyan)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.cyan, size: 20),
                const SizedBox(width: 10),
                const Text('contacto@infira.pe', style: TextStyle(color: AppColors.cyan)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CERRAR')),
        ],
      ),
    );
  }

  void _showSyncSummary(BuildContext context) async {
    final readings = await widget.db.select(widget.db.readings).get();
    final unsynced = readings.where((r) => !r.isSynced).length;
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.onyx,
        title: const Text('Resumen de Datos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow('Total Lecturas:', readings.length.toString()),
            _buildSummaryRow('Pendientes de Subir:', unsynced.toString(), color: AppColors.magenta),
            _buildSummaryRow('Sincronizadas:', (readings.length - unsynced).toString(), color: AppColors.cyan),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CERRAR')),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showHardResetDialog(BuildContext context) {
    bool isAccepted = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: AppColors.onyx,
            title: const Text('⚠️ ADVERTENCIA CRÍTICA', style: TextStyle(color: Colors.redAccent)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Esta acción eliminará TODA la base de datos local.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'LAS LECTURAS Y FOTOS QUE NO HAYAN SIDO SINCRONIZADAS SE PERDERÁN PARA SIEMPRE.',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white54),
                  child: CheckboxListTile(
                    value: isAccepted,
                    onChanged: (val) => setStateDialog(() => isAccepted = val ?? false),
                    title: const Text(
                      'Entiendo que Infira no tiene compromiso ni responsabilidad sobre los datos borrados. Esta acción es bajo mi propia responsabilidad.',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.magenta,
                    checkColor: Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
              ElevatedButton(
                onPressed: isAccepted ? () async {
                  Navigator.pop(context);
                  _performHardReset(context);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAccepted ? Colors.redAccent : Colors.grey.withOpacity(0.3),
                  disabledBackgroundColor: Colors.white10,
                ),
                child: Text('SÍ, REINICIAR TODO', 
                  style: TextStyle(color: isAccepted ? Colors.white : Colors.white24)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _performHardReset(BuildContext context) async {
    setState(() => _isResetting = true);
    
    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.magenta),
            SizedBox(height: 20),
            Text('Reiniciando sistema...', style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 16)),
          ],
        ),
      ),
    );

    try {
      await widget.syncService.hardReset();
      if (context.mounted) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sistema reiniciado y datos actualizados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error en el reinicio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResetting = false);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.onyx,
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que querés salir? Los datos no sincronizados se mantendrán en este dispositivo.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('SALIR', style: TextStyle(color: AppColors.magenta))
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon, color: AppColors.cyan, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.textSecondary, size: 22),
          title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
          trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
        ),
      ),
    );
  }
}
