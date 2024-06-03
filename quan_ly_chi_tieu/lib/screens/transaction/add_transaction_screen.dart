import 'dart:convert';
import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

ImagePicker? picker;

class AddTransactionScreen extends StatelessWidget {
  final int type;
  final picker = ImagePicker();

  AddTransactionScreen({
    super.key,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTransactionController())..changeFirstLoad(type);
    var screenSize = MediaQuery.of(context).size;
    return BaseScreen(
      showBackButton: true,
      title: 'add.transaction.title',
      onTapAfterBack: () {
        controller.clearData();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Obx(() => CustomSegmented(
              listButtonTitle: const [
                'home.segmented.income',
                'home.segmented.expense',
              ],
              initIndex: controller.typeCategory.value,
              didSelectedIndex: (int index) {
                controller.changeTypeCategory(index);
                controller.changeCategorySelect(0);
              },
            )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.moneyTextController,
                      textInputType: TextInputType.number,
                      borderInputStyle: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: ff606060, width: 2)),
                      ),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        color: ff606060,
                        fontSize: 25,
                      ),
                      hintText: '0',
                      hintTextStyle: const TextStyle(
                        fontSize: 25,
                        color: ffC5C5C5,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CustomLabel(
                    title: '',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CustomLabel(
              title: 'add.transaction.category',
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 20),
            listCategoryWidget(),
            const SizedBox(height: 25),
            Obx(() => Row(
              children: [
                dateButton(date: controller.dateOptions[0].date, title: controller.dateOptions[0].title, value: controller.dateOptions[0].value),
                const SizedBox(width: 20),
                dateButton(date: controller.dateOptions[1].date, title: controller.dateOptions[1].title, value: controller.dateOptions[1].value),
                const SizedBox(width: 20),
                if (controller.showDateSelected.value == '')
                dateButton(date: controller.dateOptions[2].date, title: controller.dateOptions[2].title, value: controller.dateOptions[2].value),
                Row(
                  children: [
                    if (controller.showDateSelected.value != '')
                    dateButton(date: controller.showDateSelected.value, title: '', value: controller.datepickerValue.value)
                  ],
                ),
                const Spacer(),
                GestureDetector(
                   onTap: () async {
                    // TODO:
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      locale: const Locale('en', 'EN'),
                      initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(1970), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now(),
                      selectableDayPredicate: _decideWhichDayToEnable,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (pickedDate != null ){
                      controller.changeDateSelect(pickedDate);
                    }
                  },
                  child: Image.asset(AppImages.ic_calendar, width: 30, fit: BoxFit.fitWidth),
                ),
              ],
            )),
            const SizedBox(height: 40),
            const CustomLabel(
              title: 'add.transaction.comment',
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: controller.commentTextController,
              borderInputStyle: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ff606060, width: 2)),
              ),
              textStyle: const TextStyle(
                color: ff606060,
                fontSize: 25,
              ),
              hintText: 'add.transaction.comment',
            ),
            const SizedBox(height: 40),
            const CustomLabel(
              title: 'add.transaction.photo',
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            Obx(() => Row(
              children: [
                photoButton(imagePath: controller.imageUploadPath1.value, position: 0),
                const SizedBox(width: 20),
                photoButton(imagePath: controller.imageUploadPath2.value, position: 1),
              ],
            )),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  title: 'add.transaction.add',
                  width: screenSize.width / 2,
                  onTap: () {
                    controller.createTransaction();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget listCategoryWidget() {
    final controller = Get.put(AddTransactionController());
    return Obx(() => Column(
      children: [
        if(controller.typeTransactions.value == Global.EXPENSES)
        const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomLabel(
                title: 'category.cost.fixed',
                textAlign: TextAlign.start,
                customTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        for (int i = 0; i <= controller.listCategoryFixeds.length; i += 3)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 270,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (controller.listCategoryFixeds.length > i)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryFixeds[i].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryFixeds[i],
                        ((controller.categorySelect.value == controller.listCategoryFixeds[i].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                    if (controller.listCategoryFixeds.length > i)
                    const SizedBox(width: 35),
                    if (controller.listCategoryFixeds.length > i + 1)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryFixeds[i + 1].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryFixeds[i + 1],
                        ((controller.categorySelect.value == controller.listCategoryFixeds[i + 1].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                    if (controller.listCategoryFixeds.length > i + 1)
                    const SizedBox(width: 35),
                    if (controller.listCategoryFixeds.length > i + 2)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryFixeds[i + 2].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryFixeds[i + 2],
                        ((controller.categorySelect.value == controller.listCategoryFixeds[i + 2].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                  if ((controller.listCategoryFixeds.length >= i) && (controller.listCategoryFixeds.length < i + 3))
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              controller.createCategory(Global.TYPE_FIXED);
                            },
                            child: Image.asset(AppImages.ic_create, width: 55, fit: BoxFit.fitWidth),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                          child: CustomLabel(
                            title: '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if(controller.typeTransactions.value == Global.EXPENSES)
        const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomLabel(
                title: 'category.cost.fixed',
                textAlign: TextAlign.start,
                customTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        if(controller.typeTransactions.value == Global.EXPENSES)
        for (int i = 0; i <= controller.listCategoryExtras.length; i += 3)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 270,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (controller.listCategoryExtras.length > i)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryExtras[i].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryExtras[i],
                        ((controller.categorySelect.value == controller.listCategoryExtras[i].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                    if (controller.listCategoryExtras.length > i)
                    const SizedBox(width: 35),
                    if (controller.listCategoryExtras.length > i + 1)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryExtras[i + 1].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryExtras[i + 1],
                        ((controller.categorySelect.value == controller.listCategoryExtras[i + 1].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                    if (controller.listCategoryExtras.length > i + 1)
                    const SizedBox(width: 35),
                    if (controller.listCategoryExtras.length > i + 2)
                    GestureDetector(
                      onTap: () {
                        controller.changeCategorySelect(controller.listCategoryExtras[i + 2].id);
                      },
                      child: itemCategoryWidget(
                        controller.listCategoryExtras[i + 2],
                        ((controller.categorySelect.value == controller.listCategoryExtras[i + 2].id) ? ffFFE67C : Colors.white)
                      ),
                    ),
                  if ((controller.listCategoryExtras.length >= i) && (controller.listCategoryExtras.length < i + 3))
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              controller.createCategory(Global.TYPE_EXTRA);
                            },
                            child: Image.asset(AppImages.ic_create, width: 55, fit: BoxFit.fitWidth),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                          child: CustomLabel(
                            title: '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget itemCategoryWidget(CategoryModel category, borderColor) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: borderColor, width: 3),
          ),
          padding: const EdgeInsets.all(2),
          child: CategoryIcon(
            width: 55,
            imageWidth: 43,
            imageName: category.icon,
            color: Color(int.parse(category.color)),
          ),
        ),
        SizedBox(
          width: 60,
          child: CustomLabel(
            title: category.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget dateButton({String date = '', String title = '', String value = ''}) {
    final controller = Get.put(AddTransactionController());
    return GestureDetector(
      onTap: () {
        controller.changeDateSelectOption(value);
      },
      child: Container(
        width: 75,
        height: 58,
        decoration: BoxDecoration(
          color: (controller.dateSelected.value == value) ? ffFFE67C : ffEBEBD8,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomLabel(
                title: date,
              ),
            ),
            CustomLabel(
              title: title,
            ),
          ],
        ),
      ),
    );
  }

  Widget photoButton({String imagePath = '', int position = 0}) {
    final controller = Get.put(AddTransactionController());
    return GestureDetector(
      onTap: () async {
        // TODO:()
        final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

        if (file != null) {
          controller.changeImage(file, position);
            // Here your onChanged() function is returning just one image
        }
      },
      child: Column(
        children: [
          if (imagePath != '')
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.file(
              File(imagePath), width: 60, height: 60, fit: BoxFit.cover,
              ),
          ),
          if (imagePath == '')
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ffBBBBA1,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: const CustomLabel(
              title: '+',
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}

bool _decideWhichDayToEnable(DateTime day) {
  if (day.isAfter(DateTime.now())) {
    return false;
  }
  return true;
}

class AddTransactionController extends GetxController {
  static AddTransactionController get instance => Get.find();
  var typeCategory = 0.obs;
  var firstLoad = false.obs;
  var listCategoryFixeds = <CategoryModel>[].obs;
  var listCategoryExtras = <CategoryModel>[].obs;
  var categorySelect = 0.obs;
  var dateOptions = <DateOption> [
    DateOption(date: DateTimeUtil.stringFromDateTime(DateTime.now().subtract(const Duration(days: 2)), dateFormat: 'MM/dd'), title: '2 days ago', value: DateTimeUtil.stringFromDateTime(DateTime.now().subtract(const Duration(days: 2)))),
    DateOption(date: DateTimeUtil.stringFromDateTime(DateTime.now().subtract(const Duration(days: 1)), dateFormat: 'MM/dd'), title: 'Tomorrow', value: DateTimeUtil.stringFromDateTime(DateTime.now().subtract(const Duration(days: 1)))),
    DateOption(date: DateTimeUtil.stringFromDateTimeNow(dateFormat: 'MM/dd'), title: 'Today', value: DateTimeUtil.stringFromDateTimeNow()),  
  ];

  var showDateSelected = ''.obs;
  var datepickerValue = ''.obs;
  var dateSelected = ''.obs;
  var imageUploadPath = ['', ''].obs;
  var imageUploadPath1 = ''.obs;
  var imageUploadPath2 = ''.obs;
  final imageUpload = [XFile(''), XFile('')].obs;
  final TextEditingController moneyTextController = TextEditingController();
  final TextEditingController commentTextController = TextEditingController();

  var typeTransactions = ''.obs;

  void changeTypeCategory(int type) async {
    await Future.delayed(Duration.zero);
    typeCategory.value = type;
    if (type == 0) {
      typeTransactions.value = Global.INCOMES;
    } else {
      typeTransactions.value = Global.EXPENSES;
    }
    
    listCategoriesData();
  }

  void changeFirstLoad(type) {
    if (firstLoad.isFalse) {
      changeTypeCategory(type);
      firstLoad.value = true;
    }
  }

  void changeCategorySelect(int type) {
    categorySelect.value = type;
  }

  void changeDateSelect(DateTime date) {
    if (!date.isAfter(DateTime.now())) {
      String dateString = DateTimeUtil.stringFromDateTime(date);
      if (date.isBefore(DateTimeUtil.dateTimeFromString(dateOptions[0].value))) {
        showDateSelected.value = DateTimeUtil.stringFromDateTime(date, dateFormat: 'MM/dd');
        datepickerValue.value = dateString;
      } else {
        showDateSelected.value = '';
        datepickerValue.value = '';
      }
      dateSelected.value = dateString;
    }
  }
  
  void changeDateSelectOption(String date) {
    dateSelected.value = date;
  }

  // add image
  void changeImage(XFile image, int position) {
    var newImageUploadPath = imageUploadPath.value;
    var newImageUpload = imageUpload.value;

    newImageUploadPath[position] = image.path;
    newImageUpload[position] = image;

    imageUploadPath.value = newImageUploadPath;
    imageUpload.value = newImageUpload;

    switch (position) {
      case 0:
        imageUploadPath1.value = image.path;
        break;
      case 1:
        imageUploadPath2.value = image.path;
        break;
    }
  }

  // get list categories
  void listCategoriesData() async {
    var listCategories = <CategoryModel>[];
    if (typeTransactions.value == Global.INCOMES) {
      listCategories = await DatabaseManager.instance.getTypeIncomes();
    } else {
      listCategories = await DatabaseManager.instance.getTypeExpenses();
    }

    var listCategoryFixedsTemp = <CategoryModel>[];
    var listCategoryExtrasTemp = <CategoryModel>[];
    for (var category in listCategories) {
      if (category.type == Global.TYPE_FIXED) {
        listCategoryFixedsTemp.add(category);
      }
      if (category.type == Global.TYPE_EXTRA) {
        listCategoryExtrasTemp.add(category);
      }
    }
    listCategoryFixeds.value = listCategoryFixedsTemp;
    listCategoryExtras.value = listCategoryExtrasTemp;
  }

  // create new transaction
  void createTransaction() async {

    // validation form data
    int? inputMoney = int.tryParse(moneyTextController.text);
    if (inputMoney == null) {
      return CommonUtil.showToast('input_money.must_be_positive_number'.tr);
    }
    if (inputMoney <= 0) {
      return CommonUtil.showToast('input_money.must_be_positive_number'.tr);
    }
    if (inputMoney >= 100000000) {
      return CommonUtil.showToast('input_money.max_value'.tr);
    }
    if (categorySelect.value == 0) {
      return CommonUtil.showToast('add.transaction.category_required'.tr);
    }
    if (dateSelected.value == '') {
      return CommonUtil.showToast('add.transaction.date_required'.tr);
    }
    var imageTrasaction = [];
    for (var i = 0; i < imageUploadPath.length; i ++) {
      if (imageUploadPath.value[i] != '') {
        final duplicateFilePath = await getApplicationDocumentsDirectory();
        var fileName = basename(imageUploadPath.value[i]);
        await imageUpload.value[i].saveTo('${duplicateFilePath.path}/$fileName');
        imageTrasaction.add('${duplicateFilePath.path}/$fileName');
      }
    }

    // add new transaction
    int newMoney = Global.accountModel.money;
    if (typeTransactions.value == Global.INCOMES) {
      DatabaseManager.instance.addIncome(money: inputMoney, type_id: categorySelect.value, date: dateSelected.value, note: commentTextController.text, images: jsonEncode(imageTrasaction));
      newMoney = newMoney + inputMoney;
    } else {
      DatabaseManager.instance.addExpense(money: inputMoney, type_id: categorySelect.value, date: dateSelected.value, note: commentTextController.text, images: jsonEncode(imageTrasaction));
      newMoney = newMoney - inputMoney;
    }

    // update new money
    DatabaseManager.instance.updateAccount(newMoney);
    Global.accountModel.money = newMoney;
    clearData();

    Get.to(() => const HomeScreen());
  }

  //reset data 
  void clearData() {
    firstLoad.value = false;
    moneyTextController.text = '';
    commentTextController.text = '';
    imageUpload.value = [XFile(''), XFile('')];
    imageUploadPath.value = ['', ''];
    imageUploadPath1.value = '';
    imageUploadPath2.value = '';
    categorySelect.value = 0;
    dateSelected.value = '';
    showDateSelected.value = '';
    datepickerValue.value = '';
  }

  createCategory(typeFixed) {
    Get.to(() => CategoryAddScreen(typeCategory: typeCategory.value, typeFixed: typeFixed,));
  }
}

class DateOption {
  final String date;
  final String title;
  final String value;

  DateOption({required this.date, required this.title, required this.value});
  factory DateOption.fromJson(Map<String, dynamic> json) => DateOption(
    date: json['date'],
    title: json['title'],
    value: json['value'],
  );
}
