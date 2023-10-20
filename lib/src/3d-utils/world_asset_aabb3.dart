import 'package:paper_3d/paper_3d.dart';
import 'package:vector_math/vector_math_64.dart';

Aabb3 getAabb3FromWorldAsset(WorldAssetModel asset, Matrix3 rotation, Scene scene){
  final width = scene.widthToGL(asset.size?.width ?? 0) * asset.scale;
  final height = scene.heightToGL(asset.size?.height ?? 0) * asset.scale /2;
  // TODO dividing by two is a stop gap solution, there is something wrong with this calculation but I don't know what.
  final topLeft = Vector3(- width / 2, height / 2, 0) / 2;
  final topRight = Vector3(width / 2, height / 2, 0) / 2;
  final bottomLeft = Vector3(- width / 2, - height / 2, 0)  / 2;
  final bottomRight = Vector3(width / 2, - height / 2, 0) / 2;


  final corner1 = rotation.transformed(topLeft) + asset.position;
  final corner2 = rotation.transformed(topRight) + asset.position;
  final corner3 = rotation.transformed(bottomLeft) + asset.position;
  final corner4 = rotation.transformed(bottomRight) + asset.position;

  Aabb3 aabb3 = Aabb3.minMax(corner1, corner4);

  return aabb3;
}