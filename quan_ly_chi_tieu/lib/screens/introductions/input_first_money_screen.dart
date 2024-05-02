import 'package:base_project/utils/databases/database_manager.dart';
import 'package:base_project/utils/commons/shared_preference.dart';
import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/common_util.dart';

class InputFirstMoneyScreen extends StatelessWidget {
  const InputFirstMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InputMoneyFirstController());
    var screenSize = MediaQuery.of(context).size;
    var paddingTop = MediaQuery.of(context).padding.top;
    return BaseScreen(
      showAppBar: false,
      child: Column(
        children: [
          SizedBox(height: 50 + paddingTop),
          const CustomLabel(title: 'input_money.input_amount', fontSize: 20, fontWeight: FontWeight.w700),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 100, right: 50),
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
                  )
                ),
                const SizedBox(width: 10),
                const CustomLabel(
                  title: 'JPY',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomButton(
            title: 'input_money.to_next',
            width: screenSize.width / 2,
            onTap: () {
              controller.validation(context);
            },
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}

class InputMoneyFirstController extends GetxController {
  static InputMoneyFirstController get instance => Get.find();

  final TextEditingController moneyTextController = TextEditingController(text: '');

  void validation(BuildContext context) async {
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
    DatabaseManager.instance.addAccount(inputMoney);

    await SharedPreferenceUtil.saveMoneyFirst(true);

    // ignore: use_build_context_synchronously
    _requestInputMoney(context);
  }

  void _requestInputMoney(BuildContext context) async {
    Get.to(() => const HomeScreen());
  }
}
