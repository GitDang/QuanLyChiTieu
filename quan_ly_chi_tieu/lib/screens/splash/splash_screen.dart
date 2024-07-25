import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/utils/commons/shared_preference.dart';
import 'package:base_project/utils/databases/database_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openScreen();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showBackButton: false,
      showAppBar: false,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              AppImages.logo_splash,
              width: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
          const Expanded(
            child: CustomLabel(
              title: 'splash.title',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void _openScreen() async {
    bool? firstMoney = await SharedPreferenceUtil.getMoneyFirst();
    DatabaseManager.instance.addAccount(0);
    await SharedPreferenceUtil.saveMoneyFirst(true);
    Get.offAll(() => const HomeScreen(), transition: Transition.fade);
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (firstMoney == true) {
    //     Get.offAll(() => const HomeScreen(), transition: Transition.fade);
    //   } else {
    //     Get.offAll(() => const IntroductionScreen(),
    //         transition: Transition.fade);
    //   }
    // });
  }
}
