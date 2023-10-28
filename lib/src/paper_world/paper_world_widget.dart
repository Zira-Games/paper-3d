import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_3d/src/paper_world/world_asset_contents.dart';
import 'package:paper_3d/src/world_asset/animation/world_asset_model.dart';
import 'package:paper_3d/src/world_asset/world_asset_internal/world_asset_internal_state.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

import '../3d-utils/base_camera_model.dart';
import '../world_asset/world_asset.dart';
import '../world_asset/world_asset_internal/world_asset_internal.dart';
import 'controller/paper_world_bloc.dart';

class PaperWorldWidget extends StatelessWidget {

  final List<WorldAsset> assets;
  final BehaviorSubject<CameraModel> camera;
  final BehaviorSubject<Size> screen;
  final Color? background;

  const PaperWorldWidget({Key? key, required this.assets, required this.camera, this.background, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaperWorldBloc>(
      create: (context) => PaperWorldBloc(assets),
      child: BlocBuilder<PaperWorldBloc, GameWorldState>(
        builder: (context, state) => state is GameWorldReady
          ? Container(
            color: background ?? Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: state.orderedAssets.map((asset) => Provider<WorldAssetContents>(
                create: (context) => WorldAssetContents(asset, combineSubject3<WorldAssetModel, CameraModel, Size, WorldAssetInternalState>(
                  asset.controller.animation,
                  camera,
                  screen,
                  (model, camera, screenSize) => WorldAssetInternalState(camera, model, screenSize)
                )),
                dispose: (context, value) => value.dispose(),
                key: Key(asset.id),
                child: const WorldAssetInternal(),
              )).toList()
            )
          ) : SizedBox()
      )
    );
  }
}