import 'package:flutter/material.dart';
import 'package:wittycar_mobile/core/components/not_found/not_found_navigation.dart';
import 'package:wittycar_mobile/features/home/view/home_view.dart';
import 'package:wittycar_mobile/features/auth/views/login_view.dart';
import 'package:wittycar_mobile/features/auth/views/register_view.dart';
import 'package:wittycar_mobile/features/vehicles/views/vehicle_list_view.dart';
import 'package:wittycar_mobile/features/vehicles/views/add_vehicle_view.dart';
import 'package:wittycar_mobile/features/vehicle_detail/views/vehicle_detail_view.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';

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
        return normalNavigate(const LoginView());
      case NavigationConstants.HOME:
        return normalNavigate(const HomeView());
      case NavigationConstants.LOGIN:
        return normalNavigate(const LoginView());
      case NavigationConstants.REGISTER:
        return normalNavigate(const RegisterView());
      case NavigationConstants.VEHICLES_LIST:
        return normalNavigate(const VehicleListView());
      case NavigationConstants.VEHICLES_ADD:
        return normalNavigate(const AddVehicleView());
      case NavigationConstants.VEHICLE_DETAIL:
        if (args.arguments is VehicleModel) {
          return normalNavigate(VehicleDetailView(vehicle: args.arguments as VehicleModel));
        }
        return normalNavigate(const NotFoundNavigation());

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