// https://bruop.github.io/frustum_culling/

import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

bool shouldCull(Matrix4 viewMatrix, Matrix4 modelTransformation, Aabb3 aabb)
{
    return false;
}

/*
    final width = scene.widthToGL(asset.size?.width ?? 0) * asset.scale;
    final height = scene.heightToGL(asset.size?.height ?? 0) * asset.scale /2;
    // TODO dividing by two is a stop gap solution, there is something wrong with this calculation but I don't know what.
    final topLeft = Vector3(- width / 2, height / 2, 0) / 2;
    final topRight = Vector3(width / 2, height / 2, 0) / 2;
    final bottomLeft = Vector3(- width / 2, - height / 2, 0)  / 2;
    final bottomRight = Vector3(width / 2, - height / 2, 0) / 2;

    final corner1 = rotation.rotated(topLeft) + asset.position;
    final corner2 = rotation.rotated(topRight) + asset.position;
    final corner3 = rotation.rotated(bottomLeft) + asset.position;
    final corner4 = rotation.rotated(bottomRight) + asset.position;

 */