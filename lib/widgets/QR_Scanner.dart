import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerDialogContent extends StatefulWidget {
  const QrScannerDialogContent({super.key});

  @override
  State<QrScannerDialogContent> createState() => _QrScannerDialogContentState();
}

class _QrScannerDialogContentState extends State<QrScannerDialogContent> {
  final MobileScannerController qrController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isFlashOn = false;
  bool _isCameraFacingFront = false;

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      backgroundColor: colors.surface,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: colors.surfaceVariant,
              child: Row(
                children: [
                  Icon(Icons.qr_code_scanner, color: colors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Scan QR Code',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
        
            // Scanner Area
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: qrController,
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull;
                      if (barcode?.rawValue != null) {
                        qrController.stop();
                        Navigator.pop(context, barcode!.rawValue);
                      }
                    },
                  ),
                  CustomPaint(painter: _QrScannerOverlay()),
        
                  // Controls
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          onPressed: () {
                            setState(() {
                              _isFlashOn = !_isFlashOn;
                              qrController.toggleTorch();
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        _buildControlButton(
                          icon: Icons.cameraswitch_rounded,
                          onPressed: () {
                            setState(() {
                              _isCameraFacingFront = !_isCameraFacingFront;
                              qrController.switchCamera();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: colors.surfaceVariant,
              child: Text(
                'Align the QR code within the frame',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: icon.toString(),
      mini: true,
      elevation: 1,
      backgroundColor: Colors.white,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.black87),
    );
  }
}
class _QrScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = size.center(Offset.zero);
    const scannerSize = 240.0;
    final rect = Rect.fromCenter(
      center: center,
      width: scannerSize,
      height: scannerSize,
    );

    // Draw frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      paint,
    );

    // Draw corners
    final cornerPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 20.0;
    
    // Top-left
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Top-right
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Bottom-left
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -cornerLength),
      cornerPaint,
    );
    
    // Bottom-right
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}