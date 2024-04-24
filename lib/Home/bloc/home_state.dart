part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
abstract class HomeAction extends HomeState{}
final class HomeInitialState extends HomeAction{}
final class HomeLoadingState extends HomeAction{}
final class HomeLoadedState extends HomeAction{
  final List<Task>tasks;
  HomeLoadedState({required this.tasks});
}
final class HomeErrorState extends HomeAction{}
final class Nextpagestate extends HomeAction{}
final class ResultpageState extends HomeAction{}
