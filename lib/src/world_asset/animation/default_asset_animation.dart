import 'package:state_machine_animation/state_machine_animation.dart';

import '../animation/default_asset_animation_state_machine.dart';
import 'world_asset_model.dart';

class DefaultAssetAnimation<M extends WorldAssetModel> extends AnimationContainer<Object, M> {
  DefaultAssetAnimation(DefaultAssetAnimationStateMachine fsm, M initial) : super(stateMachine: fsm, initial: initial, properties: []);
}
