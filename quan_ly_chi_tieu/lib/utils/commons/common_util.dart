import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:base_project/screens/widgets/widgets.dart';
import 'package:base_project/resources/colors.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CommonUtil {
  // region - Validate
  static String phoneValidate(String value) {
    if (value.isEmpty) {
      return 'sdt_khong_duoc_de_trong';
    }
    RegExp regex = RegExp('^[0-9]{10}\$');
    if (!regex.hasMatch(value)) {
      return 'sdt_sai_dinh_dang';
    }
    return '';
  }

  static String passwordValidate(String value) {
    if (value.isEmpty) {
      return 'mat_khau_khong_duoc_de_trong';
    }
    // if (value.length < 8 || value.length > 15 || value.contains(' ')) {
    //   return 'dinh_dang_mat_khau';
    // }
    return '';
  }

  static String passwordConfirmValidate(String rePass, String pass) {
    if (pass.isEmpty) {
      return 'mat_khau_khong_duoc_de_trong';
    } else if (rePass.isEmpty) {
      return 'nhap_lai_mat_khau_khong_duoc_de_trong';
    } else if (pass.isNotEmpty && pass != rePass) {
      return 'nhap_lai_mat_khau_sai';
    }
    return '';
  }

  static String emailValidate(String value) {
    if (value.isEmpty) {
      return 'email_khong_duoc_de_trong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'email_khong_dung';
    }
    return '';
  }

  // endregion

  // region - Loading
  static void showLoading() {
    Get.context?.loaderOverlay.show();
  }

  static void hideLoading() {
    Get.context?.loaderOverlay.hide();
  }

  // endregion

  // region - Toast
  static void showToast(String message, {bool isLocale = true}) {
    Fluttertoast.showToast(
      msg: isLocale ? message.tr : message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey.shade600.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  // endregion

  // region - Dialog
  static bool isPreventShowOtherDialog = false;

  static void showAlertDialog({
    String title = '',
    bool isTitleLocale = true,
    String content = '',
    bool isContentLocale = true,
    bool barrierDismissible = false,
    String titleNegative = '',
    Function? onPressNegative,
    String titlePositive = 'dong',
    Function? onPressPositive,
  }) {
    if (isPreventShowOtherDialog) return;

    BuildContext context = Get.context as BuildContext;
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext contextChild) {
        double width = MediaQuery.of(context).size.width;

        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: width - 60,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (title.isNotEmpty)
                    //   Text(
                    //     isTitleLocale ? context.localeString(title) : title,
                    //     style: const TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //       height: 1.5,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // const SizedBox(height: 30),
                    if (content.isNotEmpty)
                      Text(
                        isContentLocale ? content.tr : content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (titleNegative.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(right: 21),
                            child: CustomButton(
                              width: 112,
                              backgroundColor: Colors.white,
                              borderWidth: 1,
                              title: titleNegative.tr,
                              titleStyle: const TextStyle(
                                color: ffEA0503,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              isLocale: false,
                              onTap: () {
                                Get.back();
                                if (onPressNegative != null) onPressNegative();
                              },
                            ),
                          ),
                        CustomButton(
                          backgroundColor: ffEA0503,
                          borderWidth: 1,
                          title: titlePositive.tr,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          isLocale: false,
                          onTap: () {
                            Get.back();
                            if (onPressPositive != null) onPressPositive();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      isPreventShowOtherDialog = false;
    });
  }

  static void showAlertDialogConfirm({
    String content = '',
    bool isContentLocale = true,
    bool barrierDismissible = false,
    String titleNegative = 'huy',
    Function? onPressNegative,
    String titlePositive = 'tiep_tuc',
    Function? onPressPositive,
  }) {
    showAlertDialog(
      content: content,
      isContentLocale: isContentLocale,
      barrierDismissible: barrierDismissible,
      titleNegative: titleNegative,
      onPressNegative: onPressNegative,
      titlePositive: titlePositive,
      onPressPositive: onPressPositive,
    );
  }

// endregion

// region - Internet connection
  static Future<bool> isInternetConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }
// endregion

  static String moneyFormat(String price) {
      return '${showMoneyFormat(price)}円';
  }

  static String showMoneyFormat(String price) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
  }

  static String showNumberFormat(String number) {
    var value = int.parse(number);
    if (value >= 10000) {
      var newNumber = showMoneyFormat((value ~/ 10000).toString());
      if ((value % 10000) > 0) {
        return '$newNumber.${((value % 10000) / 1000).round()}万';
      }
      return '$newNumber万';
    }

    return showMoneyFormat(value.toString());
  }

  static double checkScreenSize(double height) {
    if (height < 600) {
      height += 37;
    }
    return height;
  }
}


