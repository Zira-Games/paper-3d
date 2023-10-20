part of 'paper_world_bloc.dart';

class GameWorldState extends Equatable {
  final List<WorldAsset> allAssets;
  final Map<String, double> loadedOrders;
  final BehaviorSubject<CameraModel> camera;
  final BehaviorSubject<Size> screen;

  final List<AssetStreamPair> orderedPairs;

  GameWorldState(
    this.allAssets,
    this.loadedOrders,
    this.camera,
    this.screen
  ) : orderedPairs = getOrderedPairs(allAssets, loadedOrders, camera, screen);

  @override List<Object> get props => [allAssets, loadedOrders, camera, screen, orderedPairs];

  GameWorldState copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders,
    BehaviorSubject<CameraModel>? camera,
    BehaviorSubject<Size>? screen
  }) => GameWorldState(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders,
    camera ?? this.camera,
    screen ?? this.screen
  );

  GameWorldState toInitial () => GameWorldState(allAssets, loadedOrders, camera, screen);
  GameWorldReady toReady () => GameWorldReady(allAssets, loadedOrders, camera, screen);

  static List<AssetStreamPair> getOrderedPairs(List<WorldAsset> allAssets, Map<String, double> loadedOrders, BehaviorSubject<CameraModel> camera, BehaviorSubject<Size> screen) =>
    loadedOrders.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .map((pair) => allAssets.firstWhere((a) => a.id == pair.key))
        .map((asset) => AssetStreamPair(
          asset,
          combineSubject3<WorldAssetModel, CameraModel, Size, WorldAssetInternalState>(
              asset.controller.animation,
              camera,
              screen,
              (model, camera, screenSize) => WorldAssetInternalState(camera, model, screenSize)
          )
        )).toList();

}

class GameWorldReady extends GameWorldState {
  GameWorldReady(super.allAssets, super.loadedOrders, super.camera, super.screen);

  @override
  GameWorldReady copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders,
    BehaviorSubject<CameraModel>? camera,
    BehaviorSubject<Size>? screen
  }) => GameWorldReady(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders,
    camera ?? this.camera,
    screen ?? this.screen
  );

}

class AssetStreamPair extends Equatable {
  final WorldAsset worldAsset;
  final BehaviorSubject<WorldAssetInternalState> worldAssetStateStream;

  String get id => worldAsset.id;

  const AssetStreamPair(this.worldAsset, this.worldAssetStateStream);

  @override List<Object> get props => [worldAsset, worldAssetStateStream];

  AssetStreamPair copyWith({
    WorldAsset? worldAsset,
    BehaviorSubject<WorldAssetInternalState>? worldAssetStateStream
  }) => AssetStreamPair(
    worldAsset ?? this.worldAsset,
    worldAssetStateStream ?? this.worldAssetStateStream,
  );

}