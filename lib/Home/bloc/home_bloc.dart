import 'dart:async';
import 'dart:convert' show utf8;

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

import '../../Models/Quizmodel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(_mapHomeInitialToState);
  }

  Future<void> _mapHomeInitialToState(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final tasks = await _loadTasksFromCsv();
      print(tasks.first);
    emit(HomeLoadedState(tasks: tasks));
    } catch (e) {
      print(e);
      emit(HomeErrorState());
    }
  }
Future<List<Task>> _loadTasksFromCsv() async {
  final ByteData data = await rootBundle.load('assets/Quiz.csv');
  final List<int> bytes = data.buffer.asUint8List();
  final decodedCsv = utf8.decode(bytes);
  final List<List<dynamic>> csvList = CsvToListConverter().convert(decodedCsv);
  print(csvList);
  final List<Task> tasks = [];

  for (var row in csvList.skip(1)) {
    tasks.add(Task(
      taskName: row[0].toString(),
      question: row[1].toString(),
      options: [
        row[2].toString(), // Option 1
        row[3].toString(), // Option 2
        row[4].toString(), // Option 3
        row[5].toString(), // Option 4
      ],
      correctAnswerIndex: int.parse(row[6].toString()),
      info: row[7].toString(),
    ));
  }

  return tasks;
}
}