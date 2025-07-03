import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.placeholder,
    required this.icon,
    this.isCapitalized = false,
    this.isObscure = false,
    this.toggleIsObscure,
  });

  final String title;
  final String placeholder;
  final IconData icon;
  final bool isCapitalized;
  final bool? isObscure;
  final VoidCallback? toggleIsObscure;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscureChanged;

  @override
  void initState() {
    super.initState();
    isObscureChanged = widget.isObscure ?? false;
  }

  void _toggleObscureText() {
    setState(() {
      isObscureChanged = !isObscureChanged;
    });
    if (widget.toggleIsObscure != null) {
      widget.toggleIsObscure!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78.h,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.appColors.bleuDeFrance.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(widget.icon, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: isObscureChanged,
                    cursorHeight: 20,
                    autocorrect: false,
                    textCapitalization:
                        widget.isCapitalized
                            ? TextCapitalization.words
                            : TextCapitalization.none,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: widget.placeholder,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                if (widget.isObscure ?? false)
                  GestureDetector(
                    onTap: _toggleObscureText,
                    child: Icon(
                      isObscureChanged
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
