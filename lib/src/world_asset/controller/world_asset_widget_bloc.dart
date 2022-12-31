import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paper_3d/src/paper_world/controller/paper_world_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';

import '../../util/blocToSubject.dart';
import '../animation/default_asset_animation_state_machine.dart';
import '../animation/default_asset_animation.dart';
import '../animation/world_asset_model.dart';

part 'world_asset_widget_event.dart';
part 'world_asset_widget_state.dart';

abstract class WorldAssetController<M extends WorldAssetModel> extends Bloc<WorldAssetWidgetEvent, WorldAssetState> {

  PaperWorldBloc? paperWorld;

  final M initialModel;
  final WorldAssetState initialState;
  late final BehaviorSubject<M> animation;

  WorldAssetController(this.initialModel, this.initialState) : super(initialState.copyWith(order: initialModel.permanentOrder ?? 0)) {
    on<LoadAsset>(_onLoadAsset);
    on<UnloadAsset>(_onUnloadAsset);
    on<UpdateCameraDistance>(_onUpdateCameraDistance);

    if( state is WorldAssetLoaded ){
      paperWorld?.add(AddAsset(initialModel.id, state.order));
    }
  }

  FutureOr<void> _onLoadAsset(LoadAsset event, Emitter<WorldAssetState> emit) {
    if( state is WorldAssetUnloaded ){
      emit(state.toLoaded());
      paperWorld?.add(AddAsset(initialModel.id, state.order));
    }
  }

  FutureOr<void> _onUnloadAsset(UnloadAsset event, Emitter<WorldAssetState> emit) {
    if( state is WorldAssetLoaded ){
      emit(state.toUnloaded());
      paperWorld?.add(RemoveAsset(initialModel.id));
    }
  }

  FutureOr<void> _onUpdateCameraDistance(UpdateCameraDistance event, Emitter<WorldAssetState> emit) {
    if( state.order != event.distance ){
      emit(state.copyWith(order: event.distance));
      if(initialModel.permanentOrder == null){
        paperWorld?.add(UpdateAssetOrder(initialModel.id, event.distance));
      }
    }
  }

  @override
  close() async {
    if( state is WorldAssetLoaded ){
      paperWorld?.add(RemoveAsset(initialModel.id));
    }
    super.close();
  }

}

class DefaultAssetController<M extends WorldAssetModel> extends WorldAssetController<M> {
  DefaultAssetController(M initialModel, TickerManager manager, { WorldAssetState? initialControllerState }) : super(initialModel, initialControllerState ?? const WorldAssetUnloaded(0)){
    animation = DefaultAssetAnimation<M>(DefaultAssetAnimationStateMachine(blocToSubject(this), manager), initialModel).output;
  }
}