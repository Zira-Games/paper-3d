part of 'world_asset_widget_bloc.dart';

abstract class WorldAssetWidgetEvent extends Equatable {
  const WorldAssetWidgetEvent();

  @override List<Object?> get props => [];
}

class LoadAsset extends WorldAssetWidgetEvent {
  const LoadAsset();
}

class UnloadAsset extends WorldAssetWidgetEvent {
  const UnloadAsset();
}

class UpdateCameraDistance extends WorldAssetWidgetEvent {
  final double distance;
  const UpdateCameraDistance(this.distance);
  @override List<Object?> get props => [distance];
}