part of 'control_bloc.dart';

@immutable
sealed class ControlEvent {}

class UpdateInfo extends ControlEvent {
  final List<TabsInfo> tabs;

  UpdateInfo({required this.tabs});
}

class DeleteTab extends ControlEvent {
  final List<TabsInfo> tabs;
  final int index;

  DeleteTab({required this.tabs, required this.index});
}

class CurrentTab extends ControlEvent {
  final List<TabsInfo> tabs;
  final int index;

  CurrentTab({required this.tabs, required this.index});
}
