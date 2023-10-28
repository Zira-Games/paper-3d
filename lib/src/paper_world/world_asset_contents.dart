import 'package:equatable/equatable.dart';
import 'package:paper_3d/paper_3d.dart';
import 'package:rxdart/subjects.dart';

class WorldAssetContents extends Equatable {
  String get id => worldAsset.id;

  final WorldAsset worldAsset;
  final BehaviorSubject<WorldAssetInternalState> worldAssetStateStream;

  const WorldAssetContents(
      this.worldAsset,
      this.worldAssetStateStream
      );

  @override List<Object> get props => [worldAsset, worldAssetStateStream];

  dispose(){
    worldAssetStateStream.close();
  }

}
