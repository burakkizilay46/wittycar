import 'package:get_it/get_it.dart';
import 'package:wittycar_mobile/core/constants/app/app_constants.dart';
import 'package:wittycar_mobile/core/init/cache/shared_prefs_manager.dart';
import 'package:wittycar_mobile/core/init/cache/token_manager.dart';
import 'package:wittycar_mobile/core/init/network/dio_manager.dart';
import 'package:wittycar_mobile/features/auth/services/auth_service.dart';
import 'package:wittycar_mobile/features/auth/cubit/auth_cubit.dart';
import 'package:wittycar_mobile/features/vehicles/services/vehicle_service.dart';
import 'package:wittycar_mobile/features/vehicles/cubit/vehicles_cubit.dart';
import 'package:wittycar_mobile/features/vehicle_detail/services/service_record_service.dart';
import 'package:wittycar_mobile/features/vehicle_detail/cubit/vehicle_detail_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Register DioManager for API calls with JWT support
  locator.registerLazySingleton<DioManager>(
    () => DioManager(baseUrl: AppConstants.API_BASE_URL),
  );
  
  // Register SharedPrefsManager (still needed for non-sensitive data)
  locator.registerLazySingleton<SharedPrefsManager>(
    () => SharedPrefsManager.instance,
  );
  
  // Register TokenManager for secure token storage
  locator.registerLazySingleton<TokenManager>(
    () => TokenManager.instance,
  );
  
  // Register AuthService
  locator.registerLazySingleton<AuthService>(
    () => AuthService(dioManager: locator<DioManager>()),
  );
  
  // Register VehicleService
  locator.registerLazySingleton<VehicleService>(
    () => VehicleService(dioManager: locator<DioManager>()),
  );
  
  // Register ServiceRecordService
  locator.registerLazySingleton<ServiceRecordService>(
    () => ServiceRecordService(dioManager: locator<DioManager>()),
  );
  
  // Register AuthCubit
  locator.registerFactory<AuthCubit>(
    () => AuthCubit(
      authService: locator<AuthService>(),
    ),
  );
  
  // Register VehiclesCubit
  locator.registerFactory<VehiclesCubit>(
    () => VehiclesCubit(
      vehicleService: locator<VehicleService>(),
    ),
  );
  
  // Register VehicleDetailCubit
  locator.registerFactory<VehicleDetailCubit>(
    () => VehicleDetailCubit(
      serviceRecordService: locator<ServiceRecordService>(),
    ),
  );
}
