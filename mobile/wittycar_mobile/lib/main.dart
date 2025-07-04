import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/init/cache/shared_prefs_manager.dart';
import 'package:wittycar_mobile/core/init/cache/token_manager.dart';
import 'package:wittycar_mobile/core/init/navigation/navigation_routes.dart';
import 'package:wittycar_mobile/core/init/navigation/navigation_service.dart';
import 'package:wittycar_mobile/core/init/theme/app_theme_manager.dart';

import './core/init/di/locator.dart' as servicelocator;

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (BuildContext context, Widget? widget) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemeManager.instance.lightTheme,
            themeMode: ThemeMode.system,
            navigatorKey: NavigationService.instance.navigatorKey,
            onGenerateRoute: NavigationRoute.instance.generateRoute,
          ),
    );
  }
}

Future<void> init() async {
  // Ensure Flutter is properly initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Initializing WittyCar app...');
  
  try {
    // Initialize dependency injection
    await servicelocator.init();
    print('✅ Service locator initialized');
    
    // Initialize SharedPreferences
    await SharedPrefsManager.preferencesInit();
    print('✅ SharedPreferences initialized');
    
    // Test secure storage functionality
    final tokenManager = TokenManager.instance;
    final secureStorageWorks = await tokenManager.testSecureStorage();
    
    if (secureStorageWorks) {
      print('✅ Secure storage test passed');
    } else {
      print('⚠️  Secure storage test failed - will use fallback storage');
    }
    
    print('🎉 App initialization completed successfully');
  } catch (e) {
    print('❌ Error during app initialization: $e');
    // Don't crash the app, let it start with degraded functionality
  }
}
