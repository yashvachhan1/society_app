import 'package:flutter/material.dart';

/// The app's brand mark: a three-building society skyline with lit windows,
/// set in a white rounded badge. Used on the splash and auth screens so the
/// branding stays consistent everywhere.
class SkylineLogo extends StatelessWidget {
  const SkylineLogo({super.key, this.size = 104, this.radius = 28});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.58,
          height: size * 0.58,
          child: const CustomPaint(painter: _SkylinePainter()),
        ),
      ),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  const _SkylinePainter();

  // Window top-left positions in the 48x48 design space (2.6 units square).
  static const List<Offset> _windows = [
    Offset(9, 24), Offset(12.8, 24), Offset(9, 29),
    Offset(12.8, 29), Offset(9, 34), Offset(12.8, 34),
    Offset(21, 13), Offset(26.6, 13), Offset(21, 18), Offset(26.6, 18),
    Offset(21, 23), Offset(26.6, 23), Offset(21, 28), Offset(26.6, 28),
    Offset(21, 33), Offset(26.6, 33),
    Offset(34.4, 28), Offset(37.8, 28), Offset(34.4, 33), Offset(37.8, 33),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 48.0;
    Rect r(double x, double y, double w, double h) =>
        Rect.fromLTWH(x * s, y * s, w * s, h * s);
    RRect rr(Rect rect, double radius) =>
        RRect.fromRectAndRadius(rect, Radius.circular(radius * s));

    final left = Paint()..color = const Color(0xFF1E88E5);
    final center = Paint()..color = const Color(0xFF1565C0);
    final right = Paint()..color = const Color(0xFF42A5F5);
    final window = Paint()..color = Colors.white;

    canvas.drawRRect(rr(r(6, 20, 12, 22), 1.5), left);
    canvas.drawRRect(rr(r(18.5, 9, 13, 33), 1.5), center);
    canvas.drawRRect(rr(r(32, 24, 10, 18), 1.5), right);

    for (final w in _windows) {
      canvas.drawRRect(rr(r(w.dx, w.dy, 2.6, 2.6), 0.5), window);
    }
  }

  @override
  bool shouldRepaint(_SkylinePainter oldDelegate) => false;
}
