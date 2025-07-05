import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/features/appointments/cubit/appointment_cubit.dart';
import 'package:wittycar_mobile/features/vehicles/cubit/vehicles_cubit.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedVehicleId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return BaseView<VehiclesCubit>(
      cubit: locator<VehiclesCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.loadVehicles();
      },
      onPageBuilder: (vehiclesCubit) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Selection
            Text(
              'Select Vehicle',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.appColors.charcoal,
              ),
            ),
            SizedBox(height: 8.h),
            BlocBuilder<VehiclesCubit, VehiclesState>(
              builder: (context, state) {
                if (state is VehiclesLoading) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.appColors.charcoal.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.appColors.bleuDeFrance,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text('Loading vehicles...'),
                      ],
                    ),
                  );
                }

                if (state is VehiclesLoaded) {
                  return DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    decoration: InputDecoration(
                      hintText: 'Select your vehicle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    items: state.vehicles.map((VehicleModel vehicle) {
                      return DropdownMenuItem<String>(
                        value: vehicle.id,
                        child: Text(vehicle.displayName),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedVehicleId = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vehicle';
                      }
                      return null;
                    },
                  );
                }

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 12.w),
                      Text('Failed to load vehicles'),
                    ],
                  ),
                );
              },
            ),
            
            SizedBox(height: 20.h),
            
            // Date Selection
            Text(
              'Select Date',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.appColors.charcoal,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: context.appColors.charcoal.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: context.appColors.bleuDeFrance,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                          : 'Select date',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: _selectedDate != null
                            ? context.appColors.charcoal
                            : context.appColors.charcoal.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // Time Selection
            Text(
              'Select Time',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.appColors.charcoal,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: context.appColors.charcoal.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: context.appColors.bleuDeFrance,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _selectedTime != null
                          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Select time',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: _selectedTime != null
                            ? context.appColors.charcoal
                            : context.appColors.charcoal.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Submit Button
            BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                final isLoading = state is AppointmentCreating;
                
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.bleuDeFrance,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Book Appointment',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Combine date and time
      final DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      // Check if appointment is at least 30 minutes in the future
      if (appointmentDateTime.isBefore(DateTime.now().add(Duration(minutes: 30)))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment must be at least 30 minutes in the future'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Submit the appointment
      context.read<AppointmentCubit>().createAppointment(
        vehicleId: _selectedVehicleId!,
        dateTime: appointmentDateTime,
      );
    }
  }
} 