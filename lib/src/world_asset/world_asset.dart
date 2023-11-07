import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';

import 'animation/world_asset_model.dart';

class WorldAsset<M extends WorldAssetModel> {

  String get id => animation.value.id;

  final BehaviorSubject<M> animation;
  final StatelessWidget child;

  WorldAsset({required this.animation, required this.child});

}