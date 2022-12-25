import 'dart:ui';

import 'package:rxdart/subjects.dart';

class ScreenSize {

  final BehaviorSubject<Size> subject;

  ScreenSize(Size size) :
    subject = BehaviorSubject<Size>.seeded(size);

  update(Size size){
    subject.add(size);
  }

  double get width => subject.value.width;
  double get height => subject.value.height;
  Size get size => subject.value;

}

extension Shapes on Size {
  Size get square => Size(height, height);
}