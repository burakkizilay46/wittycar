import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/base/view/base_view.dart';
import 'package:wittycar_mobile/core/constants/navigation/navigation_constants.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';
import 'package:wittycar_mobile/core/init/di/locator.dart';
import 'package:wittycar_mobile/core/init/navigation/navigation_service.dart';
import 'package:wittycar_mobile/features/vehicles/cubit/vehicles_cubit.dart';
import 'package:wittycar_mobile/features/vehicles/widgets/vehicle_card.dart';

class VehicleListView extends StatelessWidget {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<VehiclesCubit>(
      cubit: locator<VehiclesCubit>(),
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.init();
      },
      onPageBuilder: (cubit) => _VehicleListBody(),
    );
  }
}

class _VehicleListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Araçlarım'),
        backgroundColor: context.theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              NavigationService.instance.navigateToPage(
                path: NavigationConstants.VEHICLES_ADD,
              );
            },
          ),
        ],
      ),
      body: BlocListener<VehiclesCubit, VehiclesState>(
        listener: (context, state) {
          if (state is VehiclesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<VehiclesCubit, VehiclesState>(
          builder: (context, state) {
            if (state is VehiclesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.primaryColor,
                  ),
                ),
              );
            }

            if (state is VehiclesLoaded) {
              if (state.vehicles.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<VehiclesCubit>().loadVehicles();
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  itemCount: state.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = state.vehicles[index];
                    return VehicleCard(
                      vehicle: vehicle,
                      onTap: () {
                        // TODO: Navigate to vehicle details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Araç detayları yakında gelecek!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onEdit: () {
                        // TODO: Navigate to edit vehicle
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Araç düzenleme yakında gelecek!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteConfirmation(context, vehicle.id);
                      },
                    );
                  },
                ),
              );
            }

            if (state is VehiclesError) {
              return _buildErrorState(context, state.message);
            }

            return Center(
              child: Text('Bir şeyler ters gitti'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationService.instance.navigateToPage(
            path: NavigationConstants.VEHICLES_ADD,
          );
        },
        backgroundColor: context.theme.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              'Henüz Araç Yok',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'İlk aracınızı ekleyerek araç bakım takibine başlayın.',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                NavigationService.instance.navigateToPage(
                  path: NavigationConstants.VEHICLES_ADD,
                );
              },
              icon: Icon(Icons.add),
              label: Text('İlk Aracınızı Ekleyin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              'Hata Oluştu',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                // Retry loading vehicles
                context.read<VehiclesCubit>().loadVehicles();
              },
              icon: Icon(Icons.refresh),
              label: Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aracı Sil'),
          content: Text('Bu aracı silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete vehicle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Araç silme yakında gelecek!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'Sil',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} 