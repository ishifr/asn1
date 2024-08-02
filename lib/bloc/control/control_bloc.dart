import 'package:asn1/util/tabs_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  ControlBloc() : super(ControlInitial()) {
    on<UpdateInfo>((event, emit) {
      emit(ControlSuccess(tabs: event.tabs, index: findIndex(event.tabs)));
    });
    on<DeleteTab>((event, emit) {
      if (event.tabs.length == 1 || !event.tabs[event.index].isCurrent) {
        event.tabs.removeAt(event.index);
      } else {
        if (event.tabs.length - 1 >= event.index) {
          event.tabs.removeAt(event.index);
          event.tabs[event.index == 0 ? 0 : event.index - 1].isCurrent = true;
        }
      }
      emit(ControlSuccess(tabs: event.tabs, index: event.index));
    });
    on<CurrentTab>((event, emit) {
      for (int i = 0; i < event.tabs.length; i++) {
        event.tabs[i].isCurrent = i == event.index;
      }
      emit(ControlSuccess(tabs: event.tabs, index: event.index));
    });
  }
}

int findIndex(List<TabsInfo> tabs) {
  for (int i = 0; i < tabs.length; i++) {
    if (tabs[i].isCurrent) {
      return i;
    }
  }
  return 0;
}
