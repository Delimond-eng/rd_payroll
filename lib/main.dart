import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/controllers/api_controller.dart';
import 'package:medpad/controllers/app_controller.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medpad/pages/splash_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants/style.dart';
import 'controllers/api_sync_controller.dart';
import 'services/db_helper_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  configLoading();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  Get.put(ApiController());
  Get.put(ApiSyncController());
  Get.put(AppController());
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 50.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

//EasyLoading.show(status: "ajout en cours...");
//EasyLoading.dismiss();

Future<void> checkDevice() async {
  var device = storage.read("device_id");
  if (device == null || device == "") {
    //await ApiManagerService.checkDevice();
  }
}

Future<void> grantedPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.mediaLibrary,
    Permission.manageExternalStorage,
  ].request();

  print(statuses[Permission.speech]);
}

Stream<int> startTasks(Duration interval) async* {
  final PackageInfo info = await PackageInfo.fromPlatform();
  int version = int.parse(info.buildNumber);
  // ignore: close_sinks
  var controller = StreamController<int>();
  int appVersion = version;
  void tick(Timer timer) {
    controller.add(appVersion); // Ask stream to send counter values as event.
  }

  Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  yield* controller.stream;
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      defaultTransition: Transition.fade,
      popGesture: Get.isPopGestureEnable,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('fr'), // French
      ],
      title: "medPad",
      theme: ThemeData(
              scaffoldBackgroundColor: light,
              textTheme: GoogleFonts.mulishTextTheme(Theme.of(context)
                      .textTheme
                      .apply(bodyColor: Colors.black)) ??
                  Theme.of(context).textTheme.apply(bodyColor: Colors.black),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
              }),
              primaryColor: Colors.cyan)
          .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
