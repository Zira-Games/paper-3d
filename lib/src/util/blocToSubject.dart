import 'package:bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

BehaviorSubject<T> blocToSubject<T>(Bloc<dynamic, T> bloc) =>
    BehaviorSubject<T>.seeded(bloc.state)..addStream(bloc.stream);
