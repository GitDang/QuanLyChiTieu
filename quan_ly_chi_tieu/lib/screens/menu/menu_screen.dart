import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/shared_preference.dart';
import 'package:base_project/utils/databases/database_manager.dart';

class MenuScreen extends StatelessWidget {
  final String keyRoute;
  const MenuScreen({super.key, required this.keyRoute});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MenuController());
    var listMenu = [
      MenuModel('home', 'menu.home', AppImages.ic_menu_home),
      MenuModel('category', 'menu.category', AppImages.ic_menu_cate),
      MenuModel('graph', 'menu.graph', AppImages.ic_menu_graph),
    ];
    return BaseScreen(
      showAppBar: false,
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 75),
          for(var menuItem in listMenu)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              controller.changeToScreen(menuItem.key);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: keyRoute == menuItem.key ? ffFFE67C : ffF5F5F5
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Image.asset(menuItem.icon, width: 20, fit: BoxFit.fitWidth),
                    const SizedBox(width: 15),
                    CustomLabel(
                      title: menuItem.title,
                      customTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.showAlertDialog(context);
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ffF5F5F5
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Image.asset(AppImages.ic_reset_app, width: 20, fit: BoxFit.fitWidth),
                    const SizedBox(width: 15),
                    const CustomLabel(
                      title: 'menu.reset',
                      customTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
class _MenuController extends GetxController {
  static _MenuController get instance => Get.find();

  void changeToScreen(String key) {
    switch(key) {
      case 'home':
        Get.to(() => const HomeScreen());
        break;
      case 'category':
        Get.to(() => const CategoryScreen(type: 0));
        break;
      case 'graph':
        Get.to(() => const GraphScreen());
        break;
    }
  }
  resetApp() async {
    await SharedPreferenceUtil.saveMoneyFirst(false);
    DatabaseManager.instance.resetApp();
    Get.to(() => const SplashScreen());
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
            await resetApp();
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
                title: 'menu.reset_confirm',
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

class MenuModel {
  final String key;
  final String title;
  final String icon;

  MenuModel(this.key, this.title, this.icon);
}