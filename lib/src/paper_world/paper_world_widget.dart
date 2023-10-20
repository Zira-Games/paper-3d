import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../3d-utils/base_camera_model.dart';
import '../world_asset/world_asset.dart';
import '../world_asset/world_asset_internal/world_asset_internal.dart';
import '../world_asset/world_asset_internal/world_asset_internal_state.dart';
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
        Provider<BehaviorSubject<CameraModel>>.value(value: camera),
        BlocProvider<PaperWorldBloc>(create: (context) => PaperWorldBloc(assets, camera, screen))
      ],
      child: BlocBuilder<PaperWorldBloc, GameWorldState>(
        builder: (context, state) => state is GameWorldReady
          ? Container(
            color: background ?? Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: state.orderedPairs.map((pair) => MultiProvider(
                key: Key(pair.id),
                providers: [
                  Provider<WorldAsset>.value(value: pair.worldAsset),
                  Provider<BehaviorSubject<WorldAssetInternalState>>.value(value: pair.worldAssetStateStream)
                ],
                child: const WorldAssetInternal()
              )).toList()
            )
          ) : SizedBox()
      )
    );
  }
}