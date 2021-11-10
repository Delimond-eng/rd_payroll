import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/helpers/utilities.dart';
import 'package:medpad/models/user_model.dart';
import 'package:medpad/screens/home_screen.dart';
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/widgets/auth_input_text_widget.dart';
import 'package:page_transition/page_transition.dart';

class AuthenticationPageRoute extends StatefulWidget {
  AuthenticationPageRoute({Key key}) : super(key: key);

  @override
  _AuthenticationPageRouteState createState() =>
      _AuthenticationPageRouteState();
}

class _AuthenticationPageRouteState extends State<AuthenticationPageRoute> {
  @override
  void initState() {
    super.initState();
    DBHelper.registerUser();
  }

  final textEmail = TextEditingController();
  final textPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: _size.height,
            width: _size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
              ),
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 30.0),
                    physics: BouncingScrollPhysics(),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: _size.width / 2.10,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Card(
                            color: Colors.white.withOpacity(.9),
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            shadowColor: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 60.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AuthInputText(
                                    hintText: "Adresse e-mail",
                                    icon: CupertinoIcons.person,
                                    keyType: TextInputType.emailAddress,
                                    isPassWord: false,
                                    inputController: textEmail,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  AuthInputText(
                                    hintText: "Mot de passe",
                                    icon: CupertinoIcons.lock,
                                    keyType: TextInputType.emailAddress,
                                    isPassWord: true,
                                    inputController: textPass,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    height: 60.0,
                                    width: _size.width,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton.icon(
                                      elevation: 10.0,
                                      color: bgColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: login,
                                      icon: Icon(
                                        Icons.arrow_right_alt_rounded,
                                        size: 18.0,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "CONNECTER",
                                        style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -30,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: bgColor,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              shadowColor: Colors.black87,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        "AUTHENTIFICATION",
                                        style: GoogleFonts.mulish(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.50),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    width: 200,
                                    child: FlatButton(
                                      splashColor: Colors.grey[50],
                                      height: 80.0,
                                      color: Colors.grey[100],
                                      onPressed: () async {
                                        //appController.showScan(context);
                                        await DBHelper.getPaymentReporting()
                                            .then((value) {
                                          print(value);
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: Lottie.asset(
                                              "assets/lotties/4771-finger-print.json",
                                              width: 50.0,
                                              height: 50.0,
                                              reverse: true,
                                              fit: BoxFit.cover,
                                              animate: true,
                                            ),
                                          ),
                                          Text(
                                            "SCANNER",
                                            style: GoogleFonts.mulish(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.0,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future<void> login() async {
    if (textEmail.text.isEmpty) {
      Get.snackbar("Avertissement !", "votre adresse email est réquise !",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.redAccent[100],
          backgroundColor: bgColor,
          maxWidth: MediaQuery.of(context).size.width / 2.10,
          borderRadius: 20);
      return;
    } else if (textPass.text.isEmpty) {
      Get.snackbar("Avertissement", "votre mot de passe est réquis!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.redAccent[100],
          backgroundColor: bgColor,
          maxWidth: MediaQuery.of(context).size.width / 2.10,
          borderRadius: 20);
      return;
    }
    User user = User(email: textEmail.text, password: textPass.text);
    try {
      Xloading.showLottieLoading(context);
      DBHelper.loginUser(user: user).then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<User> user =
            List<User>.from(i.map((model) => User.fromMap(model)));
        if (user.isNotEmpty) {
          storage.write("user_id", user[0].userId);
          apiController.loadDatas();
          Future.delayed(Duration(seconds: 1), () {
            storage.write("isLoggedIn", true);
            Xloading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: HomeScreen(), type: PageTransitionType.bottomToTop),
              (route) => false,
            );
          });
        } else {
          Xloading.dismiss();
          XDialog.showErrorMessage(
            context,
            title: "Identifiants incorrects",
            message:
                "Utilisateur inconnu !\nVeuillez essayer de vous identifier avec vos empreintes !",
          );
          return;
        }
      });
    } catch (err) {
      print("failed");
    }
  }

  Future<void> viewUser() async {
    DBHelper.viewUsers().then((value) {
      print(value);
    });
  }
}
