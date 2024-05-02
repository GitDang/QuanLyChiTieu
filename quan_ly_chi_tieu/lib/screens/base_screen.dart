export 'package:flutter/material.dart';
export 'package:get/get.dart';

export 'screens.dart';
export 'widgets/widgets.dart';
export '../resources/app_images.dart';
export '../resources/colors.dart';
export '../resources/messages.dart';

export '../models/models.dart';

import 'package:flutter/material.dart';
import 'package:base_project/screens/widgets/widgets.dart';
import 'screens.dart';

class BaseScreen extends StatelessWidget {
  final bool showAppBar;
  final bool showBackButton;
  final bool showMenuButton;
  final String title;
  final bool isTitleLocale;
  final Function? onTapBack;
  final String? appBarIconName;
  final double? appBarIconWidth;
  final String? backgroundImage;
  final EdgeInsets padding;
  final Widget child;
  final Function? onTapAfterBack;
  final String keyRoute;
  final bool showTopRight;
  final Function? onTapTopRight;


  const BaseScreen({
    super.key,
    this.showAppBar = true,
    this.showBackButton = true,
    this.showMenuButton = false,
    this.title = '',
    this.isTitleLocale = true,
    this.onTapBack,
    this.appBarIconName,
    this.appBarIconWidth,
    this.backgroundImage,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    required this.child,
    this.onTapAfterBack,
    this.keyRoute = 'home',
    this.showTopRight = false,
    this.onTapTopRight,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.white,
          endDrawer: showMenuButton
              ? SizedBox(
                  width: screenSize.width * 1 / 2,
                  child: Drawer(
                    child: MenuScreen(keyRoute: keyRoute,),
                  ),
                )
              : null,
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  showAppBar
                      ? CustomAppBar(
                          showBackButton: showBackButton,
                          showMenuButton: showMenuButton,
                          showTopRight: showTopRight,
                          title: title,
                          isLocale: isTitleLocale,
                          onTapBack: onTapBack,
                          onTapAfterBack: onTapAfterBack,
                          onTapMenu: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          iconName: appBarIconName,
                          iconWidth: appBarIconWidth,
                          onTapTopRight: onTapTopRight,
                        )
                      : const SizedBox(),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: padding,
                      decoration: (backgroundImage == null)
                          ? null
                          : BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(backgroundImage ?? ''),
                                fit: BoxFit.fill,
                              ),
                            ),
                      child: child,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
