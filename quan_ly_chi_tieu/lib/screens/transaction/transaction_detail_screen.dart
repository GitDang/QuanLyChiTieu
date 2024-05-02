import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/utils/commons/common_util.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';

class TransactionDetailScreen extends StatelessWidget {
  final int transactionId;
  final int typeId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
    required this.typeId,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionDetailControlller())..changeTypeCategory(typeId, transactionId);
    return BaseScreen(
      showBackButton: true,
      title: 'transaction.detail',
      keyRoute: 'category',
      child: Column(
        children: [
          SingleChildScrollView(
            child: Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                if(controller.detailTransaction.value.id != 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const CustomLabel(
                      title: 'transaction.money',
                      customTextStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomLabel(
                      title: CommonUtil.moneyFormat(controller.detailTransaction.value.money.toString()),
                      customTextStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomLabel(
                      title: 'transaction.category',
                      customTextStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CategoryIcon(
                          width: 38,
                          imageWidth: 30,
                          imageName: controller.detailTransaction.value.typeIcon,
                          color: Color(int.parse(controller.detailTransaction.value.typeColor)),
                        ),
                        const SizedBox(width: 10,),
                        CustomLabel(title: controller.detailTransaction.value.typeName)
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CustomLabel(
                      title: 'transaction.date',
                      customTextStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomLabel(
                      title: controller.detailTransaction.value.date,
                      customTextStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomLabel(
                      title: 'transaction.comment',
                      customTextStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomLabel(
                      title: controller.detailTransaction.value.note,
                      customTextStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                     GestureDetector(
                        onTap: () {
                          controller.showAlertDialog(context);
                        },
                        child: const CustomLabel(
                          title: 'transaction.delete',
                          customTextStyle: TextStyle(color: ffFF0505),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                )
              ],
            )
          )),
        ],
      ),
    );
  }
}

class TransactionDetailControlller extends GetxController {
  static TransactionDetailControlller get instance => Get.find();
  var detailTransaction = TransactionsModel(id: 0, typeId: 0, money: 0).obs;
  var typeCategory = 0.obs;

  var typeTransactions = ''.obs;

  void changeTypeCategory(int type, int transactionId) async {
    typeCategory.value = type;
    if (type == 0) {
      typeTransactions.value = Global.INCOMES;
    } else {
      typeTransactions.value = Global.EXPENSES;
    }
    getDetailTransaction(transactionId);
  }

  getDetailTransaction(transactionId) async {
    if (typeTransactions.value == Global.INCOMES) {
      detailTransaction.value = await DatabaseManager.instance.getIncomeById(transactionId);
    } else {
      detailTransaction.value = await DatabaseManager.instance.getExpenseById(transactionId);
    }
  }

  deleteTransaction() async {
    int newMoney = Global.accountModel.money;
    if (typeTransactions.value == Global.INCOMES) {
      await DatabaseManager.instance.deleteIncomeById(detailTransaction.value.id);
      newMoney = newMoney - detailTransaction.value.money;
    } else {
      await DatabaseManager.instance.deleteExpenseById(detailTransaction.value.id);
      newMoney = newMoney + detailTransaction.value.money;
    }
    // update new money
    DatabaseManager.instance.updateAccount(newMoney);
    Global.accountModel.money = newMoney;
    Get.to(() => const HomeScreen());
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.all(0),
      actions: [
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
            await deleteTransaction();
          },
        ),
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
        )
      ],
      content: const SizedBox(
        height: 25,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: CustomLabel(
                title: 'transaction.delete_confirm',
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
