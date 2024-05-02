import 'package:base_project/screens/base_screen.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return BaseScreen(
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
            child: Column(
              children: [
                CustomLabel(
                  title: 'introduction.welcome',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                CustomLabel(
                  title: 'introduction.expense_management',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          CustomButton(
            title: 'introduction.start',
            width: screenSize.width / 2,
            onTap: () {
              Get.to(() => const InputFirstMoneyScreen());
            },
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}
