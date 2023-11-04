import 'package:three_dart/three3d/math/vector3.dart' as three;
import 'package:three_dart/three3d/math/matrix4.dart' as three;
import 'package:vector_math/vector_math_64.dart';

three.Vector3 vectorToThree(Vector3 input){
  return three.Vector3(input.x, input.y, input.z);
}

Vector3 vectorFromThree(three.Vector3 input){
  return Vector3(input.x, input.y, input.z);
}

three.Matrix4 matrixToThree(Matrix4 input){
  final i = input.storage;
  return three.Matrix4()..set(i[0],i[1],i[2],i[3],i[4],i[5],i[6],i[7],i[8],i[9],i[10],i[11],i[12],i[13],i[14],i[15]);
}

Matrix4 matrixFromThree(three.Matrix4 input){
  final i = input.elements;
  return Matrix4(i[0],i[1],i[2],i[3],i[4],i[5],i[6],i[7],i[8],i[9],i[10],i[11],i[12],i[13],i[14],i[15]);
}