import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/components/buttons/extendable_button/extendable_button.dart';
import 'package:wittycar_mobile/core/constants/navigation/navigation_constants.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/core/init/navigation/navigation_service.dart';
import 'package:wittycar_mobile/features/auth/cubit/auth_cubit.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthCubit>(
      cubit: locator<AuthCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.init();
      },
      onPageBuilder: (cubit) => _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  @override
  State<_RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onPhoneChanged(String value) {
    // Auto-add + if user starts typing without it
    if (value.isNotEmpty && !value.startsWith('+')) {
      _phoneController.value = TextEditingValue(
        text: '+$value',
        selection: TextSelection.collapsed(offset: value.length + 1),
      );
    }
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60.h),
                    
                    // Logo/Title
                    Center(
                      child: Text(
                        'WittyCar',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: context.appColors.bleuDeFrance,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Center(
                      child: Text(
                        'Create your account to get started.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Full Name Field
                    TextFormField(
                      controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Phone Number Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _onPhoneChanged,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        hintText: '+905551234567',
                        helperText: 'Format: +[country code][phone number]',
                        helperMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        
                        String phone = value.trim();
                        
                        // E.164 format validation
                        if (!phone.startsWith('+')) {
                          return 'Phone number must start with +';
                        }
                        
                        // Remove + and check if all remaining characters are digits
                        String phoneDigits = phone.substring(1);
                        if (!RegExp(r'^\d+$').hasMatch(phoneDigits)) {
                          return 'Phone number can only contain digits after +';
                        }
                        
                        // E.164 allows 7-15 digits (after country code)
                        if (phoneDigits.length < 7 || phoneDigits.length > 15) {
                          return 'Phone number must be 7-15 digits after +';
                        }
                        
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Register Button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ExtendableButton(
                          text: state is AuthLoading ? 'Creating Account...' : 'Sign Up',
                          buttonColor: context.appColors.bleuDeFrance,
                          onPress: state is AuthLoading ? null : _register,
                          isDisabled: state is AuthLoading,
                        );
                      },
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            NavigationService.instance.navigateToPage(
                              path: NavigationConstants.LOGIN,
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: context.appColors.bleuDeFrance,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 