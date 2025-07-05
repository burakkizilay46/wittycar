import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/features/vehicles/cubit/vehicles_cubit.dart';
import 'package:wittycar_mobile/features/vehicles/widgets/vehicle_form.dart';

class AddVehicleView extends StatelessWidget {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<VehiclesCubit>(
      cubit: locator<VehiclesCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.resetAddState(); // Reset any previous add state
      },
      onPageBuilder: (cubit) => _AddVehicleBody(),
    );
  }
}

class _AddVehicleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Araç Ekle'),
        backgroundColor: context.theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<VehiclesCubit>().navigation.pop();
          },
        ),
      ),
      body: BlocListener<VehiclesCubit, VehiclesState>(
        listener: (context, state) {
          if (state is VehicleAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is VehicleAdded) {
            // Navigation is already handled in the cubit
            // Just show a success message here if needed
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  'Yeni Araç Ekle',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Araç bilgilerinizi girerek bakım takibi yapmaya başlayın.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Form Section
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder<VehiclesCubit, VehiclesState>(
                      builder: (context, state) {
                        final isLoading = state is VehicleAdding;
                        
                        return VehicleForm(
                          isLoading: isLoading,
                          onSubmit: ({
                            required String brand,
                            required String model,
                            required int year,
                            required String plate,
                            required int mileage,
                          }) {
                            context.read<VehiclesCubit>().addVehicle(
                              brand: brand,
                              model: model,
                              year: year,
                              plate: plate,
                              mileage: mileage,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 