import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/components/buttons/extendable_button/extendable_button.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';

class AddServiceRecordForm extends StatefulWidget {
  final Function(String title, String description, DateTime date, int mileage) onSubmit;
  final bool isLoading;

  const AddServiceRecordForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AddServiceRecordForm> createState() => _AddServiceRecordFormState();
}

class _AddServiceRecordFormState extends State<AddServiceRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mileageController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Service Record',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appColors.charcoal,
              ),
            ),
            SizedBox(height: 20.h),
            
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                hintText: 'Service Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'Service Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            
            // Date field
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedDate == null 
                        ? context.appColors.charcoal.withOpacity(0.3)
                        : context.appColors.bleuDeFrance,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _selectedDate == null 
                          ? context.appColors.charcoal.withOpacity(0.6)
                          : context.appColors.bleuDeFrance,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _selectedDate == null 
                          ? 'Select Service Date *'
                          : _formatDate(_selectedDate!),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: _selectedDate == null 
                            ? context.appColors.charcoal.withOpacity(0.6)
                            : context.appColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Mileage field
            TextFormField(
              controller: _mileageController,
              decoration: InputDecoration(
                labelText: 'Mileage (km) *',
                hintText: 'Current Mileage',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: Icon(Icons.speed),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mileage is required';
                }
                final mileage = int.tryParse(value.trim());
                if (mileage == null || mileage < 0) {
                  return 'Please enter a valid mileage';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            
            // Submit button
            ExtendableButton(
              text: widget.isLoading ? 'Adding...' : 'Add Service Record',
              buttonColor: context.appColors.bleuDeFrance,
              onPress: widget.isLoading ? null : _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.appColors.bleuDeFrance,
              onPrimary: context.appColors.white,
              surface: context.appColors.white,
              onSurface: context.appColors.charcoal,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a service date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final mileage = int.parse(_mileageController.text.trim());
    
    widget.onSubmit(title, description, _selectedDate!, mileage);
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year.toString();
    return '$day $month $year';
  }
} 