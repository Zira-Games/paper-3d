import 'dart:collection';

import 'package:equatable/equatable.dart';
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
    return Provider<BehaviorSubject<PaperWorldState>>(
      create: (context) => getPaperWorldStateSubject(assets, camera, screen),
      dispose: (context, value) => value.close(),
      builder: (context, child) => BehaviorSubjectBuilder<PaperWorldState>(
          subject: context.read<BehaviorSubject<PaperWorldState>>(),
          subjectBuilder: (context, state) => Container(
              color: background ?? Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                  children: state.elements.map((asset) => Provider<WorldAssetContents>.value(
                      value: asset,
                      key: Key(asset.id),
                      child: const WorldAssetInternal()
                  )).toList()
              )
          )
      )
    );
  }
}

BehaviorSubject<PaperWorldState> getPaperWorldStateSubject(List<WorldAsset> assets, BehaviorSubject<CameraModel> camera, BehaviorSubject<Size> screen){
  final contents = assets
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
  );

  final assetContentsAndOrderStreams = contents.map((wac) =>
      wac.worldAssetStateStream
          .map<double>((state) => wac.worldAsset.animation.value.permanentOrder ?? state.order)
          .distinctUnique()
          .map((order) => (order, wac))
  );
  final stream = Rx.combineLatest<(double, WorldAssetContents), PaperWorldState>(
      assetContentsAndOrderStreams,
      (values) => PaperWorldState(SplayTreeSet<(double, WorldAssetContents)>.of(values, (a, b) => b.$1.compareTo(a.$1)).map((element) => element.$2).toList())
  ).distinctUnique();

  final seed = PaperWorldState(SplayTreeSet<(double, WorldAssetContents)>.of(contents.map((wac) => (wac.worldAsset.animation.value.permanentOrder ?? wac.worldAssetStateStream.value.order, wac)), (a, b) => b.$1.compareTo(a.$1)).map((e) => e.$2).toList());

  return BehaviorSubject<PaperWorldState>.seeded(seed)..addStream(stream);
}

class PaperWorldState extends Equatable {

  final List<WorldAssetContents> elements;

  const PaperWorldState(this.elements);

  @override List<Object?> get props => [elements];

  @override
  bool operator ==(Object other) =>
      other is PaperWorldState &&
          other.runtimeType == runtimeType &&
          other.elements.length == elements.length &&
          other.elements.map((e) => e.worldAsset.id).join(",") == elements.map((e) => e.worldAsset.id).join(",");

  @override
  int get hashCode => elements.map((e) => e.worldAsset.id).join(",").hashCode;

}