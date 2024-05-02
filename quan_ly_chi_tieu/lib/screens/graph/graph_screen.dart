import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/graph/component/graph_chart.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';
import 'package:base_project/screens/home/component/transaction_cell.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GraphController())..getListDataTransactions();
    var screenSize = MediaQuery.of(context).size;
    var heightContent = screenSize.height - 190;
    heightContent = CommonUtil.checkScreenSize(heightContent);
    return BaseScreen(
      showBackButton: true,
      showMenuButton: true,
      keyRoute: 'graph',
      title: 'graph.title',
      child: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => CustomSegmented(
            listButtonTitle: const [
              'graph.all',
              'graph.income',
              'graph.expense',
            ],
            initIndex: controller.typeCategory.value,
            didSelectedIndex: (int index) {
              controller.changeTypeCategory(index);
            },
          )),
          const SizedBox(height: 20),
          SizedBox(
            height: heightContent,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: Obx(() => GraphChart(
                      showDataGraph: controller.showDataGraph.value,
                      startDate: controller.startDate.value,
                      endDate: controller.endDate,
                      currentState: controller.currentState,
                      typeTransactions: controller.typeTransactions.value,
                      listLabelGraph: controller.listLabelGraph,
                      listTitleGraph: controller.listTitleGraph,
                      listValueGraph: controller.listValueGraph,
                      showMonth: controller.typeDateGraph.value == 'month',
                      maxValue: controller.maxValue.value,
                      labelsColor: controller.labelsColor,
                      onTapAddTransaction: () {
                        // To do
                      },
                      changeDate: (startDateChange, endDateChange, currentStateChange, typeDateChange) {
                        controller.changeDateRange(startDateChange, endDateChange);
                        controller.changeCurrentState(currentStateChange);
                        controller.changeTypeDateGraph(typeDateChange);
                        controller.getListDataTransactions();
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => CustomLabel(
                          title: controller.typeTransactions.value == Global.ALL ? 'graph.detail.all' :
                          (controller.typeTransactions.value == Global.INCOMES ? 'graph.detail.income' : 'graph.detail.expense'),
                          customTextStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700
                          ),
                        ),)
                      ],
                    ),
                  ),
                  Obx(() => Column(
                    children: [
                      for (var indexList = 0; indexList < controller.listTypeIncomeActive.length + controller.listTypeExpenseActive.length; indexList++)
                      Column(
                        children: [
                          if (indexList < controller.listTypeExpenseActive.length)
                          TransactionCell(
                            dataShow: controller.listTypeExpenseActive[indexList],
                            totalMoney: controller.totalMoneyExpense.value,
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                          if (indexList >= controller.listTypeExpenseActive.length)
                           TransactionCell(
                            dataShow: controller.listTypeIncomeActive[indexList - controller.listTypeExpenseActive.length],
                            totalMoney: controller.totalMoneyIncome.value,
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class GraphController extends GetxController {
  static GraphController get instance => Get.find();

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  var listCategories = <CategoryModel>[].obs;
  var typeTransactions = Global.ALL.obs;
  var typeCategory = 0.obs;
  var typeItem = '支出'.obs;
  var startDate = DateTimeUtil.stringFromDateTime(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1))).obs;
  var endDate = DateTimeUtil.stringFromDateTime(DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)));
  var showDataGraph = true.obs;
  var listTypeActive = <TransactionsByCategoryModel>[].obs;
  var typeDateGraph = 'week'.obs;
  var labelsColor = [Colors.red, Colors.blue].obs;
  var listLabelGraph = [Global.EXPENSES, Global.INCOMES].obs;
  var listTitleGraph = [].obs;
  var listValueGraph = [].obs;
  var maxValue = 100000000.obs;
  var currentState = {
    'day': DateTimeUtil.stringFromDateTimeNow(),
    'week': DateTimeUtil.stringFromDateTimeNow(),
    'month': DateTimeUtil.stringFromDateTimeNow(),
    'year': DateTimeUtil.stringFromDateTimeNow()
  };

  var totalMoneyIncome = 0.obs;
  var totalMoneyExpense = 0.obs;
  var listTypeIncomeActive = <TransactionsByCategoryModel>[].obs;
  var listTypeExpenseActive = <TransactionsByCategoryModel>[].obs;

  void changeDateRange(String start, String end) {
    startDate.value = start;
    endDate = end;
  }
  void changeCurrentState(currentDate) {
    currentState = currentDate;
  }

  void validation(BuildContext context) async {
    _requestLogin(context);
  }

  void _requestLogin(BuildContext context) async {
    Get.to(() => const HomeScreen());
  }

  void changeTypeDateGraph(int type) {
    typeDateGraph.value = listDateTypes[type];
  }

  void changeTypeItem(String type) {
    typeItem.value = type;
  }

  void changeTypeCategory(int type) async {
    await Future.delayed(Duration.zero);
    typeCategory.value = type;
    switch (type) {
      case 0:
        listLabelGraph.value = [Global.EXPENSES, Global.INCOMES];
        typeTransactions.value = Global.ALL;
        labelsColor.value = [Colors.red, Colors.blue];
        break;
      case 1:
        listLabelGraph.value = [Global.INCOMES];
        typeTransactions.value = Global.INCOMES;
        labelsColor.value = [Colors.blue];
        break;
      case 2:
        listLabelGraph.value = [Global.EXPENSES];
        typeTransactions.value = Global.EXPENSES;
        labelsColor.value = [Colors.red];
        break;
    }
    getListDataTransactions();
  }

  // get list data chart
  void getListDataTransactions() async {
    var listTransactionIncomes = <TransactionsModel>[];
    var listTransactionExpenses = <TransactionsModel>[];
    listTitleGraph.value = [];
    listValueGraph.value = [];
    var listDataGraph = getListLabelGraph(startDate.value, endDate, typeDateGraph.value);
    int totalMoneyExpenseTemp = 0;
    int totalMoneyIncomeTemp = 0;
    var listTypeExpenseActiveTemp = <TransactionsByCategoryModel>[];
    var listTypeIncomeActiveTemp = <TransactionsByCategoryModel>[];
    listTypeExpenseActive.value = [];
    listTypeIncomeActive.value = [];
    // get data transaction with all and expense
    if (typeTransactions.value != Global.INCOMES) {
      listTransactionExpenses = await DatabaseManager.instance.getExpenses(startDate.value, endDate);
      for(var i = 0; i < listTransactionExpenses.length; i++){
        if (listDataGraph.isNotEmpty) {
          var checkType = listDataGraph.where(
            (type) => (
              (type.date.compareTo(listTransactionExpenses[i].date) <= 0) && (type.endDate.compareTo(listTransactionExpenses[i].date) >= 0)
            )
          );
          if(checkType.isNotEmpty) {
            var newGraph = checkType.toList()[0];
            int index = getKeyInDate(listDataGraph, newGraph.date);
            listDataGraph[index] = ChartGraphModel(
              date: newGraph.date,
              endDate: newGraph.endDate,
              showDate: newGraph.showDate,
              income: newGraph.income,
              expense: newGraph.expense + listTransactionExpenses[i].money
            );
          }
        }
        totalMoneyExpenseTemp = totalMoneyExpenseTemp + listTransactionExpenses[i].money;
        if (listTypeExpenseActiveTemp.isNotEmpty) {
          var checkType = listTypeExpenseActiveTemp.where((type) => type.typeId == listTransactionExpenses[i].typeId);
          if(checkType.isEmpty) {
            listTypeExpenseActiveTemp.add(TransactionsByCategoryModel.fromJson(listTransactionExpenses[i].toJson()));
          } else {
            int index = getKeyInListType(listTypeExpenseActiveTemp, listTransactionExpenses[i].typeId);
            var newType = checkType.toList()[0];
            newType.money = newType.money + listTransactionExpenses[i].money;
            listTypeExpenseActiveTemp[index] = newType;
          }
        } else {
          listTypeExpenseActiveTemp.add(TransactionsByCategoryModel.fromJson(listTransactionExpenses[i].toJson()));
        }
      }
      listTypeExpenseActive.value = listTypeExpenseActiveTemp;
      totalMoneyExpense.value = totalMoneyExpenseTemp > 0 ? totalMoneyExpenseTemp : 1;
    }
    // get data transaction with all and income
    if (typeTransactions.value != Global.EXPENSES) {
      listTransactionIncomes = await DatabaseManager.instance.getIncomes(startDate.value, endDate);
      for(var i = 0; i < listTransactionIncomes.length; i++){
        if (listDataGraph.isNotEmpty) {
          var checkType = listDataGraph.where(
            (type) => (
              (type.date.compareTo(listTransactionIncomes[i].date) <= 0) && (type.endDate.compareTo(listTransactionIncomes[i].date) >= 0)
            )
          );
          if(checkType.isNotEmpty) {
            var newGraph = checkType.toList()[0];
            int index = getKeyInDate(listDataGraph, newGraph.date);
            listDataGraph[index] = ChartGraphModel(
              date: newGraph.date,
              endDate: newGraph.endDate,
              showDate: newGraph.showDate,
              income: newGraph.income + listTransactionIncomes[i].money,
              expense: newGraph.expense
            );
          }
        }
        totalMoneyIncomeTemp = totalMoneyIncomeTemp + listTransactionIncomes[i].money;
        if (listTypeIncomeActiveTemp.isNotEmpty) {
          var checkType = listTypeIncomeActiveTemp.where((type) => type.typeId == listTransactionIncomes[i].typeId);
          if(checkType.isEmpty) {
            listTypeIncomeActiveTemp.add(TransactionsByCategoryModel.fromJson(listTransactionIncomes[i].toJson()));
          } else {
            int index = getKeyInListType(listTypeIncomeActiveTemp, listTransactionIncomes[i].typeId);
            var newType = checkType.toList()[0];
            newType.money = newType.money + listTransactionIncomes[i].money;
            listTypeIncomeActiveTemp[index] = newType;
          }
        } else {
          listTypeIncomeActiveTemp.add(TransactionsByCategoryModel.fromJson(listTransactionIncomes[i].toJson()));
        }
      }
      listTypeIncomeActive.value = listTypeIncomeActiveTemp;
      totalMoneyIncome.value = totalMoneyIncomeTemp > 0 ? totalMoneyIncomeTemp : 1;
    }

    var listTitleGraphTemp = [];
    var maxValueTemp = 0;
    List<List<double>> listValueGraphTemp = [];
    for (var graphValue in listDataGraph) {
      listTitleGraphTemp.add(graphValue.showDate);
      if (typeTransactions.value == Global.ALL) {
        listValueGraphTemp.add([graphValue.expense.toDouble(), graphValue.income.toDouble()]);
        maxValueTemp = (graphValue.income > maxValueTemp) ? graphValue.income : maxValueTemp;
        maxValueTemp = (graphValue.expense > maxValueTemp) ? graphValue.expense : maxValueTemp;
      } else if (typeTransactions.value == Global.INCOMES) {
        listValueGraphTemp.add([graphValue.income.toDouble()]);
        maxValueTemp = (graphValue.income > maxValueTemp) ? graphValue.income : maxValueTemp;
      } else {
        listValueGraphTemp.add([graphValue.expense.toDouble()]);
        maxValueTemp = (graphValue.expense > maxValueTemp) ? graphValue.expense : maxValueTemp;
      }
    }
    if (maxValueTemp > 0) {
      showDataGraph.value = true;
    } else {
      showDataGraph.value = false;
    }
    maxValue.value = maxValueTemp > 0 ? roundToMaxValue(maxValueTemp) : 10000000;
    listTitleGraph.value = listTitleGraphTemp;
    listValueGraph.value = listValueGraphTemp;
  }

  getKeyInListType (listType, id) {
    for(var i = 0; i < listType.length; i++){
      if (listType[i].typeId == id) {
        return i;
      }
    }
  }

  getKeyInDate (listType, date) {
    for(var i = 0; i < listType.length; i++){
      if (listType[i].date == date) {
        return i;
      }
    }
  }

  roundToMaxValue(int value) {
    var countValue = 1;
    for (var x = 1; x < value.toString().length; x++) {
      countValue = countValue * 10;
    }
    var newValue = (value / countValue).ceil();

    return newValue * countValue;
  }

  List<String> listDateTypes = ['week', 'month', 'year'];

  getListLabelGraph(startDate, endDate, typeDate) {
    DateTime startDateFormat = DateTimeUtil.dateTimeFromString(startDate);
    List<ChartGraphModel> listGraphModels = [];
    switch (typeDate) {
      case 'week':
        for(var i = 0; i < 7; i++) {
          listGraphModels.add(ChartGraphModel(
            date: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i))),
            endDate: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i))),
            showDate: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i)), dateFormat: 'dd月'),
            income: 0,
            expense: 0,
          ));
        }
        break;
      case 'month':
        for(var i = 0; i < DateUtils.getDaysInMonth(startDateFormat.year, startDateFormat.month); i++) {
          listGraphModels.add(ChartGraphModel(
            date: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i))),
            endDate: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i))),
            showDate: DateTimeUtil.stringFromDateTime(startDateFormat.add(Duration(days: i)), dateFormat: 'd'),
            income: 0,
            expense: 0,
          ));
        }
        break;
      case 'year':
        for(var i = 1; i <= 12; i++) {
          listGraphModels.add(ChartGraphModel(
            date: DateTimeUtil.stringFromDateTime(DateTime(startDateFormat.year, i, 1)),
            endDate: DateTimeUtil.stringFromDateTime(DateTime(startDateFormat.year, i + 1, 0)),
            showDate: '$i',
            income: 0,
            expense: 0,
          ));
        }
        break;
    }
    return listGraphModels;
  }
}
class ChartGraphModel {
  final String date;
  final String endDate;
  final String showDate;
  final int income;
  final int expense;

  ChartGraphModel({
    required this.date,
    required this.income,
    required this.expense,
    required this.showDate,
    required this.endDate,
  });
}
