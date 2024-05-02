import 'package:base_project/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextTitle extends StatelessWidget {
  final String title;
  final bool isLocale;
  final bool isRequired;
  final TextStyle? titleStyle;

  const CustomTextTitle({
    super.key,
    this.title = '',
    this.isLocale = true,
    this.isRequired = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      (isLocale ? title.tr : title) + (isRequired ? ' (*)' : ''),
      style: titleStyle ??
          const TextStyle(
            color: ff606060,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}
