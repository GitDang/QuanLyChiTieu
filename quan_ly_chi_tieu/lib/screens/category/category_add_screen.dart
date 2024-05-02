import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';
import 'package:base_project/utils/commons/common_util.dart';

var listIcons = [
  AppImages.ic_cate_bill,
  AppImages.ic_cate_education,
  AppImages.ic_cate_entertainment,
  AppImages.ic_cate_insurance,
  AppImages.ic_cate_meal,
  AppImages.ic_cate_delivery,
  AppImages.ic_cate_medical,
  AppImages.ic_cate_water,
  AppImages.ic_cate_wifi,
  AppImages.ic_cate_estate,
  AppImages.ic_cate_investment,
  AppImages.ic_cate_overtime,
  AppImages.ic_cate_random,
];

var listColors = [
  '0xffED1999', '0xffFFD008', '0xffEA0503', '0xff4A9E18'
];

List<String> listTypeValue = <String>[Global.INCOMES, Global.EXPENSES];

class CategoryAddScreen extends StatelessWidget {
  const CategoryAddScreen({super.key, required this.typeCategory, required this.typeFixed});
  final int typeCategory;
  final int typeFixed;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryAddController())..changeTypeCategory(typeCategory);
    const List<String> listType = <String>['収入', '支出'];
    var screenSize = MediaQuery.of(context).size;

    return BaseScreen(
      showBackButton: true,
      showMenuButton: false,
      title: 'category.add',
      keyRoute: 'category',
      onTapAfterBack: () {
        controller.clearData();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 14),
            CustomTextField(
              title: 'category.name',
              height: 25,
              controller: controller.nameTextController,
              borderInputStyle: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ff606060, width: 2)),
              ),
              textStyle: const TextStyle(
                color: ff606060,
                fontSize: 15,
              ),
              hintText: 'category.name',
              onChanged: (text) {
                controller.changeShowValidateError(false);
              },
            ),
            Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.showValidateError.value)
                const CustomLabel(
                  title: 'category.add.name_required',
                  customTextStyle: TextStyle(
                    color: ffF04949,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var typeIconIndex = 0; typeIconIndex < listTypeValue.length; typeIconIndex++)
                SizedBox(
                  width: 120,
                  child: Obx(() => RadioListTile (
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(listType[typeIconIndex]),
                    value: listTypeValue[typeIconIndex],
                    groupValue: controller.typeTransactions.value,
                    activeColor: ff0F8904,
                    onChanged: (value) {
                      controller.changeTypeTransactions(value.toString());
                    },
                  )),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabel(
                  title: 'category.plan',
                  customTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabel(
                  title: 'category.icon',
                  customTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(() => Column(
              children: [
                for (int i = 0; i <= listIcons.length; i += 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 310,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (listIcons.length > i)
                              GestureDetector(
                                onTap: () {
                                  controller.changeCategorySelect(i);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ff606060.withOpacity((controller.categorySelect.value == i) ? 0.25 : 0),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(controller.categorySelect.value == i ? 1 : 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: [
                                      CategoryIcon(
                                        width: 60,
                                        imageWidth: 43,
                                        imageName: listIcons[i],
                                        color: ffBBBBA1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (listIcons.length > i)
                              const SizedBox(width: 5),
                              if (listIcons.length > i + 1)
                              GestureDetector(
                                onTap: () {
                                  controller.changeCategorySelect(i + 1);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ff606060.withOpacity((controller.categorySelect.value == i + 1) ? 0.25 : 0),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(controller.categorySelect.value == i + 1 ? 1 : 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: [
                                      CategoryIcon(
                                        width: 60,
                                        imageWidth: 43,
                                        imageName: listIcons[i + 1],
                                        color: ffBBBBA1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (listIcons.length > i + 1)
                              const SizedBox(width: 5),
                              if (listIcons.length > i + 2)
                              GestureDetector(
                                onTap: () {
                                  controller.changeCategorySelect(i + 2);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ff606060.withOpacity((controller.categorySelect.value == i + 2) ? 0.25 : 0),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(controller.categorySelect.value == i + 2 ? 1 : 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: [
                                      CategoryIcon(
                                        width: 60,
                                        imageWidth: 43,
                                        imageName: listIcons[i + 2],
                                        color: ffBBBBA1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabel(
                  title: 'category.color',
                  customTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
            Row(
              children: [
                for(var colorItem in listColors)
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 40),
                  child:
                    GestureDetector (
                      onTap: () {
                        controller.changeTypeColor(colorItem);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(int.parse(colorItem)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (controller.typeColor.value == colorItem)
                              Image.asset(AppImages.ic_check, width: 10, fit: BoxFit.fitWidth),
                            ],
                          )),
                        ),
                      ),
                    )
                )
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  title: 'category.plus',
                  width: screenSize.width / 2,
                  onTap: () {
                    controller.createCategory(this.typeFixed);
                  },
                ),
              ],
            ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}

class CategoryAddController extends GetxController {
  static CategoryAddController get instance => Get.find();

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController monthlyTextController = TextEditingController();
  var categorySelect = 0.obs;
  var typeTransactions = Global.EXPENSES.obs;
  var typeIcon = listIcons[0].obs;
  var typeColor = listColors[0].obs;
  var showValidateError = false.obs;

  void validation(BuildContext context) async {
    _requestLogin(context);
  }

  void _requestLogin(BuildContext context) async {
    Get.to(() => const HomeScreen());
  }

  void changeCategorySelect(int index) {
    categorySelect.value = index;
    changeTypeIcon(listIcons[index]);
  }

  void changeTypeTransactions(String type) {
    typeTransactions.value = type;
  }

  void changeTypeIcon(String icon) {
    typeIcon.value = icon;
  }

  void changeTypeColor(String color) {
    typeColor.value = color;
  }

  void changeShowValidateError(bool show) {
    showValidateError.value = show;
  }

  void changeTypeCategory(int type) async {
    await Future.delayed(Duration.zero);
    changeTypeTransactions(listTypeValue[type]);
    categorySelect.value = 0;
  }

    // create new category
  void createCategory(int typeFixed) async {

    // validation form data
    String inputName = nameTextController.text;
    
    if (inputName == '') {
      changeShowValidateError(true);
      return ;
    }

    var typeCategory = 0;
    // add new transaction
    if (typeTransactions.value == Global.INCOMES) {
      DatabaseManager.instance.addTypeIncome(
        name: inputName,
        icon: typeIcon.value,
        color: typeColor.value,
        type: typeFixed,
      );
    } else {
      DatabaseManager.instance.addTypeExpense(
        name: inputName,
        icon: typeIcon.value,
        color: typeColor.value,
        type: typeFixed,
      );
      typeCategory = 1;
    }

    clearData();
    Get.to(() => CategoryScreen(type: typeCategory));
  }

  void clearData() {
    nameTextController.text = '';
    monthlyTextController.text = '';
    categorySelect.value = 0;
    typeIcon.value = listIcons[0];
    typeColor.value = listColors[0];
  }

}
