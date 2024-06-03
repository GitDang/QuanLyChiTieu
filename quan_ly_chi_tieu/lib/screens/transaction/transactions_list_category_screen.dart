import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/screens/widgets/custom_select.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';

class TransactionListCategoryScreen extends StatelessWidget {
  final int categoryId;
  final int typeCategory;

  const TransactionListCategoryScreen({
    super.key,
    required this.categoryId,
    required this.typeCategory,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionListCategoryController())..changeTypeCategory(typeCategory, categoryId);
    var screenSize = MediaQuery.of(context).size;
    const List<String> list = <String>['日付順', '金額順'];
    return BaseScreen(
      showBackButton: true,
      title: 'category.title',
      keyRoute: 'category',
      showTopRight: true,
      onTapTopRight: () {controller.showAlertDialog(context);},
      child: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => Column(
            children: [
              if (controller.totalMoney.value > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => CustomLabel(
                    title: CommonUtil.moneyFormat(controller.totalMoney.value.toString()),
                    isLocale: false,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  )),
                ],
              ),
              const SizedBox(height: 20),
              if (controller.totalMoney.value > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomSelect(
                    listOptions: list,
                    textStyle: const TextStyle(
                      color: ff606060,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    changeSelect: (String value) {
                      controller.changeSortTransaction(value);
                    },
                  ),
                ],
              ),
            ],
          )),
          Obx(() => Column(
            children: [
              if (controller.totalMoney.value == 0)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: CustomLabel(
                  title: 'category.no_transaction',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
          SizedBox(
            height: screenSize.height - 350,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() =>  Column(
                    children: [
                      for (var indexList = 0; indexList < controller.listShowTransactions.length; indexList++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomLabel(title: changeShowDate(controller.listShowTransactions[indexList].date)),
                            ],
                          ),
                          for (var index in controller.listShowTransactions[indexList].listIndex)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.gotoTransactionDetail(controller.listTransactions[index].id);
                            },
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CategoryIcon(
                                              width: 55,
                                              imageWidth: 43,
                                              imageName: controller.listTransactions[index].typeIcon,
                                              color: Color(int.parse(controller.listTransactions[index].typeColor)),
                                            ),
                                            const SizedBox(width: 10,),
                                            CustomLabel(title: controller.listTransactions[index].typeName)
                                          ],
                                        ),
                                        CustomLabel(title: CommonUtil.moneyFormat(controller.listTransactions[index].money.toString()))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 65),
                                        CustomLabel(title: controller.listTransactions[index].note)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              )),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ff606060.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            padding: const EdgeInsets.all(2),
            child: GestureDetector(
              onTap: () {
                controller.gotoAddTransaction();
              },
              child: Image.asset(AppImages.ic_create, width: 60, fit: BoxFit.fitWidth),
            ),
          ),
        ],
      ),
    );
  }
}

String changeShowDate(date) {
  var dateTime = DateTimeUtil.dateTimeFromString(date);
  return DateTimeUtil.stringFromDateTime(dateTime, dateFormat: 'yyyy/MM/dd');
}

class TransactionListCategoryController extends GetxController {
  static TransactionListCategoryController get instance => Get.find();
  var typeCategory = 0.obs;
  var listTransactions = <TransactionsModel>[].obs;
  var listShowTransactions = <ShowListTransaction>[].obs;
  var totalMoney = 0.obs;
  var typeTransactions = ''.obs;
  var categoryId = 0.obs;

  void changeTypeCategory(int type, int categoryCurrentId) async {
    typeCategory.value = type;
    categoryId.value = categoryCurrentId;

    if (type == 0) {
      typeTransactions.value = Global.INCOMES;
    } else {
      typeTransactions.value = Global.EXPENSES;
    }
    listTransactionsCategoriesData(categoryCurrentId);
  }

  changeSortTransaction (String sortBy) {
    var newListTransactions = listShowTransactions.value;
    listShowTransactions.value = <ShowListTransaction>[];
    if (sortBy == '日付順') {
      newListTransactions.sort((a, b) => a.date.compareTo(b.date));
    } else {
      newListTransactions.sort((a, b) => b.date.compareTo(a.date));
    }
    listShowTransactions.value = newListTransactions;
  }

  // get list categories
  void listTransactionsCategoriesData(categoryId) async {
    if (typeTransactions.value == Global.INCOMES) {
      listTransactions.value = await DatabaseManager.instance.getIncomesByCategories(categoryId);
    } else {
      listTransactions.value = await DatabaseManager.instance.getExpensesByCategories(categoryId);
    }
    int totalMoneyTemp = 0;
    var listTransactionsTemp = <ShowListTransaction>[];
    var currentDate = '';
    for(var i = 0; i < listTransactions.length; i++){
      totalMoneyTemp = totalMoneyTemp + listTransactions[i].money;
      if(currentDate != listTransactions[i].date) {
        listTransactionsTemp.add(ShowListTransaction(date: listTransactions[i].date, listIndex: [i]));
        currentDate = listTransactions[i].date;
      } else {
        var newListTransaction = listTransactionsTemp[listTransactionsTemp.length - 1];
        newListTransaction.listIndex.add(i);
        listTransactionsTemp[listTransactionsTemp.length - 1] = newListTransaction;
      }
    }
    listShowTransactions.value = listTransactionsTemp;
    totalMoney.value = totalMoneyTemp;
  }

  void gotoAddTransaction() {
    Get.to(() => AddTransactionScreen(type: typeCategory.value));
  }

  void gotoTransactionDetail(int transactionId) {
    Get.to(() => TransactionDetailScreen(typeId: typeCategory.value, transactionId: transactionId));
  }

  removeCategory() async {
    if (typeTransactions.value == Global.INCOMES) {
      await DatabaseManager.instance.deleteTypeIncomeById(categoryId.value);
    } else {
      await DatabaseManager.instance.deleteTypeExpenseById(categoryId.value);
    }
    Get.to(() => CategoryScreen(type: typeCategory.value,));
  }
  showAlertDialog(BuildContext context) {

    if (totalMoney.value > 0) {
      return CommonUtil.showToast('category.not_remove'.tr);
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.all(0),
      actions: [
        TextButton(
          child: const CustomLabel(
            title: 'transaction.no',
            customTextStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ff606060,
            ),
          ),
          onPressed:  () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const CustomLabel(
            title: 'transaction.yes',
            customTextStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ff606060,
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await removeCategory();
          },
        ),
      ],
      content: const SizedBox(
        height: 25,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: CustomLabel(
                title: 'category.delete_confirm',
                customTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      )
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ShowListTransaction {
  final String date;
  final List listIndex;

  ShowListTransaction({required this.date, required this.listIndex});
  factory ShowListTransaction.fromJson(Map<String, dynamic> json) => ShowListTransaction(
    date: json['date'],
    listIndex: json['listIndex'],
  );
}
