import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wittycar_mobile/core/base/cubit/base_cubit.dart';
import 'package:wittycar_mobile/core/constants/navigation/navigation_constants.dart';
import 'package:wittycar_mobile/core/init/cache/token_manager.dart';
import 'package:wittycar_mobile/features/auth/models/auth_request_model.dart';
import 'package:wittycar_mobile/features/auth/models/auth_response_model.dart';
import 'package:wittycar_mobile/features/auth/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with BaseCubit {
  final AuthService _authService;
  final TokenManager _tokenManager = TokenManager.instance;

  AuthCubit({
    required AuthService authService,
  })  : _authService = authService,
        super(AuthInitial());

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  void init() {
    // Check if user is already logged in
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final cachedUser = await _authService.getCachedUser();
        emit(AuthAuthenticated(user: cachedUser));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    try {
      final request = AuthRequestModel.login(
        email: email,
        password: password,
      );
      
      final response = await _authService.login(request);
      
      if (response.isSuccess && response.token != null) {
        emit(AuthAuthenticated(user: response.user));
        
        // Navigate to home
        navigation.navigateToPageClear(path: NavigationConstants.HOME);
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    emit(AuthLoading());
    
    try {
      // Get or generate localId
      
      
      final request = AuthRequestModel.register(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      
      final response = await _authService.register(request);
      
      if (response.isSuccess) {
        // After successful registration, navigate to login page
        // User should login separately with their credentials
        emit(AuthUnauthenticated());
        
        // Show success message
        if (context != null) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              content: Text('Registration successful! Please login with your credentials.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        // Navigate to login page, not home
        navigation.navigateToPageClear(path: NavigationConstants.LOGIN);
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      // Even if logout fails on server, clear local data
      print('Logout error: $e');
    }
    
    emit(AuthUnauthenticated());
    
    // Navigate to login
    navigation.navigateToPageClear(path: NavigationConstants.LOGIN);
  }

  void resetState() {
    emit(AuthInitial());
  }
} 