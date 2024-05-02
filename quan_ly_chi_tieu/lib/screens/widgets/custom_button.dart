import 'package:base_project/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:base_project/resources/colors.dart';

class CustomButton extends StatelessWidget {
  final bool enable;
  final Function? onTap;
  final double? width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double radius;
  final Color backgroundColor;
  final double borderWidth;
  final String title;
  final bool isLocale;
  final TextStyle? titleStyle;

  const CustomButton({
    super.key,
    this.enable = true,
    this.onTap,
    this.width,
    this.height = 36,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.radius = 20,
    this.backgroundColor = ffFFE67C,
    this.borderWidth = 0,
    this.title = '',
    this.isLocale = true,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (enable) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (onTap != null) onTap!();
        }
      },
      child: Container(
        width: width ?? double.infinity,
        height: height,
        margin: margin,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enable ? backgroundColor : ffC5C5C5,
          borderRadius: BorderRadius.circular(radius),
          // border: Border.all(
          //   color: enable ? ffEA0503 : ffC5C5C5,
          //   width: borderWidth,
          // ),
        ),
        child: CustomLabel(
          enable: enable,
          title: title,
          isLocale: isLocale,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          customTextStyle: titleStyle,
        ),
      ),
    );
  }
}
