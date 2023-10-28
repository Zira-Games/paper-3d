// https://bruop.github.io/frustum_culling/ if we're doing it manually

import 'package:paper_3d/paper_3d.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:three_dart/three3d/geometries/box_geometry.dart' as three;
import 'package:three_dart/three3d/cameras/perspective_camera.dart' as three;
import 'package:three_dart/three3d/math/frustum.dart' as three;
import 'package:three_dart/three3d/math/matrix4.dart' as three;
import 'package:three_dart/three3d/math/vector3.dart' as three;
import 'package:three_dart/three3d/scenes/scene.dart' as three;
import 'package:three_dart/three3d/materials/mesh_basic_material.dart' as three;
import 'package:three_dart/three3d/math/box3.dart' as three;
import 'package:three_dart/three3d/objects/mesh.dart' as three;

bool threeJsCulling(CameraModel cameraModel, Scene scene, WorldAssetModel assetModel, Matrix4 modelMatrix){
    final threeScene = three.Scene();
    final threeCamera = three.PerspectiveCamera(90, CameraModel.aspectRatio,  0.001, 1000);
    threeCamera.position = three.Vector3(cameraModel.positionVector.x, cameraModel.positionVector.y, cameraModel.positionVector.z);
    threeCamera.lookAt(three.Vector3(cameraModel.lookAtVector.x, cameraModel.lookAtVector.y, cameraModel.lookAtVector.z));
    threeCamera.up = three.Vector3(cameraModel.upVector.x, cameraModel.upVector.y, cameraModel.upVector.z);
    threeCamera.updateMatrix();
    threeCamera.updateMatrixWorld();
    threeScene.add(threeCamera);

    final width = scene.widthToGL(assetModel.size!.width);
    final height = scene.heightToGL(assetModel.size!.height);
    final translation = Vector3.zero();
    modelMatrix.decompose(translation, Quaternion.identity(), Vector3.zero());
    final mesh = three.Mesh(three.BoxGeometry(width, height, 0.01), three.MeshBasicMaterial());
    mesh.position.set(translation.x, translation.y, translation.z);
    mesh.rotation.set(assetModel.rotateX, assetModel.rotateY, assetModel.rotateZ, 'YXZ');
    mesh.scale.set(assetModel.scale, assetModel.scale, assetModel.scale);
    mesh.updateMatrixWorld();
    threeScene.add(mesh);

    final frustum = three.Frustum();
    frustum.setFromProjectionMatrix(three.Matrix4().multiplyMatrices(threeCamera.projectionMatrix, threeCamera.matrixWorldInverse));
    final threeBox = three.Box3().setFromObject(mesh);
    return !frustum.intersectsBox(threeBox);
}
