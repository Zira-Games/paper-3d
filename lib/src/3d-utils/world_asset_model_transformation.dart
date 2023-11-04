import 'dart:math';

import 'package:paper_3d/src/3d-utils/base_camera_model.dart';
import 'package:paper_3d/src/util/three_to_vector_math.dart';
import 'package:vector_math/vector_math_64.dart';

import '../world_asset/animation/world_asset_model.dart';

// TODO If the provided transform is a translation matrix, it is much faster to use pushOffset with the translation offset instead.
// TODO model rotations are not stable with model position. change rotation quaternions by model position maybe?
final xAxis = Vector3(1.0, 0.0, 0.0);
final yAxis = Vector3(0.0, 1.0, 0.0);
final zAxis = Vector3(0.0, 0.0, 1.0);

Matrix4 getModelTransformation(CameraModel camera, WorldAssetModel asset){
  final Vector3 preRotationPosition = preRotationEffectivePositionAdjustment(asset, camera.positionVector);
  final double rotateYAdjustment = rotationYAdjustment(camera, asset, preRotationPosition);
  final Vector3 adjustedPosition = postRotationPositionAdjustment(asset, camera.positionVector, rotateYAdjustment, preRotationPosition);
  final rotation = Quaternion.axisAngle(Quaternion.axisAngle(yAxis, -rotateYAdjustment).rotated(zAxis), asset.rotateZ)
      * Quaternion.axisAngle(Quaternion.axisAngle(yAxis, -rotateYAdjustment).rotated(xAxis), asset.rotateX)
      * Quaternion.axisAngle(yAxis, rotateYAdjustment + asset.rotateY);
  return Matrix4.compose(adjustedPosition, rotation, Vector3.all(asset.scale));
}

double rotationYAdjustment(CameraModel camera, WorldAssetModel asset, Vector3 assetPosition){
  if( asset.looksAtTheCamera ){
    return angleBetween(camera.positionVector, assetPosition);
  } else if( asset.followsTheCamera ){
    return cameraAngle(camera);
  } else {
    return 0;
  }
}

double angleBetween(Vector3 cameraPosition, Vector3 modelPosition) => vectorToThree(cameraPosition).angleTo(vectorToThree(modelPosition));

double cameraAngle(CameraModel camera) => angleBetween(camera.positionVector, camera.lookAtVector);

Vector3 preRotationEffectivePositionAdjustment(WorldAssetModel asset, Vector3 cameraPosition) {
  if( asset.effectivePositionDistance == 0 ) {
    return asset.position;
  }
  final angle = angleBetween(cameraPosition, asset.position);
  final effectiveTranslation = Vector3(asset.effectivePositionDistance, 0, 0);
  final rotatedTranslation = Quaternion.axisAngle(yAxis, -angle).rotated(effectiveTranslation);
  return asset.position.clone() + rotatedTranslation;
}

Vector3 postRotationPositionAdjustment(WorldAssetModel asset, Vector3 cameraPosition, double rotateYAdjustment, Vector3 assetPosition) {
  if( asset.followsTheCamera ){
    return Quaternion.axisAngle(yAxis, rotateYAdjustment).inverted().rotated(assetPosition) + cameraPosition;
  } else {
    return assetPosition;
  }
}