import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/pages/auth/authenticate_page_route.dart';
import 'package:medpad/services/db_helper_service.dart';

import 'package:medpad/widgets/page_title.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //bool isLoggedIn = storage.read("isLoggedIn");

  @override
  void initState() {
    super.initState();
    loadDataEndGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200.0,
          width: 300.0,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.black.withOpacity(.3),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageTitle(
                  fontSize: 35.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                SpinKitThreeBounce(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadDataEndGo() async {
    new Timer(Duration(seconds: 5), () {
      DBHelper.initDb();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticationPageRoute(),
        ),
      );
    });
  }
}
