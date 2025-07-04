import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';

class VehicleForm extends StatefulWidget {
  final Function({
    required String brand,
    required String model,
    required int year,
    required String plate,
    required int mileage,
  }) onSubmit;

  final bool isLoading;
  final String? initialBrand;
  final String? initialModel;
  final int? initialYear;
  final String? initialPlate;
  final int? initialMileage;

  const VehicleForm({
    Key? key,
    required this.onSubmit,
    this.isLoading = false,
    this.initialBrand,
    this.initialModel,
    this.initialYear,
    this.initialPlate,
    this.initialMileage,
  }) : super(key: key);

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  final _mileageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _brandController.text = widget.initialBrand ?? '';
    _modelController.text = widget.initialModel ?? '';
    _yearController.text = widget.initialYear?.toString() ?? '';
    _plateController.text = widget.initialPlate ?? '';
    _mileageController.text = widget.initialMileage?.toString() ?? '';
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        plate: _plateController.text.trim(),
        mileage: int.parse(_mileageController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Brand Field
          TextFormField(
            controller: _brandController,
            decoration: InputDecoration(
              labelText: 'Marka *',
              hintText: 'ör. Toyota, Honda, BMW',
              prefixIcon: Icon(Icons.directions_car),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Lütfen araç markasını giriniz';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Model Field
          TextFormField(
            controller: _modelController,
            decoration: InputDecoration(
              labelText: 'Model *',
              hintText: 'ör. Camry, Civic, X5',
              prefixIcon: Icon(Icons.car_rental),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Lütfen araç modelini giriniz';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Year Field
          TextFormField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
              labelText: 'Yıl *',
              hintText: 'ör. 2023',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Lütfen model yılını giriniz';
              }
              final year = int.tryParse(value);
              if (year == null) {
                return 'Geçerli bir yıl giriniz';
              }
              final currentYear = DateTime.now().year;
              if (year < 1900 || year > currentYear + 1) {
                return 'Yıl 1900 ile ${currentYear + 1} arasında olmalıdır';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Plate Field
          TextFormField(
            controller: _plateController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Plaka *',
              hintText: 'ör. 34 ABC 1234',
              prefixIcon: Icon(Icons.assignment),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Lütfen plaka numarasını giriniz';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Mileage Field
          TextFormField(
            controller: _mileageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'Kilometre *',
              hintText: 'ör. 50000',
              prefixIcon: Icon(Icons.speed),
              suffixText: 'km',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Lütfen kilometre bilgisini giriniz';
              }
              final mileage = int.tryParse(value);
              if (mileage == null) {
                return 'Geçerli bir kilometre değeri giriniz';
              }
              if (mileage < 0) {
                return 'Kilometre negatif olamaz';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Kaydet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
} 