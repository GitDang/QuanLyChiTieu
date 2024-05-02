import 'package:flutter/material.dart';

import 'package:base_project/resources/colors.dart';
import 'package:get/get.dart';

class CustomLabel extends StatelessWidget {
  final bool enable;
  final String title;
  final bool isLocale;
  final Color color;
  final Color disableColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? customTextStyle;

  const CustomLabel({
    super.key,
    this.enable = true,
    required this.title,
    this.isLocale = true,
    this.color = ff606060,
    this.disableColor = Colors.white,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.customTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isLocale ? title.tr : title,
      style: customTextStyle ?? TextStyle(
        color: enable ? color : disableColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
