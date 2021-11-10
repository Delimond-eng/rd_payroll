import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/style.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Xloading {
  static dismiss() {
    Get.back();
  }

  static showLottieLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 180),
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 100,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: SpinKitFadingCircle(
                        color: Colors.blue[800],
                        size: 80.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static show(context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor.withOpacity(.8),
          content: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              if (title.isNotEmpty)
                SizedBox(
                  width: 10,
                ),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 10), () {
      Get.back();
    });
  }
}

//attribution_sharp

class XDialog {
  static show(
      {BuildContext context,
      title,
      content,
      Function onValidate,
      Function onCancel,
      IconData icon}) {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text(
        "Annuler".toUpperCase(),
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.0,
            color: Colors.red[500]),
      ),
      onPressed: onCancel ?? () => Get.back(),
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text(
        "Valider".toUpperCase(),
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.0,
            color: Colors.green[700]),
      ),
      onPressed: () {
        Get.back();
        Future.delayed(Duration(microseconds: 500));
        onValidate();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber[800]),
          SizedBox(
            width: 5,
          ),
          Text("$title"),
        ],
      ),
      content: Text("$content"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showConfirmation(
      {BuildContext context,
      title,
      content,
      Function onCancel,
      IconData icon}) {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      minWidth: MediaQuery.of(context).size.width / 2.60,
      child: Text(
        "OK",
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.0,
            color: Colors.red[400]),
      ),
      onPressed: onCancel ?? () => Get.back(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            (icon == null) ? Icons.help_rounded : icon,
            color: Colors.amber[900],
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            width: 8,
          ),
          Text("$title"),
        ],
      ),
      content: Text("$content"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSuccessMessage(context, {title, message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$title",
                style: GoogleFonts.mulish(color: Colors.white),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
  }

  static showSuccessAnimation(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 8,
          contentPadding: EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            width: 200.0,
            height: 200.0,
            child: Lottie.asset("assets/lotties/17828-success.json",
                width: 150.0,
                height: 150.0,
                alignment: Alignment.center,
                animate: true,
                repeat: false,
                fit: BoxFit.cover),
          )),
        );
      },
    );

    Future.delayed(Duration(seconds: 3), () {
      Get.back();
    });
  }

  static showErrorAnimation(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          content: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            width: 200.0,
            height: 200.0,
            child: Lottie.asset("assets/lotties/32889-error-message.json",
                width: 150.0,
                height: 150.0,
                alignment: Alignment.center,
                animate: true,
                repeat: false,
                fit: BoxFit.cover),
          )),
        );
      },
    );

    Future.delayed(Duration(seconds: 3), () {
      Get.back();
    });
  }

  static showErrorMessage(context, {title, message, color}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color ?? Colors.red[300],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$title",
                style: GoogleFonts.mulish(color: Colors.white),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
  }
}

class Modal {
  static void show(context,
      {String title,
      Widget modalContent,
      double height,
      double width,
      IconData icon}) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white12,
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: height,
                      width: (width == null)
                          ? MediaQuery.of(context).size.width - 50
                          : width,
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, left: 10, right: 10, bottom: 5),
                              child: modalContent),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: darker,
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        icon == null
                                            ? CupertinoIcons.pencil_outline
                                            : icon,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        title,
                                        style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class XEncrypt {
  static String hash(String data) {
    return "";
  }

  static String deHash(data) {
    return hash(data);
  }

  static final key = Key;
}

Future<File> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory()).path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  return file;
}
