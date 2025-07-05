import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/constants/navigation/navigation_constants.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/features/appointments/cubit/appointment_cubit.dart';
import 'package:wittycar_mobile/features/appointments/widgets/appointment_card.dart';

class MyAppointmentsView extends StatelessWidget {
  const MyAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AppointmentCubit>(
      cubit: locator<AppointmentCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.init();
      },
      onPageBuilder: (cubit) => _MyAppointmentsBody(),
    );
  }
}

class _MyAppointmentsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.white,
      appBar: AppBar(
        title: Text('My Appointments'),
        backgroundColor: context.appColors.bleuDeFrance,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.read<AppointmentCubit>().navigation.navigateToPage(
                path: NavigationConstants.APPOINTMENT_BOOKING,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is AppointmentDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Appointment deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          
          if (state is AppointmentDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.appColors.bleuDeFrance,
              ),
            );
          }
          
          if (state is AppointmentLoaded) {
            if (state.appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 80.r,
                      color: context.appColors.charcoal.withOpacity(0.3),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No appointments yet',
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: context.appColors.charcoal.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Book your first appointment',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.appColors.charcoal.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AppointmentCubit>().navigation.navigateToPage(
                          path: NavigationConstants.APPOINTMENT_BOOKING,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.bleuDeFrance,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                      ),
                      child: Text('Book Appointment'),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AppointmentCubit>().loadAppointments();
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.appointments[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: AppointmentCard(appointment: appointment),
                  );
                },
              ),
            );
          }
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80.r,
                  color: context.appColors.charcoal.withOpacity(0.3),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Something went wrong',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.appColors.charcoal.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<AppointmentCubit>().loadAppointments();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.bleuDeFrance,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 