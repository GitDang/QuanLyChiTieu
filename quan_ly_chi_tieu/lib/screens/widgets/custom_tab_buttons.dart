import 'package:base_project/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:base_project/resources/colors.dart';
import 'package:get/get.dart';

class CustomTabButtons extends StatelessWidget {
  final List<String> listButtonTitle;
  final bool isLocale;
  final Function didSelectedIndex;
  final int initIndex;

  const CustomTabButtons({
    super.key,
    required this.listButtonTitle,
    this.isLocale = true,
    required this.didSelectedIndex,
    this.initIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          for (int i = 0; i < listButtonTitle.length; i++)
            Expanded(
              child: Column(
                children: [
                  CustomButton(
                    backgroundColor: Colors.transparent,
                    title: listButtonTitle[i],
                    titleStyle: TextStyle(
                      color: (initIndex == i) ? ff4A9E18 : ff606060,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () {
                      didSelectedIndex(i);
                    },
                  ),
                  if (initIndex == i)
                    Container(
                      width: 33,
                      height: 3,
                      color: ff4A9E18,
                    ),
                ],
              ),
            ),
        ],
      );
  }
}
