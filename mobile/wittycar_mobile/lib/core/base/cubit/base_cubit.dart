import 'package:flutter/material.dart';
import 'package:wittycar_mobile/core/init/app_state/app_state.dart';
import 'package:wittycar_mobile/core/init/navigation/navigation_service.dart';

abstract mixin class BaseCubit {
  BuildContext? context;
  NavigationService navigation = NavigationService.instance;
  AppStateManager appStateManager = AppStateManager.instance;

  void setContext(BuildContext context);
  void init();
}
