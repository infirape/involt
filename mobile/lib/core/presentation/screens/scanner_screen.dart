import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Camera Feed
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanned) return; // Prevent multiple pops
              
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  _isScanned = true;
                  Future.microtask(() async {
                    await controller.stop();
                    if (context.mounted) {
                      Navigator.pop(context, code);
                    }
                  });
                }
              }
            },
          ),

          // 2. Custom Scanner Overlay
          _buildScannerOverlay(context),

          // 3. Close Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 4. Torch Button
          Positioned(
            bottom: 50,
            right: 20,
            child: CircleAvatar(
              backgroundColor: AppColors.cyan.withOpacity(0.3),
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, state, child) {
                  final torchState = state.torchState;
                  return IconButton(
                    icon: Icon(
                      torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                      color: torchState == TorchState.on ? AppColors.cyan : Colors.white,
                    ),
                    onPressed: () => controller.toggleTorch(),
                  );
                },
              ),
            ),
          ),

          // 5. Instruction Text
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Apunta al código QR o de Barras',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    final scanArea = MediaQuery.of(context).size.width * 0.7;
    return Stack(
      children: [
        // Darken areas outside the scan square
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanArea,
                  height: scanArea,
                  decoration: BoxDecoration(
                    color: Colors.red, // This will be cut out
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Neon borders for the scan area
        Align(
          alignment: Alignment.center,
          child: Container(
            width: scanArea,
            height: scanArea,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cyan, width: 2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
        // Animated Scan Line
        _AnimatedScanLine(width: scanArea),
      ],
    );
  }
}

class _AnimatedScanLine extends StatefulWidget {
  final double width;
  const _AnimatedScanLine({required this.width});

  @override
  State<_AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<_AnimatedScanLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: (MediaQuery.of(context).size.height - widget.width) / 2 + (widget.width * _controller.value),
          left: (MediaQuery.of(context).size.width - widget.width) / 2,
          child: Container(
            width: widget.width,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.cyan,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
