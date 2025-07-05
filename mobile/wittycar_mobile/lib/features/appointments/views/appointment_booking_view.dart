import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/features/appointments/cubit/appointment_cubit.dart';
import 'package:wittycar_mobile/features/appointments/widgets/appointment_form.dart';

class AppointmentBookingView extends StatelessWidget {
  const AppointmentBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AppointmentCubit>(
      cubit: locator<AppointmentCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.resetState();
      },
      onPageBuilder: (cubit) => _AppointmentBookingBody(),
    );
  }
}

class _AppointmentBookingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.white,
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: context.appColors.bleuDeFrance,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Appointment booked successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
          
          if (state is AppointmentCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: context.appColors.bleuDeFrance.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: context.appColors.bleuDeFrance,
                          size: 24.r,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Book Service Appointment',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select your vehicle and preferred date & time for the service appointment.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.appColors.charcoal.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Appointment Form
              AppointmentForm(),
            ],
          ),
        ),
      ),
    );
  }
} 