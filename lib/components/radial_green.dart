import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RadialGreen extends StatelessWidget {
  const RadialGreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const size = 469.0;
    return CustomPaint(
      size: Size(
          size,
          (size * 0.7507987220447284)
              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
      painter: RPSCustomPainter(),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader =
        ui.Gradient.radial(const Offset(0, 0), size.width * 0.003194888, [
      const Color(0xff94FF0C).withOpacity(0.43),
      const Color(0xffB5FF16).withOpacity(0)
    ], [
      0,
      1
    ]);
    canvas.drawCircle(Offset(size.width * 0.7492013, size.height * 0.002127660),
        size.width * 0.7492013, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
