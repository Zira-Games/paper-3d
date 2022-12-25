part of 'world_asset_widget_bloc.dart';

abstract class WorldAssetState extends Equatable {
  final double order;

  const WorldAssetState(this.order);

  @override List<Object> get props => [order];

  WorldAssetUnloaded toUnloaded () => WorldAssetUnloaded(order);
  WorldAssetLoaded toLoaded () => WorldAssetLoaded(order);

  WorldAssetState copyWith({double? order});
}

class WorldAssetUnloaded extends WorldAssetState {
  const WorldAssetUnloaded(super.order);

  @override
  WorldAssetUnloaded copyWith({double? order}) => WorldAssetUnloaded(order ?? this.order);
}

class WorldAssetLoaded extends WorldAssetState {
  const WorldAssetLoaded(super.order);

  @override
  WorldAssetLoaded copyWith({double? order}) => WorldAssetLoaded(order ?? this.order);
}