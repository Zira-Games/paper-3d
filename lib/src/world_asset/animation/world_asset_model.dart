import 'dart:ui';

import 'package:state_machine_animation/state_machine_animation.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../svg-shape-border.dart';
import '../../util/screen_size.dart';

abstract class WorldAssetModel extends AnimationModel {

  final String id;
  final ScreenSize screenSize;

  final double rotateX;
  final double rotateY;
  final double rotateZ;
  final double scale;
  late final Vector3 position;
  final double effectivePositionDistance;

  late final Matrix4 toTranslateToCenterMatrix;

  final Size? size;
  final SvgShapeBorder? customBorder;

  final double? permanentOrder; // order should ignore distance
  final bool followsTheCamera;
  final bool looksAtTheCamera;

  WorldAssetModel(
    this.id,
    this.screenSize,
    {
      Vector3? position,
      this.rotateX = 0,
      this.rotateY = 0,
      this.rotateZ = 0,
      this.scale = 1,
      this.size,
      this.customBorder,
      this.permanentOrder,
      this.followsTheCamera = false,
      this.looksAtTheCamera = false,
      this.effectivePositionDistance = 0
    }){
    assert(!(followsTheCamera && looksAtTheCamera), "Can't be sticky and staring at the same time");
    /*
    // so that we can provider rotation independent position
    if( rotateX != 0 || rotateY != 0 || rotateZ != 0){
      Quaternion rotation = Quaternion.identity();
      if( rotateX != 0 ){
        rotation *= Quaternion.axisAngle(WorldAssetRenderModel.xAxis, rotateX);
      }
      if( rotateY != 0 ){
        rotation *= Quaternion.axisAngle(WorldAssetRenderModel.yAxis, rotateY);
      }
      if( rotateZ != 0 ){
        rotation *= Quaternion.axisAngle(WorldAssetRenderModel.zAxis, rotateZ);
      }
      this.position = rotation.inverted().rotated(position ?? Vector3.zero());
    } else {
      this.position = position ?? Vector3.zero();
    }
     */
    this.position = position ?? Vector3.zero();
    toTranslateToCenterMatrix = Matrix4.translation(Vector3(
      (screenSize.height - (size ?? screenSize.size).width) / screenSize.height,
      -(screenSize.height - (size ?? screenSize.size).height) / screenSize.height,
      0.0
    ));
  }

  @override List<Object?> get props => [id, screenSize, scale, rotateX, rotateY, rotateZ, position, size, followsTheCamera, looksAtTheCamera, customBorder];

  @override AnimationModel copyWith(Map<String, dynamic> valueMap);

}