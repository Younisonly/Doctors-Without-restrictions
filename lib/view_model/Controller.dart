import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';
import 'screens_view_model.dart';
import '../widgets/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class ControlView extends GetWidget<Auth> {
   ControlView(){
    Get.put(Auth(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ScreenViewModel>(
          init: ScreenViewModel(),
          builder: (controller) =>
          Scaffold(
          body: controller.currentScreen,
          bottomNavigationBar: bottomNavigationBar(),
          )

      );
  }

  Widget bottomNavigationBar() {
    return GetBuilder<ScreenViewModel>(
      init: ScreenViewModel(),
      builder: (controller) => BottomNavigationBar(
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: "اطباء",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: "المحادثات",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarCheck),
              label: "المواعيد",
            ),
          ],
          currentIndex: controller.navigatorValue,
          onTap: (index) {
            controller.changeSelectedValue(index);
          }),
    );
  }
}
