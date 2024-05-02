import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/date_time.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeChart extends StatelessWidget {
  final Function onTapAddTransaction;
  final Function changeDate;
  final int totalMoney;
  final List dataChart;
  final String startDate;
  final String endDate;
  final String typeTransactions;
  final Map currentState;

  HomeChart({
    super.key,
    required this.onTapAddTransaction,
    required this.totalMoney,
    required this.dataChart,
    required this.startDate,
    required this.endDate,
    required this.changeDate,
    required this.typeTransactions,
    required this.currentState,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_HomeChartController())..changeShowDate(startDate, endDate);
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
          CustomTabButtons(
            listButtonTitle: controller.listDateTypes,
            didSelectedIndex: (int index) {
              var dataDate = controller.didSelectedIndex(index, currentState);
              changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), currentState);
            },
            initIndex: controller.selectedIndex.value,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // TODO:
                  Map dataDate = controller.prevDate(startDate, currentState);
                  changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), dataDate['currentState']);
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
                  changeDate(dataDate['startDate'].toString(), dataDate['endDate'].toString(), dataDate['currentState']);
                },
                child: Image.asset(AppImages.ic_chart_next, width: 24, fit: BoxFit.fitWidth),
              ),
              if (!enableButtonNext)
              const SizedBox(width: 24)
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              children: [
                if (dataChart.isNotEmpty)
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // TODO:
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 52,
                    sections: showingSections(),
                  ),
                ),
                if (dataChart.isEmpty)
                Center(
                  child: CustomLabel(
                    title: typeTransactions == Global.INCOMES ? 'home.chart.no_incomes' : 'home.chart.no_expenses',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 6,
                  child: GestureDetector(
                    onTap: () {
                      onTapAddTransaction();
                    },
                    child: Image.asset(AppImages.ic_create, width: 30, fit: BoxFit.fitWidth),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int touchedIndex = -1;

  bool checkEnableNext() {
    var today = DateTimeUtil.dateTimeFromString(DateTimeUtil.stringFromDateTimeNow());
    return today.isAfter(DateTimeUtil.dateTimeFromString(endDate));
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> listPieChartData = [];
    if (dataChart.isNotEmpty) {
      for(var i = 0; i < dataChart.length; i++){
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        
        int percentChart = (dataChart[i].money * 100 / totalMoney).round();
        listPieChartData.add(
          PieChartSectionData(
            color: Color(int.parse(dataChart[i].typeColor)),
            value: percentChart.toDouble(),
            title: '$percentChart%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          )
        );
      }
    } else {
      listPieChartData.add(
        PieChartSectionData(
            color: Colors.blue,
            value: 0,
            title: '0%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          )
      );
    }
    return listPieChartData;
  }
}

class _HomeChartController extends GetxController {
  static _HomeChartController get instance => Get.find();

  var selectedIndex = 0.obs;
  var showDateRange = ''.obs;
  List<String> listDateTypes = ['day', 'week', 'month', 'year'];

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
