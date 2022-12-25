part of 'paper_world_bloc.dart';

abstract class GameWorldEvent extends Equatable {
  const GameWorldEvent();
}

class Ready extends GameWorldEvent {
  const Ready();
  @override List<Object> get props => [];
}

class NotReady extends GameWorldEvent {
  const NotReady();
  @override List<Object> get props => [];
}

class AddAsset extends GameWorldEvent {
  final String id;
  final double order;

  const AddAsset(this.id, this.order);

  @override List<Object> get props => [id, order];
}

class RemoveAsset extends GameWorldEvent {
  final String id;

  const RemoveAsset(this.id);

  @override List<Object> get props => [id];
}

class UpdateAssetOrder extends GameWorldEvent {
  final String id;
  final double order;

  const UpdateAssetOrder(this.id, this.order);

  @override List<Object> get props => [id, order];
}
