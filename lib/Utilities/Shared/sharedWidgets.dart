// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_controller/Utilities/Constants/constants.dart';

class RoundedButton extends StatelessWidget {
  final Color buttonColor, titleColor;
  final String title;
  final Function ontap;
  final double width;
  final double height;
  RoundedButton(
      {this.buttonColor,
      this.title,
      this.titleColor,
      this.ontap,
      this.width,
      this.height});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: buttonColor),
        child: Center(
          child: Text(
            title,
            style: boldStyle.copyWith(
                color: titleColor, fontSize: setResponsiveFontSize(24)),
          ),
        ),
      ),
    );
  }
}
