import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi Perfil', 
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Avatar & Name
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
                  const Text('Lector Chetilla 01', 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('lector01@infirape.com', 
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Statistics Summary
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Sectores', '14', Icons.map_outlined),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard('Hoy', '42', Icons.bolt),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            // Settings List
            _buildSettingItem(
              icon: Icons.sync_problem_outlined,
              title: 'Sincronización Automática',
              trailing: Switch(
                value: true, 
                onChanged: (v) {},
                activeColor: AppColors.magenta,
              ),
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Cambiar Contraseña',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Soporte Técnico',
              onTap: () {},
            ),
            
            const SizedBox(height: 40),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {},
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
