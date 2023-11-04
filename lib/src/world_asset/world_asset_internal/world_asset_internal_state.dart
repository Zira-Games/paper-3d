import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:paper_3d/paper_3d.dart';
import 'package:paper_3d/src/3d-utils/culling.dart';
import 'package:paper_3d/src/3d-utils/world_asset_model_transformation.dart';
import 'package:vector_math/vector_math_64.dart';

class WorldAssetInternalState extends Equatable {

  late final bool shouldRender;
  late final double order;
  late final Matrix4 transformation;
  late final SvgShapeBorder? customBorder;

  late final double left;
  late final double top;
  late final double width;
  late final double height;

  WorldAssetInternalState(CameraModel camera, WorldAssetModel asset, Size screenSize) {
    final scene = Scene(screenSize, screenSize.square);
    final modelMatrix = getModelTransformation(camera, asset);

    shouldRender = !threeJsCulling(camera, scene, asset, modelMatrix);
    customBorder = asset.customBorder;
    order = camera.positionVector.xz.distanceTo(modelMatrix.getTranslation().xz);

    // Scene is bigger than the screen, so we move the container, to align their centers
    left = -(scene.size.width - scene.screenSize.width) / 2;
    top = -(scene.size.height - scene.screenSize.height) / 2;

    width = (asset.size ?? scene.screenSize).width;
    height = (asset.size ?? scene.screenSize).height;

    final mvp = camera.cameraMatrix * modelMatrix * asset.toTranslateToCenterMatrix;
    transformation = scene.coordinateConversion(mvp);
  }

  @override List<Object?> get props => [shouldRender, transformation, order, customBorder, left, top, width, height];

}