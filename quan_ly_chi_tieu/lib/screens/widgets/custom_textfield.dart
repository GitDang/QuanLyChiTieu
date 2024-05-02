import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base_project/resources/colors.dart';
import 'package:base_project/screens/widgets/widgets.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final bool enable;
  final double height;
  final EdgeInsets margin;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String title;
  final bool isTitleLocale;
  final bool isRequired;
  final TextStyle? titleStyle;
  final String hintText;
  final bool isHintTextLocale;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final bool obscureText;

  // final bool needCheckValidate;
  // final Function(String, Function)? validateText;
  final String errorText;
  final Widget? prefixIcon;
  final BoxDecoration? borderInputStyle;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    this.enable = true,
    this.height = 40,
    this.margin = EdgeInsets.zero,
    this.controller,
    this.focusNode,
    this.title = '',
    this.isTitleLocale = true,
    this.isRequired = false,
    this.titleStyle,
    this.hintText = '',
    this.isHintTextLocale = true,
    this.hintTextStyle,
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.onSubmitted,
    this.onChanged,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = TextField.noMaxLength,
    this.obscureText = false,
    // this.needCheckValidate = false,
    // this.validateText,
    this.errorText = '',
    this.prefixIcon,
    this.borderInputStyle,
    this.textAlign = TextAlign.left
  });

  @override
  Widget build(BuildContext context) {
    double paddingTop = (height - (textStyle?.fontSize ?? 14) * (textStyle?.height ?? 1.25)) / 2 - 1;

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              child: CustomTextTitle(
                title: title,
                isLocale: isTitleLocale,
                titleStyle: titleStyle,
                isRequired: isRequired,
              ),
            ),
          Container(
            height: height,
            decoration: borderInputStyle ?? BoxDecoration(
              color: enable ? backgroundColor : ffF5F5F5,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                width: 1,
                color: ffC5C5C5,
              ),
            ),
            clipBehavior: Clip.none,
            child: TextField(
              enabled: enable,
              onSubmitted: onSubmitted,
              controller: controller,
              focusNode: focusNode,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              obscureText: obscureText,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              textAlign: textAlign,
              style: textStyle ??
                  TextStyle(
                    color: enable ? Colors.black : ffA2A2A2,
                    fontSize: 14,
                    height: 1.25,
                  ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: isHintTextLocale ? hintText.tr : hintText,
                hintStyle: hintTextStyle ??
                    const TextStyle(
                      color: ffA2A2A2,
                      fontSize: 14,
                      height: 1.25,
                    ),
                contentPadding: EdgeInsets.only(left: 8, top: paddingTop, right: 8),
                counterText: '',
                prefixIcon: prefixIcon,
                // suffixIcon: obscureText
                //     ? IconButton(
                //         icon: obscureText
                //             ? Image.asset(
                //                 'images/ic_eyeslash.png',
                //                 color: Colors.black,
                //               )
                //             : Image.asset(
                //                 'images/ic_eye.png',
                //                 color: Colors.black,
                //               ),
                //         onPressed: () {
                //           setState(() {
                //             obscureText = !obscureText;
                //           });
                //         },
                //       )
                //     : null,
              ),
              onChanged: (text) {
                if (onChanged != null) onChanged!(text.trim());
                // if (needCheckValidate && validateText != null) {
                //   setState(() {
                //     validateText!(currentText, this.updateMessage);
                //   });
                // }
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLength),
              ],
            ),
          ),
          // if (_message.isNotEmpty)
          //   TextValidateWarning(
          //     errorText: _message,
          //   ),
        ],
      ),
    );
  }

// void updateMessage(message) {
//   setState(() {
//     this._message = message;
//   });
// }
}
