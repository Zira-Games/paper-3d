import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as material;

class SvgShapeBorder extends ShapeBorder {

  final Path outlinePath;
  final Size? outlineSize;

  const SvgShapeBorder(this.outlinePath, this.outlineSize);

  @override EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    if( outlineSize != null ){
      final Matrix4 matrix4 = Matrix4.identity()..scale(rect.width / outlineSize!.width, rect.height / outlineSize!.height);
      return outlinePath.transform(matrix4.storage);
    }
    return outlinePath;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if( outlineSize != null ){
      final Matrix4 matrix4 = Matrix4.identity()..scale(rect.width / outlineSize!.width, rect.height / outlineSize!.height);
      return outlinePath.transform(matrix4.storage);
    }
    return outlinePath;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    /*
    var color = material.Colors.primaries[Random().nextInt(material.Colors.primaries.length)];
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(rect, paint);
    */
  }

  @override
  ShapeBorder scale(double t) => SvgShapeBorder(outlinePath, outlineSize);

}