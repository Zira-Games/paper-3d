part of 'paper_world_bloc.dart';

class GameWorldState extends Equatable {
  final Map<String, double> idOrderPairs;
  List<String> get assetIds => idOrderPairs.entries
      .sorted((a, b) => b.value.compareTo(a.value))
      .map((e) => e.key)
      .toList();

  const GameWorldState(this.idOrderPairs);

  @override List<Object> get props => [idOrderPairs];

  GameWorldState copyWith({
    Map<String, double>? idOrderPairs
  }) => GameWorldState(
    idOrderPairs ?? this.idOrderPairs,
  );

  GameWorldState toInitial () => GameWorldState(idOrderPairs);
  GameWorldReady toReady () => GameWorldReady(idOrderPairs);

}

class GameWorldReady extends GameWorldState {
  const GameWorldReady(super.idOrderPairs);

  @override
  GameWorldReady copyWith({
    Map<String, double>? idOrderPairs
  }) => GameWorldReady(
    idOrderPairs ?? this.idOrderPairs,
  );
}
