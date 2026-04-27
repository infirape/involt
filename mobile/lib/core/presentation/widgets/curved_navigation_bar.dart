import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CurvedNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CurvedNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.transparent,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 90),
            painter: BNBCustomPainter(currentIndex),
          ),
          Center(
            child: SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.home_outlined, Icons.home, "Inicio"),
                    _buildNavItem(1, Icons.search, Icons.search, "Buscar"),
                    _buildNavItem(2, Icons.sync, Icons.sync, "Sincro"),
                    _buildNavItem(3, Icons.person_outline, Icons.person, "Perfil"),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.volt : Colors.black45,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.volt : Colors.black45,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final int index;
  BNBCustomPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double width = size.width;
    double itemWidth = width / 4;
    double centerX = (itemWidth * index) + (itemWidth / 2);

    Path path = Path();
    path.moveTo(0, 25); 
    
    // Left straight line before curve
    path.lineTo(centerX - 40, 25);
    
    // The "Dip" curve
    path.cubicTo(
      centerX - 20, 25, 
      centerX - 25, 0, 
      centerX, 0,
    );
    path.cubicTo(
      centerX + 25, 0, 
      centerX + 20, 25, 
      centerX + 40, 25,
    );

    // Right straight line
    path.lineTo(width, 25);
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 15, true);
    canvas.drawPath(path, paint);

    // Draw the dot indicator
    Paint dotPaint = Paint()..color = AppColors.volt;
    canvas.drawCircle(Offset(centerX, 10), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter oldDelegate) {
    return oldDelegate.index != index;
  }
}
