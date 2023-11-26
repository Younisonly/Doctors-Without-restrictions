import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:medical_care_app/view_model/Controller.dart';
import 'package:medical_care_app/view_model/auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';
// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true
  );
  await initializeDateFormatting('ar_SA');

  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
Get.put(Auth());
    if (Get.find<Auth>().user != null){
      onUserLogin();
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: widget.navigatorKey,
        textDirection: TextDirection.rtl,
        debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: GetBuilder<Auth>(
            init: Get.put(Auth()),
            builder: (value) => ControlView(),
          )));
  }

  void onUserLogin() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1109622907, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: '55a2dc4241f7b4b5a79c0671f1d0b980cf38f4aee2feee45791e410f3d8393c8', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: user?.uid as String,
      userName: user?.email as String,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
