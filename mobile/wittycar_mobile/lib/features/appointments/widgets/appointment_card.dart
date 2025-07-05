import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/features/appointments/cubit/appointment_cubit.dart';
import 'package:wittycar_mobile/features/appointments/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.appColors.bleuDeFrance.withOpacity(0.1),
              context.appColors.bleuDeFrance.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.appColors.bleuDeFrance,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        appointment.formattedTime,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18.r),
                          SizedBox(width: 8.w),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: context.appColors.bleuDeFrance,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  appointment.formattedDate,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appColors.charcoal,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8.h),
            
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  color: context.appColors.bleuDeFrance,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Vehicle: ${appointment.vehicleId}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.appColors.charcoal.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getStatusColor(context, appointment.date),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _getStatusText(appointment.date),
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now).inDays;
    
    if (difference < 0) {
      return Colors.grey;
    } else if (difference == 0) {
      return Colors.orange;
    } else if (difference <= 7) {
      return Colors.green;
    } else {
      return context.appColors.bleuDeFrance;
    }
  }

  String _getStatusText(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now).inDays;
    
    if (difference < 0) {
      return 'Past';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference <= 7) {
      return 'This Week';
    } else {
      return 'Upcoming';
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Appointment'),
          content: Text('Are you sure you want to delete this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AppointmentCubit>().deleteAppointment(appointment.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
} 