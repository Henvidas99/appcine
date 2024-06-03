import 'package:flutter/material.dart';


class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.07, size.height * 0.8);
    path.lineTo(size.width * 0.38, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.25,
        size.width * 0.62, size.height * 0.35);
    path.lineTo(size.width * 0.93, size.height * 0.8);

    canvas.drawPath(path, paint);
    canvas.drawShadow(
        path, const Color(0xFFE50914).withOpacity(0.3), 10, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
