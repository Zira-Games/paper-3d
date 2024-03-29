import 'dart:math';

import 'package:state_machine_animation/state_machine_animation.dart';
import 'package:vector_math/vector_math_64.dart';

import '../util/numerics.dart';

abstract class CameraModel extends AnimationModel {

  static final defaultCamera = Vector3(0.0, 0.0, 1.0);
  static final defaultLookAt = Vector3(0.0, 0.0, 0.0);
  static final defaultUpVector = Vector3(0.0, 1.0, 0.0);

  static final double viewingDistance = cot(fovYRadians / 2);
  static const double fovYRadians = pi / 2;
  static const double aspectRatio = 1.0;
  static const double defaultLookAtDistance = 2;
  static Matrix4 defaultView = makeViewMatrix(Vector3(0.0, 0.0, 1.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 1.0, 0.0));
  static Matrix4 defaultPerspective = makePerspectiveMatrix(fovYRadians, aspectRatio, defaultLookAtDistance - 1, defaultLookAtDistance * 10);

  final Vector3 positionVector;
  final Vector3 lookAtVector;
  late final Vector3 upVector;

  final Matrix4 perspectiveMatrix;
  final Matrix4 viewMatrix;

  late final Matrix4 cameraMatrix;

  CameraModel(this.positionVector, this.lookAtVector, [Vector3? upVector]) :
        perspectiveMatrix = makePerspectiveMatrix(fovYRadians, aspectRatio, 0, positionVector.distanceTo(lookAtVector) * 20),
        viewMatrix = makeViewMatrix(positionVector, lookAtVector, upVector ?? defaultUpVector){
    cameraMatrix = perspectiveMatrix * viewMatrix;
    this.upVector = upVector ?? defaultUpVector;
  }

  @override List<Object?> get props => [positionVector, lookAtVector, cameraMatrix];

}