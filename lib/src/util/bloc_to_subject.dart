import 'package:bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

BehaviorSubject<T> blocToSubject<T>(Bloc<dynamic, T> bloc) =>
    BehaviorSubject<T>.seeded(bloc.state)..addStream(bloc.stream);

BehaviorSubject<T> cubitToSubject<T>(Cubit<T> cubit) =>
    BehaviorSubject<T>.seeded(cubit.state)..addStream(cubit.stream);
