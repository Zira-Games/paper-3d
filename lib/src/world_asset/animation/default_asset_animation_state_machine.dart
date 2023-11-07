import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

class DefaultAssetAnimationStateMachine extends AnimationStateMachine<Object> {

  DefaultAssetAnimationStateMachine(BehaviorSubject<Object> source, TickerManager tickerManager) : super(source, tickerManager);

  @override
  AnimationStateMachineConfig<Object> getConfig(Object state) =>
  const AnimationStateMachineConfig(
    defaultDuration: 1000,
    nodes: ["IDLE"],
    initialState: Idle("IDLE")
  );

  @override bool isReady(Object state) => true;

  @override
  void reactToStateChanges(state, previous) {}

}
