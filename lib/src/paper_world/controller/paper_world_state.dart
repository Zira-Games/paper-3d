part of 'paper_world_bloc.dart';

class GameWorldState extends Equatable {
  final List<WorldAsset> allAssets;
  final Map<String, double> loadedOrders;
  final List<WorldAsset> orderedAssets;

  GameWorldState(this.allAssets, this.loadedOrders) : orderedAssets = getOrderedAssets(allAssets, loadedOrders);

  @override List<Object> get props => [allAssets, loadedOrders];

  GameWorldState copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders
  }) => GameWorldState(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders
  );

  GameWorldState toInitial () => GameWorldState(allAssets, loadedOrders);
  GameWorldReady toReady () => GameWorldReady(allAssets, loadedOrders);

  static List<WorldAsset> getOrderedAssets(List<WorldAsset> allAssets, Map<String, double> loadedOrders) =>
    loadedOrders.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .map((pair) => allAssets.firstWhere((a) => a.id == pair.key))
        .toList();

}

class GameWorldReady extends GameWorldState {
  GameWorldReady(super.allAssets, super.loadedOrders);

  @override
  GameWorldReady copyWith({
    List<WorldAsset>? allAssets,
    Map<String, double>? loadedOrders
  }) => GameWorldReady(
    allAssets ?? this.allAssets,
    loadedOrders ?? this.loadedOrders
  );

}
