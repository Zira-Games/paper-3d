import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

import '../base_camera_model.dart';
import '../world_asset/animation/world_asset_model.dart';
import '../world_asset/world_asset.dart';
import '../world_asset/world_asset_internal/world_asset_internal.dart';
import '../world_asset/world_asset_internal/world_asset_render_model.dart';
import 'controller/paper_world_bloc.dart';

class PaperWorldWidget extends StatelessWidget {

  final List<WorldAsset> assets;
  final BehaviorSubject<CameraModel> camera;
  final BehaviorSubject<Size> screen;
  final Color? background;

  const PaperWorldWidget({Key? key, required this.assets, required this.camera, this.background, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<PaperWorldBloc>(create: (context) => PaperWorldBloc(assets)),
        Provider<BehaviorSubject<CameraModel>>.value(value: camera)
      ],
      child: BlocBuilder<PaperWorldBloc, GameWorldState>(
        builder: (context, state) => state is GameWorldReady
          ? Container(
            color: background ?? Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: state.assetIds.map((assetId) => MultiProvider(
                key: Key(assetId),
                providers: [
                  Provider<WorldAsset>.value(value: state.allAssets.firstWhere((a) => a.id == assetId)),
                  Provider<BehaviorSubject<WorldAssetRenderModel>>(
                    create: (context) => combineSubject3<WorldAssetModel, CameraModel, Size, WorldAssetRenderModel>(
                      context.read<WorldAsset>().controller.animation,
                      camera,
                      screen,
                      (model, camera, screenSize) => WorldAssetRenderModel(camera, model, screenSize)
                    )
                  )
                ],
                child: const WorldAssetInternal()
              )).toList()
            )
          ) : SizedBox()
      )
    );
  }
}