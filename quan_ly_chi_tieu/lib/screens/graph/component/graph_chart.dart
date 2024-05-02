
import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphChart extends StatelessWidget {
  final Function onTapAddTransaction;
  final Function changeDate;
  final bool showDataGraph;
  final List listLabelGraph;
  final List listTitleGraph;
  final List listValueGraph;
  final int maxValue;
  final String startDate;
  final String endDate;
  final String typeTransactions;
  final Map currentState;
  final bool showMonth;
  final List labelsColor;

  const GraphChart({
    super.key,
    required this.onTapAddTransaction,
    required this.showDataGraph,
    required this.listLabelGraph,
    required this.listTitleGraph,
    required this.listValueGraph,
    required this.maxValue,
    required this.startDate,
    required this.endDate,
    required this.changeDate,
    required this.typeTransactions,
    required this.currentState,
    required this.showMonth,
    required this.labelsColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_GraphChartController())..changeShowDate(startDate, endDate);
    var enableButtonNext = checkEnableNext();
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ff606060,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Obx(() => CustomTabButtons(
            listButtonTitle: controller.listDateTypes,
            didSelectedIndex: (int index) {
              var dataDate = controller.didSelectedIndex(index, currentState);
              changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), currentState, controller.selectedIndex.value );
            },
            initIndex: controller.selectedIndex.value,
          )),
          const SizedBox(height: 5),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // TODO:
                  Map dataDate = controller.prevDate(startDate, currentState);
                  changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), dataDate['currentState'], controller.selectedIndex.value);
                },
                child: Image.asset(AppImages.ic_chart_back, width: 24, fit: BoxFit.fitWidth),
              ),
              Obx(() => Expanded(
                child: CustomLabel(
                  title: controller.showDateRange.toString(),
                  fontSize: 20,
                  textAlign: TextAlign.center,
                ),
              )),
              if (enableButtonNext)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Map dataDate = controller.nextDate(startDate, currentState);
                  changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), dataDate['currentState'], controller.selectedIndex.value);
                },
                child: Image.asset(AppImages.ic_chart_next, width: 24, fit: BoxFit.fitWidth),
              ),
              if (!enableButtonNext)
              const SizedBox(width: 24)
            ],
          ),
          const SizedBox(height: 8),
          if (!showDataGraph)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Stack(
                children: [
                  Center(
                  child: CustomLabel(
                    title: typeTransactions == Global.ALL ? 'graph.detail.no_data.all' :
                    (typeTransactions == Global.INCOMES ? 'graph.detail.no_data.income' : 'graph.detail.no_data.expense'),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
                ],
              ),
            ),
          ),
          if (showMonth && showDataGraph)
          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 180,
                  constraints: const BoxConstraints(maxWidth : 800),
                  child: Stack(
                    children: [
                      BarChart(
                        BarChartData(
                          groupsSpace: 20,
                          barTouchData: BarTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              // TODO:
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                              ),
                              vertical: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                          maxY: maxValue.toDouble(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 48,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value < meta.max) {
                                    return Text(CommonUtil.showNumberFormat(value.toInt().toString()));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(listTitleGraph[value.toInt()]);
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.black.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.black.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          barGroups: [
                            ...List.generate(listTitleGraph.length, (groupIndex) =>
                              BarChartGroupData(
                                x: groupIndex,
                                barRods:[
                                  ...List.generate(listLabelGraph.length, (index) =>
                                    BarChartRodData(
                                      toY: listValueGraph[groupIndex][index],
                                      color: labelsColor[index],
                                    )
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!showMonth && showDataGraph)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Stack(
                children: [
                  if (showDataGraph)
                  BarChart(
                    BarChartData(
                      groupsSpace: 20,
                      barTouchData: BarTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // TODO:
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: Colors.black.withOpacity(0.2),
                          ),
                          vertical: BorderSide(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      maxY: maxValue.toDouble(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 48,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(CommonUtil.showNumberFormat(value.toInt().toString()));
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(listTitleGraph[value.toInt()]);
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.black.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.black.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      barGroups: [
                        ...List.generate(listTitleGraph.length, (groupIndex) =>
                          BarChartGroupData(
                            x: groupIndex,
                            barRods: [
                              ...List.generate(listLabelGraph.length, (index) =>
                                BarChartRodData(
                                  toY: listValueGraph[groupIndex][index],
                                  color: labelsColor[index],
                                )
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool checkEnableNext() {
    var today = DateTimeUtil.dateTimeFromString(DateTimeUtil.stringFromDateTimeNow());
    return today.isAfter(DateTimeUtil.dateTimeFromString(endDate));
  }
}

class _GraphChartController extends GetxController {
  static _GraphChartController get instance => Get.find();

  var selectedIndex = 0.obs;
  var showDateRange = ''.obs;

  List<String> listDateTypes = ['week', 'month', 'year'];

  // change type date range
  didSelectedIndex(int index, currentState) {
    selectedIndex.value = index;
    var newStartDate = '';
    var newEndDate = '';
    var selectDateType = listDateTypes[index];
    switch (selectDateType) {
      case 'day':
        newStartDate = currentState['day'];
        newEndDate = currentState['day'];
        break;
      case 'week':
        DateTime dateFormat = DateTimeUtil.dateTimeFromString(currentState['week']);
        newStartDate = DateTimeUtil.stringFromDateTime(dateFormat.subtract(Duration(days: dateFormat.weekday - 1)));
        newEndDate = DateTimeUtil.stringFromDateTime(dateFormat.add(Duration(days: DateTime.daysPerWeek - dateFormat.weekday)));
        break;
      case 'month':
        DateTime dateFormat = DateTimeUtil.dateTimeFromString(currentState['month']);
        int daysInMonth = DateUtils.getDaysInMonth(dateFormat.year, dateFormat.month);
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month, 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month, 1).add(Duration(days: daysInMonth)));
        break;
      case 'year':
        DateTime dateFormat = DateTimeUtil.dateTimeFromString(currentState['year']);
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, 1, 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, 12, 31));
        break;
    }
    changeShowDate(newStartDate, newEndDate);
    return {
      'startDate': newStartDate,
      'endDate': newEndDate
    };
  }

  // action next date
  nextDate(startDate, currentDateChange) {
    DateTime dateFormat = DateTimeUtil.dateTimeFromString(startDate);
    var newStartDate = '';
    var newEndDate = '';
    var selectDateType = listDateTypes[selectedIndex.value];
    switch (selectDateType) {
      case 'day':
        newStartDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: 1)));
        newEndDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: 1)));
        currentDateChange['day'] = newEndDate;
        break;
      case 'week':
        newStartDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: 7)));
        newEndDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: 13)));
        currentDateChange['week'] = newEndDate;
        break;
      case 'month':
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month + 1, 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month + 2, 0));
        currentDateChange['month'] = newStartDate;
        break;
      case 'year':
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year + 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year + 2, 0, 0));
        currentDateChange['year'] = newStartDate;
        break;
    }
    changeShowDate(newStartDate, newEndDate);
    return {
      'startDate': newStartDate,
      'endDate': newEndDate,
      'currentState': currentDateChange
    };
  }

  // action prev date 
  prevDate(startDate, currentDateChange) {
    DateTime dateFormat = DateTimeUtil.dateTimeFromString(startDate);
    var newStartDate = '';
    var newEndDate = '';
    var selectDateType = listDateTypes[selectedIndex.value];
    switch (selectDateType) {
      case 'day':
        newStartDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: -1)));
        newEndDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: -1)));
        currentDateChange['day'] = newEndDate;
        break;
      case 'week':
        newStartDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: -7)));
        newEndDate = DateTimeUtil.stringFromDateTime(dateFormat.add(const Duration(days: -1)));
        currentDateChange['week'] = newEndDate;
        break;
      case 'month':
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month - 1, 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, dateFormat.month, 0));
        currentDateChange['month'] = newStartDate;
        break;
      case 'year':
        newStartDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year - 1));
        newEndDate = DateTimeUtil.stringFromDateTime(DateTime(dateFormat.year, 0, 0));
        currentDateChange['year'] = newStartDate;
        break;
    }
    changeShowDate(newStartDate, newEndDate);
    return {
      'startDate': newStartDate,
      'endDate': newEndDate,
      'currentState': currentDateChange
    };
  }
  
  // change show date by type
  changeShowDate(startDate, endDate) {
    DateTime startDateFormat = DateTimeUtil.dateTimeFromString(startDate);
    DateTime endDateFormat = DateTimeUtil.dateTimeFromString(endDate);
    var selectDateType = listDateTypes[selectedIndex.value];
    switch (selectDateType) {
      case 'day':
        showDateRange.value = DateTimeUtil.stringFromDateTime(startDateFormat, dateFormat: 'yyyy年MM月dd日');
        break;
      case 'week':
        showDateRange.value = '${DateTimeUtil.stringFromDateTime(startDateFormat, dateFormat: 'MM月dd日')}~${DateTimeUtil.stringFromDateTime(endDateFormat, dateFormat: 'MM月dd日')}';
        break;
      case 'month':
        showDateRange.value =  DateTimeUtil.stringFromDateTime(startDateFormat, dateFormat: 'yyyy年MM月');
        break;
      case 'year':
        showDateRange.value =  DateTimeUtil.stringFromDateTime(startDateFormat, dateFormat: 'yyyy年');
        break;
    }
  }
}
