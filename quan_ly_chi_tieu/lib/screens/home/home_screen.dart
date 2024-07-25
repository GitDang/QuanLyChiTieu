import 'package:base_project/screens/InApp/in_app.dart';
import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';
import 'component/home_chart.dart';
import 'component/transaction_cell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController())..getListDataTransactions();
    var screenSize = MediaQuery.of(context).size;
    var heightContent = screenSize.height - 250;
    heightContent = CommonUtil.checkScreenSize(heightContent);

    return BaseScreen(
      showBackButton: false,
      showMenuButton: true,
      title: 'home.title',
      appBarIconName: AppImages.ic_nav_money,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  child: CustomLabel(
                    title:
                        '${Global.accountModel.money < 0 ? '-' : ''}${CommonUtil.moneyFormat(Global.accountModel.money.toString())}',
                    isLocale: false,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Global.accountModel.money < 0 ? ffEA0503 : ff606060,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    child: const Text(
                      'Guide',
                      style: TextStyle(
                          color: Color.fromARGB(255, 83, 60, 79), fontSize: 15),
                    )),
              ],
            ),
            const SizedBox(height: 14),
            Obx(() => CustomSegmented(
                  listButtonTitle: const [
                    'home.segmented.income',
                    'home.segmented.expense',
                  ],
                  initIndex: controller.typeCategory.value,
                  didSelectedIndex: (int index) {
                    controller.changeSelectIndex(index);
                    controller.getListDataTransactions();
                  },
                )),
            const SizedBox(height: 20),
            SizedBox(
              height: heightContent,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Obx(() => HomeChart(
                        totalMoney: controller.totalMoney.toInt(),
                        dataChart: controller.listTypeActive.toList(),
                        startDate: controller.startDate.value,
                        endDate: controller.endDate,
                        currentState: controller.currentState,
                        typeTransactions: controller.typeTransactions,
                        onTapAddTransaction: () {
                          controller
                              .addTransaction(controller.typeCategory.value);
                        },
                        changeDate: (startDateChange, endDateChange,
                            currentStateChange) {
                          controller.changeDateRange(
                              startDateChange, endDateChange);
                          controller.changeCurrentState(currentStateChange);
                          controller.getListDataTransactions();
                        },
                      )),
                  const SizedBox(height: 20),
                  Obx(
                    () => Column(
                      children: [
                        for (var indexList = 0;
                            indexList < controller.listTypeActive.length;
                            indexList++)
                          GestureDetector(
                            onTap: () {
                              controller.goToTransactionByCategory(
                                  controller.listTypeActive[indexList].typeId);
                            },
                            child: TransactionCell(
                                dataShow: controller.listTypeActive[indexList],
                                totalMoney: controller.totalMoney.toInt()),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var listIncomes = <TransactionsModel>[].obs;
  var totalMoney = 0.obs;
  var listTypeActive = <TransactionsByCategoryModel>[].obs;
  var typeCategory = 0.obs;
  var startDate = DateTimeUtil.stringFromDateTimeNow().obs;
  var endDate = DateTimeUtil.stringFromDateTimeNow();
  var currentState = {
    'day': DateTimeUtil.stringFromDateTimeNow(),
    'week': DateTimeUtil.stringFromDateTimeNow(),
    'month': DateTimeUtil.stringFromDateTimeNow(),
    'year': DateTimeUtil.stringFromDateTimeNow()
  };
  String typeTransactions = Global.INCOMES;
  void changeDateRange(String start, String end) {
    startDate.value = start;
    endDate = end;
  }

  void changeCurrentState(currentDate) {
    currentState = currentDate;
  }

  void changeTransactionType(type) {
    typeTransactions = type;
  }

  void changeSelectIndex(index) {
    typeCategory.value = index;
    if (index == 0) {
      changeTransactionType(Global.INCOMES);
    } else {
      changeTransactionType(Global.EXPENSES);
    }
  }

  // get list data chart
  void getListDataTransactions() async {
    if (typeTransactions == Global.INCOMES) {
      listIncomes.value =
          await DatabaseManager.instance.getIncomes(startDate.value, endDate);
    } else {
      listIncomes.value =
          await DatabaseManager.instance.getExpenses(startDate.value, endDate);
    }
    int totalMoneyTemp = 0;
    var listTypeActiveTemp = <TransactionsByCategoryModel>[];
    for (var i = 0; i < listIncomes.length; i++) {
      totalMoneyTemp = totalMoneyTemp + listIncomes[i].money;
      if (listTypeActiveTemp.isNotEmpty) {
        var checkType = listTypeActiveTemp
            .where((type) => type.typeId == listIncomes[i].typeId);
        if (checkType.isEmpty) {
          listTypeActiveTemp.add(
              TransactionsByCategoryModel.fromJson(listIncomes[i].toJson()));
        } else {
          int index =
              getKeyInListType(listTypeActiveTemp, listIncomes[i].typeId);
          var newType = checkType.toList()[0];
          newType.money = newType.money + listIncomes[i].money;
          listTypeActiveTemp[index] = newType;
        }
      } else {
        listTypeActiveTemp
            .add(TransactionsByCategoryModel.fromJson(listIncomes[i].toJson()));
      }
    }
    listTypeActive.value = listTypeActiveTemp;
    totalMoney.value = totalMoneyTemp > 0 ? totalMoneyTemp : 1;
  }

  void addTransaction(int type) {
    Get.to(() => AddTransactionScreen(type: type));
  }

  void goToTransactionByCategory(int categoryId) {
    Get.to(() => TransactionListCategoryScreen(
        categoryId: categoryId, typeCategory: typeCategory.value));
  }

  getKeyInListType(listType, id) {
    for (var i = 0; i < listType.length; i++) {
      if (listType[i].typeId == id) {
        return i;
      }
    }
  }

  void openInapp() {
    Get.to(() => const InApp());
  }
}
