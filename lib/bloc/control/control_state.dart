part of 'control_bloc.dart';

@immutable
sealed class ControlState {}

final class ControlInitial extends ControlState {}

final class ControlError extends ControlState {}

final class ControlSuccess extends ControlState {
  final List<TabsInfo> tabs;
  final int index;

  ControlSuccess({required this.tabs, required this.index});
}
