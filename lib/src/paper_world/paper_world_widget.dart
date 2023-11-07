import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:paper_3d/src/world_asset/world_asset_contents.dart';
import 'package:paper_3d/src/world_asset/animation/world_asset_model.dart';
import 'package:paper_3d/src/world_asset/world_asset.dart';
import 'package:paper_3d/src/world_asset/world_asset_internal/world_asset_internal_state.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

import '../3d-utils/base_camera_model.dart';
import '../world_asset/world_asset_internal/world_asset_internal.dart';

class PaperWorldWidget extends StatelessWidget {

  final Color? background;
  final List<WorldAsset> assets;
  final BehaviorSubject<CameraModel> camera;
  final BehaviorSubject<Size> screen;

  const PaperWorldWidget({
    Key? key,
    required this.assets,
    required this.camera,
    required this.screen,
    this.background
  }) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return BehaviorSubjectBuilder<List<WorldAssetContents>>(
      subject: getPaperWorldStateStream(assets, camera, screen),
      subjectBuilder: (context, state) => Container(
        color: background ?? Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: state.map((asset) => Provider<WorldAssetContents>.value(
            value: asset,
            key: Key(asset.id),
            child: const WorldAssetInternal()
          )).toList()
        )
      )
    );
  }
}

BehaviorSubject<List<WorldAssetContents>> getPaperWorldStateStream(List<WorldAsset> assets, BehaviorSubject<CameraModel> camera, BehaviorSubject<Size> screen){

  // TODO split the two map functions and use the first variable to create the seed value for the final behaviour subject
  final assetContentsAndOrderStreams = assets
      .map((a) =>
      WorldAssetContents(
          a,
          combineSubject3<WorldAssetModel, CameraModel, Size, WorldAssetInternalState>(
              a.animation,
              camera,
              screen,
                  (model, camera, screenSize) => WorldAssetInternalState(camera, model, screenSize)
          )
      )
  ).map((wac) =>
      wac.worldAssetStateStream.map<double>((state) => state.order).distinctUnique().map((order) => (order, wac))
  );

  final stream =  Rx.combineLatest<(double, WorldAssetContents), List<WorldAssetContents>>(
    assetContentsAndOrderStreams,
    (values) => values.sorted((a, b) => a.$1.compareTo(b.$1)).map((e) => e.$2).toList()
  );

  return BehaviorSubject<List<WorldAssetContents>>()..addStream(stream);
}
