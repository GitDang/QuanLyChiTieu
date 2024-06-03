import 'package:base_project/resources/colors.dart';
import 'package:base_project/screens/InApp/in_app.dart';
import 'package:base_project/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:base_project/resources/app_images.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final bool showBackButton;
  final bool showMenuButton;
  final String title;
  final bool isLocale;
  final Function? onTapBack;
  final Function? onTapMenu;
  final String? iconName;
  final double? iconWidth;
  final Function? onTapAfterBack;
  final bool showTopRight;
  final Function? onTapTopRight;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.showMenuButton = false,
    this.title = '',
    this.isLocale = true,
    this.onTapBack,
    this.onTapMenu,
    this.iconName,
    this.iconWidth,
    this.onTapAfterBack,
    this.showTopRight = false,
    this.onTapTopRight,
  });

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(left: 16, top: paddingTop + 8, right: 16, bottom: 8),
      decoration: const BoxDecoration(
        color: ffFFE67C,
      ),
      child: Row(
        children: [
          showBackButton
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (showBackButton) {
                      if (onTapBack != null) {
                        onTapBack!();
                      } else {
                        Get.back();
                      }
                      if (onTapAfterBack != null) {
                        onTapAfterBack!();
                      }
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      AppImages.ic_back,
                      width: 30,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CustomButton(
                //     width: 100,
                //     title: 'Shop',
                //     backgroundColor: Colors.blue,
                //     onTap: () {
                //       Get.to(() => const InApp(), transition: Transition.fade);
                //     },
                //   ),
                if (iconName != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Image.asset(
                      iconName ?? '',
                      width: iconWidth ?? 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                CustomLabel(
                  title: title,
                  isLocale: isLocale,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (showMenuButton)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (onTapMenu != null) {
                  onTapMenu!();
                }
            },
            child: Container(
              color: Colors.transparent,
              child: Image.asset(
                AppImages.ic_menu,
                width: 30,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          if (showTopRight)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (onTapTopRight != null) {
                  onTapTopRight!();
                }
            },
            child: Container(
              color: Colors.transparent,
              child: Image.asset(
                AppImages.ic_remove,
                width: 30,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ]
      ),
    );
  }
}
