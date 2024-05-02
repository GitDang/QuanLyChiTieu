import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSelect extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final List<String> listOptions;
  final Function changeSelect;

  const CustomSelect({
    super.key,
    this.title = '',
    this.textStyle,
    required this.listOptions,
    required this.changeSelect,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_CustomSelectController());
    controller.changeSelectedIndex(listOptions[0]);

    return Obx(() => DropdownButton<String>(
      value: controller.selectedIndex.value,
      icon: null,
      elevation: 16,
      style: textStyle,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        controller.changeSelectedIndex(value.toString());
        changeSelect(value.toString());
      },
      items: listOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}

class _CustomSelectController extends GetxController {
  static _CustomSelectController get instance => Get.find();

  var selectedIndex = ''.obs;

  void changeSelectedIndex(String index) {
    selectedIndex.value = index;
  }
}
