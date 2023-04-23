import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:paper_3d/src/base_camera_model.dart';
import 'package:paper_3d/src/util/screen_size.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../scene.dart';
import '../animation/world_asset_model.dart';

// TODO If the provided transform is a translation matrix, it is much faster to use pushOffset with the translation offset instead.
// TODO model rotations are not stable with model position. change rotation quaternions by model position maybe?
class WorldAssetRenderModel extends Equatable {

  static final xAxis = Vector3(1.0, 0.0, 0.0);
  static final yAxis = Vector3(0.0, 1.0, 0.0);
  static final zAxis = Vector3(0.0, 0.0, 1.0);

  static double rotationYAdjustment(CameraModel camera, WorldAssetModel asset, Vector3 assetPosition){
    if( asset.looksAtTheCamera ){
      return angleBetween(camera.positionVector, assetPosition);
    } else if( asset.followsTheCamera ){
      return cameraAngle(camera);
    } else {
      return 0;
    }
  }

  static double angleBetween(Vector3 cameraPosition, Vector3 modelPosition){
    final modelPositionOnCameraPlane = (modelPosition - cameraPosition)..normalize();
    final angle = modelPositionOnCameraPlane.z != 0.0 ? atan(modelPositionOnCameraPlane.x / modelPositionOnCameraPlane.z) : 0.0;
    final zFlip = (modelPosition - cameraPosition).z > 0;
    return angle.isNaN ? 0 : angle + ((zFlip ? pi : 0));
  }

  static double cameraAngle(CameraModel camera) => angleBetween(camera.positionVector, camera.lookAtVector);

  static Vector3 preRotationPositionAdjustment(WorldAssetModel asset, Vector3 cameraPosition) {
    final tempPosition = Vector3.zero();
    asset.position.copyInto(tempPosition);
    if( asset.effectivePositionDistance != 0 ){
      final angle = angleBetween(cameraPosition, asset.position);
      final effectiveTranslation = Vector3(asset.effectivePositionDistance, 0, 0);
      final rotatedTranslation = Quaternion.axisAngle(yAxis,-angle).rotated(effectiveTranslation);
      final zFlip = (asset.position - cameraPosition).z > 0;
      return tempPosition + (zFlip ? -rotatedTranslation : rotatedTranslation);
    }
    return tempPosition;
  }

  static Vector3 postRotationPositionAdjustment(WorldAssetModel asset, Vector3 cameraPosition, double rotateYAdjustment, Vector3 assetPosition) {
    if( asset.followsTheCamera ){
      return Quaternion.axisAngle(yAxis, rotateYAdjustment).inverted().rotated(assetPosition) + cameraPosition;
    } else {
      return assetPosition;
    }
  }

  final CameraModel camera;
  final WorldAssetModel asset;
  final Scene scene;

  late final double order;
  late final Matrix4 transformation;

  WorldAssetRenderModel(this.camera, this.asset, Size screenSize)
    : scene = Scene(screenSize, screenSize.square) {
      final Vector3 preRotationPosition = preRotationPositionAdjustment(asset, camera.positionVector);
      final double rotateYAdjustment = rotationYAdjustment(camera, asset, preRotationPosition);
      final Vector3 adjustedPosition = postRotationPositionAdjustment(asset, camera.positionVector, rotateYAdjustment, preRotationPosition);
      order = camera.positionVector.distanceTo(adjustedPosition);
      final rotation = Quaternion.axisAngle(Quaternion.axisAngle(yAxis, -rotateYAdjustment).rotated(zAxis), asset.rotateZ) * Quaternion.axisAngle(Quaternion.axisAngle(yAxis, -rotateYAdjustment).rotated(xAxis), asset.rotateX) * Quaternion.axisAngle(yAxis, rotateYAdjustment + asset.rotateY);
      final modelMatrix = Matrix4.compose(adjustedPosition, rotation, Vector3.all(asset.scale));
      transformation = PointerEvent.removePerspectiveTransform(
        scene.toFlutterCoords *
        camera.cameraMatrix *
        modelMatrix *
        asset.toTranslateToCenterMatrix *
        scene.toOpenGlCoords
      );
  }

  @override List<Object?> get props => [camera, asset, scene, transformation, order];


}