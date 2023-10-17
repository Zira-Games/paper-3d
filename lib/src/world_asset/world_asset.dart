import 'package:flutter/cupertino.dart';

import 'controller/world_asset_widget_bloc.dart';
import 'animation/world_asset_model.dart';

class WorldAsset<C extends WorldAssetController<M>, M extends WorldAssetModel> {

  String get id => controller.initialModel.id;

  final C controller;
  final StatelessWidget child;

  WorldAsset({required this.controller, required this.child});

  dispose(){
    controller.paperWorld = null;
    controller.close();
  }

}