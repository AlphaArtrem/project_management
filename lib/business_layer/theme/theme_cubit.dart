import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/service_layer/services_setup.dart';

part 'theme_state.dart';

///Class top handle app theme across the app
class ThemeCubit extends Cubit<ThemeState> {
  ///[ThemeCubit] default constructor
  ThemeCubit(super.initialState);

  ///Toggle between light and dark themes
  void toggleTheme() {
    apiService.log.d('message');
    emit(ThemeState(isLight: !state.isLight));
    apiService.log.d(state.isLight);
  }

  ///Change theme according to [isLight] parameter
  void changeTheme({required bool isLight}) {
    emit(ThemeState(isLight: isLight));
  }
}
