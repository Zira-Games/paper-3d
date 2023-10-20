import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:paper_3d/src/3d-utils/base_camera_model.dart';
import 'package:paper_3d/src/paper_world/paper_world_widget.dart';
import 'package:paper_3d/src/util/screen_size.dart';
import 'package:paper_3d/src/world_asset/animation/world_asset_model.dart';
import 'package:paper_3d/src/world_asset/controller/world_asset_widget_bloc.dart';
import 'package:paper_3d/src/world_asset/world_asset.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(home: const World()));
}

class World extends StatelessWidget {
  const World({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTickerManager tickerManager = AppTickerManager();
    final ScreenSize screenSize = ScreenSize(MediaQuery.of(context).size);
    final BehaviorSubject<Size> screenSubject = BehaviorSubject<Size>.seeded(screenSize.size);
    final BehaviorSubject<AwesomeCameraModel> cameraSubject = BehaviorSubject<AwesomeCameraModel>.seeded(AwesomeCameraModel(
      CameraModel.defaultCamera,
      CameraModel.defaultLookAt
    ));

    return PaperWorldWidget(
      background: Color(0xFFFFFFFF),
      camera: cameraSubject,
      screen: screenSubject,
      assets: [
        AwesomeAsset(Uuid().v4(), screenSize, tickerManager)
      ]
    );
  }

}

class AwesomeCameraModel extends CameraModel {

  AwesomeCameraModel(super.positionVector, super.lookAtVector);

  @override
  AwesomeCameraModel copyWith(Map<String, dynamic> valueMap) => AwesomeCameraModel(
    valueMap["positionVector"] ?? positionVector,
    valueMap["lookAtVector"] ?? lookAtVector,
  );

}

class AwesomeAsset extends WorldAsset {

  AwesomeAsset(String id, ScreenSize screenSize, TickerManager tickerManager) : super(
    controller: DefaultAssetController<AwesomeAssetModel>(AwesomeAssetModel(id, screenSize), tickerManager),
    child: Container(color: Color(0xFF000000))
  );

}

class AwesomeAssetModel extends WorldAssetModel {

  AwesomeAssetModel(super.id, super.screenSize);

  @override
  AnimationModel copyWith(Map<String, dynamic> valueMap) => AwesomeAssetModel(
    valueMap["id"] ?? id,
    valueMap["screenSize"] ?? screenSize,
  );

}
class AppTickerManager implements TickerManager {

  final List<Ticker> _tickers = <Ticker>[];

  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = Ticker(onTick);
    _tickers.add(ticker);
    return ticker;
  }

  @override
  void disposeTicker(Ticker ticker){
    ticker.dispose();
    _tickers.remove(ticker);
  }

}