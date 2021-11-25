import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/services/native_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  // ignore: deprecated_member_use
  var singlePatientDocList = List<String>().obs;

  var strPlainte = "".obs;
  var strDateDoc = "".obs;
  var medAuthorizationAllowed = false.obs;

  var userFoundInfo = List<String>().obs;

  //finger enroll var
  var currentEnrollFingerImage = "".obs;
  var currentFingerTemplate = "".obs;
  var devise = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> openUsbDevice() async {
    try {
      await NativeService.platform.invokeMethod("open_usb_device");
    } catch (err) {
      print(err);
    }
  }

  Future<void> closeUsbDevice() async {
    try {
      await NativeService.platform.invokeMethod("close_usb_device");
    } catch (err) {
      print(err);
    }
  }

  var btnController = RoundedLoadingButtonController().obs;
  var isActive = false.obs;
  var isFounded = false.obs;

  Future<dynamic> showScan(BuildContext context,
      {Function onSuccess, Function onFailed}) async {
    openUsbDevice();
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black38,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              insetPadding: EdgeInsets.symmetric(horizontal: 50.0),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Obx(
                () => Container(
                  width: 150,
                  child: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30.0),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Stack(
                                  // ignore: deprecated_member_use
                                  overflow: Overflow.visible,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      child: Center(
                                        child: (isActive.value == true)
                                            ? Container(
                                                padding: EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: Lottie.asset(
                                                  "assets/lotties/4771-finger-print.json",
                                                  width: 150.0,
                                                  height: 150.0,
                                                  fit: BoxFit.cover,
                                                  animate: true,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: Lottie.asset(
                                                  "assets/lotties/4771-finger-print.json",
                                                  width: 150.0,
                                                  height: 150.0,
                                                  reverse: true,
                                                  fit: BoxFit.cover,
                                                  animate: true,
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: 200.0,
                                  height: 50,
                                  child: RoundedLoadingButton(
                                    loaderSize: 25.0,
                                    loaderStrokeWidth: 2,
                                    onPressed: () async {
                                      String fingerId = "";
                                      btnController.value.start();
                                      isActive.value = true;
                                      try {
                                        await DBHelper.getAllFingers()
                                            .then((value) async {
                                          var json = jsonEncode(value);

                                          fingerId = await NativeService
                                              .platform
                                              .invokeMethod(
                                                  "match_fingers", json);
                                          if (fingerId.isNotEmpty) {
                                            btnController.value.stop();
                                            await apiController
                                                .findClientByFingerId(
                                                    fingerId: fingerId)
                                                .then((value) {
                                              if (value == "success") {
                                                Get.back();
                                                onSuccess();
                                                appController.closeUsbDevice();
                                              }
                                            });
                                          } else {
                                            Get.back();
                                            btnController.value.stop();
                                            appController.closeUsbDevice();
                                            onFailed();
                                          }
                                        });
                                      } catch (err) {
                                        btnController.value.stop();
                                        print(err);
                                      }
                                    },
                                    elevation: 10,
                                    color: bgColor,
                                    curve: Curves.easeIn,
                                    controller: btnController.value,
                                    child: Text(
                                      "scanner empreinte".toUpperCase(),
                                      style: GoogleFonts.mulish(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -25,
                        right: -3,
                        child: Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.clear,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                Get.back();
                                closeUsbDevice();
                              },
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
        );
      },
    );
  }

  Future<dynamic> showEnrollBoxModal(BuildContext context,
      {Function onSuccess}) async {
    openUsbDevice();

    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black38,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              insetPadding: EdgeInsets.symmetric(horizontal: 50.0),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Obx(
                () => Container(
                  width: 150,
                  child: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30.0),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Stack(
                                  // ignore: deprecated_member_use
                                  overflow: Overflow.visible,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      child: Center(
                                        child: (isActive.value == true)
                                            ? Container(
                                                padding: EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: Lottie.asset(
                                                  "assets/lotties/4771-finger-print.json",
                                                  width: 150.0,
                                                  height: 150.0,
                                                  fit: BoxFit.cover,
                                                  animate: true,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: Lottie.asset(
                                                  "assets/lotties/4771-finger-print.json",
                                                  width: 150.0,
                                                  height: 150.0,
                                                  reverse: true,
                                                  fit: BoxFit.cover,
                                                  animate: true,
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: 200.0,
                                  height: 50,
                                  child: RoundedLoadingButton(
                                    loaderSize: 25.0,
                                    loaderStrokeWidth: 2,
                                    onPressed: () async {
                                      btnController.value.start();
                                      try {
                                        List<dynamic> list = <dynamic>[];

                                        list = await NativeService.platform
                                            .invokeMethod("get_image");
                                        Uint8List data =
                                            Uint8List.fromList(list[0]);
                                        String strTemplate =
                                            convertToBase64Bytes(list[1]);
                                        String strB64 =
                                            convertToBase64Bytes(data);
                                        if (strB64.isNotEmpty ||
                                            strB64 != null) {
                                          btnController.value.success();
                                          Get.back();
                                          currentEnrollFingerImage.value =
                                              strB64;
                                          currentFingerTemplate.value =
                                              strTemplate;
                                          closeUsbDevice();
                                          onSuccess();
                                        } else {
                                          btnController.value.stop();
                                        }
                                      } catch (err) {
                                        print(err);
                                      }
                                    },
                                    elevation: 10,
                                    color: bgColor,
                                    curve: Curves.easeIn,
                                    controller: btnController.value,
                                    child: Text(
                                      "Enroller empreinte".toUpperCase(),
                                      style: GoogleFonts.mulish(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -25,
                        right: -3,
                        child: Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.clear,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                Get.back();
                                closeUsbDevice();
                              },
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
        );
      },
    );
  }
}
