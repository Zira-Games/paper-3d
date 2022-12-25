import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

import '../controller/world_asset_widget_bloc.dart';

class DefaultAssetAnimationStateMachine extends AnimationStateMachine<WorldAssetState> {

  DefaultAssetAnimationStateMachine(BehaviorSubject<WorldAssetState> source, TickerManager tickerManager) : super(source, tickerManager);

  @override
  AnimationStateMachineConfig<WorldAssetState> getConfig(WorldAssetState state) =>
  const AnimationStateMachineConfig(
    defaultDuration: 1000,
    nodes: ["IDLE"],
    initialState: Idle("IDLE")
  );

  @override bool isReady(WorldAssetState state) => true;

  @override
  void reactToStateChanges(state, previous) {}

}
