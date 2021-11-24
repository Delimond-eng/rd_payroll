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
import 'package:medpad/models/beneficiaires_model.dart';
import 'package:medpad/models/sync_data_model.dart';
import 'package:medpad/screens/agence_view_screen.dart';
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/widgets/auth_input_text_widget.dart';
import 'package:medpad/widgets/page_title.dart';
import 'package:page_transition/page_transition.dart';

class AuthenticationPageRoute extends StatefulWidget {
  AuthenticationPageRoute({Key key}) : super(key: key);

  @override
  _AuthenticationPageRouteState createState() =>
      _AuthenticationPageRouteState();
}

class _AuthenticationPageRouteState extends State<AuthenticationPageRoute> {
  final textEmail = TextEditingController();
  final textPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: Container(
          height: _size.height,
          width: _size.width,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white.withOpacity(.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: SafeArea(
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
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            child: Card(
                              color: Colors.white.withOpacity(.9),
                              elevation: 20.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              shadowColor: Colors.black,
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
                                color: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                shadowColor: Colors.black.withOpacity(.4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: PageTitle(
                                          fontSize: 30.0,
                                        ),
                                      ),
                                    ),
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
              ),
            ),
          )),
    );
  }

  Future<void> login() async {
    if (textEmail.text.isEmpty) {
      Get.snackbar("Avertissement !", "votre adresse email est réquise !",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.redAccent[100],
          backgroundColor: bgColor,
          maxWidth: MediaQuery.of(context).size.width / 1.50,
          borderRadius: 0);
      return;
    } else if (textPass.text.isEmpty) {
      Get.snackbar("Avertissement", "votre mot de passe est réquis!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.redAccent[100],
          backgroundColor: bgColor,
          maxWidth: MediaQuery.of(context).size.width / 1.50,
          borderRadius: 0);
      return;
    }
    Agents user = Agents(
        email: textEmail.text, telephone: textEmail.text, pass: textPass.text);
    try {
      Xloading.showLottieLoading(context);

      DBHelper.viewDatas(tableName: "agents").then((res) {
        print(res);
      });

      DBHelper.loginUser(user: user).then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<Agents> user =
            List<Agents>.from(i.map((model) => Agents.fromJson(model)));
        if (user.isNotEmpty) {
          storage.write("agent_id", user[0].agentId);
          apiController.agent.value = user[0];
          Future.delayed(Duration(seconds: 1), () {
            Xloading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: AgenceViewScreen(),
                  type: PageTransitionType.bottomToTop),
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
      Xloading.dismiss();
      print("failed");
    }
  }
}
