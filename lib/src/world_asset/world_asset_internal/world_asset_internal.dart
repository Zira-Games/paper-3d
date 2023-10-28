import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:paper_3d/src/paper_world/world_asset_contents.dart';
import 'package:state_machine_animation/state_machine_animation.dart';
import '../controller/world_asset_widget_bloc.dart';
import 'world_asset_internal_state.dart';

class WorldAssetInternal extends StatelessWidget {

  const WorldAssetInternal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamListener<double>(
      stream: context.read<WorldAssetContents>().worldAssetStateStream.map((model) => model.order).distinct(),
      onData: (distance) => context.read<WorldAssetContents>().worldAsset.controller.add(UpdateCameraDistance(distance)), // just update the order in world bloc
      child: BehaviorSubjectBuilder<WorldAssetInternalState>(
        subject: context.read<WorldAssetContents>().worldAssetStateStream,
        subjectBuilder: (context, state) => state.shouldRender ? Positioned(
          left: state.left,
          top: state.top,
          child: Transform(
            transform: state.transformation,
            child: Container(
              clipBehavior: state.customBorder != null ? Clip.hardEdge : Clip.none,
              decoration: state.customBorder != null
                  ? ShapeDecoration(shape: state.customBorder!)
                  : null, //BoxDecoration(border: Border.all(color: const Color.fromRGBO(255, 0, 0, 1), width: 1)),
              width: state.width,
              height: state.height,
              child: context.read<WorldAssetContents>().worldAsset.child
            )
          )
        ) : const SizedBox()
      )
    );
  }
}
