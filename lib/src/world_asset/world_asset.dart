import 'package:flutter/cupertino.dart';

import 'controller/world_asset_widget_bloc.dart';

class WorldAsset {

  String get id => controller.initialModel.id;

  final WorldAssetController controller;
  final StatelessWidget child;

  WorldAsset({required this.controller, required this.child});

  dispose(){
    controller.paperWorld = null;
    controller.close();
  }

}