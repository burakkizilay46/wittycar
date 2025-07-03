import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wittycar_mobile/core/constants/image/image_constants.dart';
import 'package:wittycar_mobile/core/extansions/context_extansions.dart';



class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.appColors.bleuDeFrance,
      leading: Container(
        margin: EdgeInsets.only(left: 24),
        child: Image.asset(
          ImageConstants.instance.whiteLogo,
          height: 60.h,
          width: 400.w,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 24),
          child: IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: context.appColors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
