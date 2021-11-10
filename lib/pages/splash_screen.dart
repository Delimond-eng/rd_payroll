import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/pages/auth/authenticate_page_route.dart';
import 'package:medpad/screens/home_screen.dart';
import 'package:medpad/services/db_helper_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = storage.read("isLoggedIn");
  Timer _timer;

  @override
  void initState() {
    super.initState();
    loadDataEndGo();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 120,
          width: 120.0,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: SpinKitCubeGrid(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> loadDataEndGo() async {
    DBHelper.initDb();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticationPageRoute(),
        ),
      );
    });
  }
}
