import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_machine_animation/state_machine_animation.dart';
import '../controller/world_asset_widget_bloc.dart';
import '../world_asset.dart';
import 'world_asset_render_model.dart';

class WorldAssetInternal extends StatelessWidget {

  const WorldAssetInternal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener<double>(
      stream: context.read<BehaviorSubject<WorldAssetRenderModel>>().map((model) => model.order).distinct(),
      onData: (distance) => context.read<WorldAsset>().controller.add(UpdateCameraDistance(distance)), // just update the order in world bloc
      child: BehaviorSubjectBuilder<WorldAssetRenderModel>(
        subject: context.read<BehaviorSubject<WorldAssetRenderModel>>(),
        subjectBuilder: (context, model) => Positioned(
            // Scene is bigger than the screen, so we move the container, to align their centers
          left: -(model.scene.size.width - model.scene.screenSize.width) / 2,
          top: -(model.scene.size.height - model.scene.screenSize.height) / 2,
          child: Transform(
            transform: model.transformation,
            child: Container(
              clipBehavior: model.asset.customBorder != null ? Clip.hardEdge : Clip.none,
              decoration: model.asset.customBorder != null
                  ? ShapeDecoration(shape: model.asset.customBorder!)
                  : null, //BoxDecoration(border: Border.all(color: const Color.fromRGBO(255, 0, 0, 1), width: 1)),
              width: (model.asset.size ?? model.scene.screenSize).width,
              height: (model.asset.size ?? model.scene.screenSize).height,
              child: context.read<WorldAsset>().child
            )
          )
        )
      )
    );
  }
}
