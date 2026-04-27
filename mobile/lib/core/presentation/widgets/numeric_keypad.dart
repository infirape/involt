import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const NumericKeypad({
    super.key,
    required this.controller,
    this.onChanged,
  });

  void _onKeyTap(String val) {
    final text = controller.text;
    
    if (val == '.') {
      if (text.contains('.')) return; // Prevent multiple decimals
      if (text.isEmpty) {
        controller.text = '0.';
      } else {
        controller.text = text + val;
      }
    } else {
      controller.text = text + val;
    }
    
    onChanged?.call();
  }

  void _onDelete() {
    final text = controller.text;
    if (text.isNotEmpty) {
      controller.text = text.substring(0, text.length - 1);
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 12),
        _buildRow(['.', '0', 'DEL']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildKey(key);
      }).toList(),
    );
  }

  Widget _buildKey(String label) {
    bool isSpecial = label == 'DEL' || label == '.';
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (label == 'DEL') {
                _onDelete();
              } else {
                _onKeyTap(label);
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: isSpecial ? AppColors.magenta.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSpecial ? AppColors.magenta.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Center(
                child: label == 'DEL' 
                  ? const Icon(Icons.backspace_outlined, color: AppColors.magenta, size: 22)
                  : Text(
                      label,
                      style: TextStyle(
                        color: isSpecial ? AppColors.magenta : Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
