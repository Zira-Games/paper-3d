import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class Scene {

  final Size screenSize;
  final Size size;

  late final Matrix4 toOpenGlCoords;
  late final Matrix4 toFlutterCoords;

  Scene(this.screenSize, this.size) {
    toOpenGlCoords = Matrix4.compose(Vector3(-1.0, 1.0, 0.0), Quaternion.axisAngle(Vector3(1.0, 0.0, 0.0), pi), Vector3(2 / size.width, 2 / size.height, 1.0));
    toFlutterCoords = Matrix4.tryInvert(toOpenGlCoords)!;
  }

  widthToGL(double width) => width * 2 / size.width;
  heightToGL(double width) => width * 2 / size.height;

  modelToSceneCenterTranslation(Size modelSize) => Matrix4.translation(Vector3(
    widthToGL((size.width - modelSize.width)) / 2,
    -heightToGL((size.height - modelSize.height)) / 2,
    0.0
  ));

}
