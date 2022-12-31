part of 'paper_world_bloc.dart';

class GameWorldState extends Equatable {
  final List<WorldAsset> allAssets;
  final Map<String, double> loadedOrders;
  List<String> get assetIds => loadedOrders.entries
      .sorted((a, b) => b.value.compareTo(a.value))
      .map((e) => e.key)
      .toList();

  const GameWorldState(this.allAssets, this.loadedOrders);

  @override List<Object> get props => [allAssets, loadedOrders];

  GameWorldState copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders
  }) => GameWorldState(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders,
  );

  GameWorldState toInitial () => GameWorldState(allAssets, loadedOrders);
  GameWorldReady toReady () => GameWorldReady(allAssets, loadedOrders);

}

class GameWorldReady extends GameWorldState {
  const GameWorldReady(super.allAssets, super.idOrderPairs);

  @override
  GameWorldReady copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders
  }) => GameWorldReady(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders,
  );
}
