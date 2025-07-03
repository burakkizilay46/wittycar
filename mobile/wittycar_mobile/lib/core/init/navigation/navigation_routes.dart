import 'package:flutter/material.dart';
import 'package:wittycar_mobile/core/components/not_found/not_found_navigation.dart';

import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    // Add your route generation logic here

    // Default case to handle unknown routes

    switch (args.name) {
      case NavigationConstants.DEFAULT:
      /* return normalNavigate(const SplashView()); */

      default:
        return normalNavigate(const NotFoundNavigation());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}

  //  case NavigationConstants.MOVIE_DETAILS_VIEV:
  //       if (args.arguments is MovieResultModel) {
  //         return normalNavigate(MovieDetailsView(movie: args.arguments! as MovieResultModel));
  //       }
  //       throw NavigateException<SettingsDynamicModel>(args.arguments);