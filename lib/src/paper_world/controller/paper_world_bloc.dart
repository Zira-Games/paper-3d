import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../world_asset/controller/world_asset_widget_bloc.dart';
import '../../world_asset/world_asset.dart';

part 'paper_world_event.dart';
part 'paper_world_state.dart';

class PaperWorldBloc extends Bloc<GameWorldEvent, GameWorldState> {

  final List<WorldAsset> declaredAssets;

  PaperWorldBloc(this.declaredAssets) : super(const GameWorldState({})) {
    on<AddAsset>(_onAddAsset);
    on<RemoveAsset>(_onRemoveAssets);
    on<UpdateAssetOrder>(_onUpdateAssetOrder);
    on<Ready>(_onReady);
    on<NotReady>(_onNotReady);

    add(const Ready());
    for(final asset in declaredAssets){
      asset.controller.paperWorld = this;
      if(asset.controller.state is WorldAssetLoaded){
        add(AddAsset(asset.id, asset.controller.state.order));
      }
    }
  }

  FutureOr<void> _onAddAsset(AddAsset event, Emitter<GameWorldState> emit) {
    final pairs = <String, double>{...state.idOrderPairs};
    if ( !pairs.containsKey(event.id) ) {
      pairs[event.id] = event.order;
      emit(state.copyWith(idOrderPairs: pairs));
    }
  }

  FutureOr<void> _onRemoveAssets(RemoveAsset event, Emitter<GameWorldState> emit) {
    final pairs = <String, double>{...state.idOrderPairs};
    if ( pairs.containsKey(event.id) ) {
      pairs.remove(event.id);
      emit(state.copyWith(idOrderPairs: pairs));
    }
  }

  FutureOr<void> _onUpdateAssetOrder(UpdateAssetOrder event, Emitter<GameWorldState> emit) {
    final pairs = <String, double>{...state.idOrderPairs};
    if ( pairs.containsKey(event.id) ) {
      pairs[event.id] = event.order;
      emit(state.copyWith(idOrderPairs: pairs));
    }
  }

  FutureOr<void> _onReady(Ready event, Emitter<GameWorldState> emit) {
    emit(state.toReady());
  }

  FutureOr<void> _onNotReady(NotReady event, Emitter<GameWorldState> emit) {
    emit(state.toInitial());
  }

  @override
  Future<void> close() {
    for(final asset in declaredAssets){
      asset.controller.paperWorld = null;
    }
    return super.close();
  }

}
