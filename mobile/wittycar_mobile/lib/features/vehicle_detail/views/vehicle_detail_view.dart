import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/features/vehicle_detail/cubit/vehicle_detail_cubit.dart';
import 'package:wittycar_mobile/features/vehicle_detail/widgets/add_service_record_form.dart';
import 'package:wittycar_mobile/features/vehicle_detail/widgets/service_record_card.dart';
import 'package:wittycar_mobile/features/vehicles/models/vehicle_model.dart';

class VehicleDetailView extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailView({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<VehicleDetailCubit>(
      cubit: locator<VehicleDetailCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.setVehicle(vehicle);
      },
      onPageBuilder: (cubit) => _VehicleDetailBody(vehicle: vehicle),
    );
  }
}

class _VehicleDetailBody extends StatelessWidget {
  final VehicleModel vehicle;

  const _VehicleDetailBody({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.white,
      appBar: AppBar(
        title: Text('Vehicle Details'),
        backgroundColor: context.appColors.bleuDeFrance,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Vehicle info header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            color: context.appColors.bleuDeFrance.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.displayName,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.appColors.charcoal,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Plate: ${vehicle.plateDisplay}',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.appColors.charcoal.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Mileage: ${_formatNumber(vehicle.mileage)} km',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.charcoal.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Service records section
          Expanded(
            child: BlocConsumer<VehicleDetailCubit, VehicleDetailState>(
              listener: (context, state) {
                if (state is ServiceRecordAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service record added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(); // Close the bottom sheet
                } else if (state is ServiceRecordAddError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is VehicleDetailError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is VehicleDetailLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.appColors.bleuDeFrance,
                    ),
                  );
                } else if (state is VehicleDetailLoaded) {
                  if (state.serviceRecords.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.build_circle_outlined,
                            size: 80.sp,
                            color: context.appColors.charcoal.withOpacity(0.3),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No service records yet',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.appColors.charcoal.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Add your first service record using the + button',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.appColors.charcoal.withOpacity(0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: state.serviceRecords.length,
                      itemBuilder: (context, index) {
                        return ServiceRecordCard(
                          serviceRecord: state.serviceRecords[index],
                        );
                      },
                    );
                  }
                } else if (state is VehicleDetailError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80.sp,
                          color: Colors.red.withOpacity(0.6),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading service records',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.appColors.charcoal.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<VehicleDetailCubit>().loadServiceRecords();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Welcome to vehicle details',
                      style: context.textTheme.bodyLarge,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceRecordBottomSheet(context),
        backgroundColor: context.appColors.bleuDeFrance,
        child: Icon(
          Icons.add,
          color: context.appColors.white,
        ),
      ),
    );
  }

  void _showAddServiceRecordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<VehicleDetailCubit>(),
        child: Container(
          height: MediaQuery.of(bottomSheetContext).size.height * 0.9,
          decoration: BoxDecoration(
            color: bottomSheetContext.appColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: BlocBuilder<VehicleDetailCubit, VehicleDetailState>(
            builder: (context, state) {
              return AddServiceRecordForm(
                isLoading: state is ServiceRecordAdding,
                onSubmit: (title, description, date, mileage) {
                  context.read<VehicleDetailCubit>().addServiceRecord(
                    title: title,
                    description: description,
                    date: date,
                    mileage: mileage,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
} 