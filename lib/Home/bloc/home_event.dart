part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
final class HomeInitialEvent extends HomeEvent{}
final class HomeNavigationEvent extends HomeEvent{}
final class ResultNavigationEvent extends HomeEvent{}