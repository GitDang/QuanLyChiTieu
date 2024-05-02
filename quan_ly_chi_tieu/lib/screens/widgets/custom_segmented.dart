import 'package:base_project/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:base_project/resources/colors.dart';

class CustomSegmented extends StatelessWidget {
  final List<String> listButtonTitle;
  final bool isLocale;
  final int initIndex;
  final Function didSelectedIndex;

  const CustomSegmented({
    super.key,
    required this.listButtonTitle,
    this.isLocale = true,
    this.initIndex = 0,
    required this.didSelectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          for (int i = 0; i < listButtonTitle.length; i++)
            Expanded(
              child: CustomButton(
                backgroundColor: (initIndex == i) ? ffFFE67C : Colors.transparent,
                title: listButtonTitle[i],
                titleStyle: const TextStyle(
                  color: ff606060,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  didSelectedIndex(i);
                },
              ),
            ),
        ],
    );
  }
}
