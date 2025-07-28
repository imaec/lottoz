import 'package:core/core.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController? _controller;
  String? _scanResult;

  @override
  void initState() {
    _controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LottoAppBar(
        title: 'QR 코드로 당첨 확인하기',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              final Barcode? barcode = capture.barcodes.firstOrNull;
              if (barcode != null && barcode.rawValue != null && barcode.rawValue != _scanResult) {
                setState(() {
                  _scanResult = barcode.rawValue!;
                  _showLottoWin();
                });
              }
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth * 0.6;
              final left = (constraints.maxWidth - width) / 2;
              final top = (constraints.maxHeight - width) / 2;
              return Stack(
                children: [
                  // 스캔 영역만 투명
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: width,
                      height: width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: white, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _OverlayPainter(rect: Rect.fromLTWH(left, top, width, width)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  _showLottoWin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (_scanResult != null) {
                launchUrl(url: _scanResult!);
              }
              _scanResult = null;
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(child: Text('당첨 확인하기', style: subtitle1.copyWith(fontSize: 20))),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _scanResult = null;
                        context.pop();
                      });
                    },
                    child: const SvgIcon(asset: closeIcon, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect rect;

  _OverlayPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.dstOut;

    // 전체 사각형에서 rect 부분만 투명하게
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = gray900.withValues(alpha: 0.8),
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) => rect != oldDelegate.rect;
}
