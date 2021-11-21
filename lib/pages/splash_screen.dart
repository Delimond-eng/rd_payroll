import 'dart:async';

import 'package:flutter/material.dart';
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
          height: 100.0,
          width: 150.0,
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.blue[900],
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
            child: PageTitle(),
          ),
        ),
      ),
    );
  }

  Future<void> loadDataEndGo() async {
    await DBHelper.initDb();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthenticationPageRoute(),
      ),
    );
  }
}
