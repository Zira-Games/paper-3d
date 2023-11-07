import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_3d/src/world_asset/world_asset_contents.dart';
import 'package:state_machine_animation/state_machine_animation.dart';
import 'world_asset_internal_state.dart';

class WorldAssetInternal extends StatelessWidget {

  const WorldAssetInternal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BehaviorSubjectBuilder<WorldAssetInternalState>(
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
    );
  }
}
