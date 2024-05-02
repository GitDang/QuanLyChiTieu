import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/utils/commons/common_util.dart';

class TransactionCell extends StatelessWidget {
  const TransactionCell({
    super.key,
    required this.dataShow,
    required this.totalMoney,
    this.textStyle = const TextStyle(fontSize: 20),
  });
  final TransactionsByCategoryModel dataShow;
  final int totalMoney;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ff606060,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CategoryIcon(
            width: 38,
            imageWidth: 30,
            imageName: dataShow.typeIcon,
            color: Color(int.parse(dataShow.typeColor)),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: CustomLabel(
              title: dataShow.typeName,
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
              customTextStyle: textStyle,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 4,
            child: CustomLabel(
              title: '${(dataShow.money * 100 / totalMoney).round()}%',
              fontSize: 20,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 8,
            child: CustomLabel(
              title: CommonUtil.moneyFormat(dataShow.money.toString()),
              fontSize: 20,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
