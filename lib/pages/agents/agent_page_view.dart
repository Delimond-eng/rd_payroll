// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/utilities.dart';
import 'package:medpad/models/sync_data_model.dart';

import 'package:medpad/services/db_helper_service.dart';
import 'package:signature/signature.dart';

import 'widgets/finger_control_widget.dart';
import 'widgets/user_field_widget.dart';

class AgentPageView extends StatefulWidget {
  final Paiements data;
  final String beneficiaireId;
  const AgentPageView({Key key, this.data, this.beneficiaireId})
      : super(key: key);
  @override
  _AgentPageViewState createState() => _AgentPageViewState();
}

class _AgentPageViewState extends State<AgentPageView>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  TabController controller;

  //var image picker
  PickedFile _imageFile1;
  PickedFile _imageFile2;
  final ImagePicker _picker = ImagePicker();

  String photo = "";
  String strSignature = "";
  Uint8List numericSignature;

  //finger variables
  String b64F01 = "";
  String b64F02 = "";
  String b64F03 = "";

  //fingers to send from database
  String strFinger1 = "";
  String strFinger2 = "";
  String strFinger3 = "";

  SignatureController signatureController;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.blue[900],
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
    signatureController.dispose();
  }

  void finish() async {
    List<String> fingers = [
      b64F01,
      b64F02,
      b64F03,
    ];
    for (int i = 0; i < fingers.length; i++) {
      if (fingers[i].isEmpty || fingers[i] == null) {
        XDialog.showErrorMessage(context,
            title: "Enrollement obligatoire",
            message:
                "vous devez enroller au moins trois empreintes de l'agent !");
        return;
      }
    }

    if (strSignature.isEmpty) {
      XDialog.showErrorMessage(context,
          title: "Capture obligatoire",
          message: "vous devez capturer la signature du client !");
      return;
    }

    try {
      Xloading.showLottieLoading(context);

      Empreintes empreinte = Empreintes(
        empreinte1: strFinger1,
        empreinte2: strFinger2,
        empreinte3: strFinger3,
      );
      await DBHelper.enregistrerEmpreintes(
        empreinte: empreinte,
        paiement: widget.data,
        id: widget.beneficiaireId,
      ).then((value) {
        Xloading.dismiss();
        if (value != null) {
          apiController.loadDatas();
          clearInput();
          XDialog.showSuccessAnimation(context);
        }
      }).catchError((error) {
        Xloading.dismiss();
        print("send data error from agent registering $error");
      });
    } catch (err) {
      print("send data error from agent registering $err");
      Xloading.dismiss();
      XDialog.showErrorMessage(context, title: "Echec", message: "$err!");
    }
  }

  Future<void> clearInput() async {
    setState(() {
      b64F01 = "";
      b64F02 = "";
      b64F03 = "";

      strFinger1 = "";
      strFinger2 = "";
      strFinger3 = "";

      _imageFile1 = null;
      _imageFile2 = null;
      numericSignature = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text("Enregistrement de données biométriques"),
      ),
      body: Container(
        decoration: BoxDecoration(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  height: 70.0,
                  decoration: BoxDecoration(color: bgColor.withOpacity(.5)),
                  child: TabBar(
                    controller: controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 60.0,
                      indicatorColor: Colors.cyan[500],
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorRadius: 30,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    labelStyle: GoogleFonts.mulish(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: GoogleFonts.mulish(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    tabs: [
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.person),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text("Informations sur l'agent bénéficiaire"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.fingerprint_rounded),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text("Enrollement empreintes & signatures"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: [
                        identity(),
                        fingersEndSignEnroll(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget identity() {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: FieldRead(
                    headingTitle: "Nom & Post Nom",
                    value: "${widget.data.nom}",
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: FieldRead(
                    headingTitle: "Matricule",
                    value: "${widget.data.matricule}",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Flexible(
                  child: FieldRead(
                    headingTitle: "Sexe",
                    value: "${widget.data.sexe}",
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: FieldRead(
                    headingTitle: "Etat civil",
                    value: "${widget.data.etatCivil}",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget fingersEndSignEnroll() {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fingerprint),
                SizedBox(width: 8.0),
                Text(
                  "Enrollement empreintes digitales".toUpperCase(),
                  style: GoogleFonts.mulish(
                      fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FingerControl(
                  onEnrollSuccess: () {
                    setState(() {
                      b64F01 = "";
                    });
                    appController.showEnrollBoxModal(context, onSuccess: () {
                      setState(() {
                        b64F01 = appController.currentEnrollFingerImage.value;
                        strFinger1 = appController.currentFingerTemplate.value;
                      });
                    });
                  },
                  strFingerImage: b64F01,
                  number: 1,
                ),
                FingerControl(
                  onEnrollSuccess: () {
                    setState(() {
                      b64F02 = "";
                    });
                    appController.showEnrollBoxModal(context, onSuccess: () {
                      setState(() {
                        b64F02 = appController.currentEnrollFingerImage.value;
                        strFinger2 = appController.currentFingerTemplate.value;
                      });
                    });
                  },
                  strFingerImage: b64F02,
                  number: 2,
                ),
                FingerControl(
                  onEnrollSuccess: () {
                    setState(() {
                      b64F03 = "";
                    });
                    appController.showEnrollBoxModal(context, onSuccess: () {
                      setState(() {
                        b64F03 = appController.currentEnrollFingerImage.value;
                        strFinger3 = appController.currentFingerTemplate.value;
                      });
                    });
                  },
                  strFingerImage: b64F03,
                  number: 3,
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                agentCaptureBox(),
                Row(
                  children: [
                    signCaptures(),
                    SizedBox(
                      width: 30.0,
                    ),
                    signPadContainer(),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                      onPressed: finish,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      icon: Icon(
                        Icons.check,
                        color: light,
                      ),
                      color: bgColor,
                      elevation: 10.0,
                      label: Text(
                        "Enregister".toUpperCase(),
                        style: GoogleFonts.mulish(color: light),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Flexible(
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        setState(() {
                          controller.index = 1;
                          b64F01 = "";
                          b64F02 = "";
                          b64F03 = "";

                          strFinger1 = "";
                          strFinger2 = "";
                          strFinger3 = "";

                          _imageFile1 = null;
                          _imageFile2 = null;
                          numericSignature = null;
                        });
                      },
                      icon: Icon(
                        Icons.circle_outlined,
                        color: light,
                      ),
                      color: Colors.grey[700],
                      label: Text(
                        "Annuler".toUpperCase(),
                        style: GoogleFonts.mulish(color: light),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column signCaptures() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.photo_camera),
            SizedBox(width: 8.0),
            Text(
              "Signature capture".toUpperCase(),
              style: GoogleFonts.mulish(
                  fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: 250.0,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: bgColor, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.black45,
                child: Material(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _imageFile2 = null;
                      });
                      takePhoto(ImageSource.camera, 2);
                    },
                    child: Container(
                      decoration: _imageFile2 != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(_imageFile2.path)),
                                  fit: BoxFit.cover),
                            )
                          : null,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Icon(Icons.add_a_photo_outlined,
                              size: 30.0,
                              color:
                                  _imageFile2 != null ? Colors.white : bgColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column agentCaptureBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.photo_camera_solid,
            ),
            SizedBox(width: 8.0),
            Text(
              "Capture photo agent".toUpperCase(),
              style: GoogleFonts.mulish(
                  fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: 250.0,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: bgColor, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.black45,
                child: Material(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _imageFile1 = null;
                      });
                      takePhoto(ImageSource.camera, 1);
                    },
                    child: Container(
                      decoration: _imageFile1 != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                    File(_imageFile1.path),
                                  ),
                                  fit: BoxFit.cover),
                            )
                          : null,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 30.0,
                            color: _imageFile1 != null ? Colors.white : bgColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget signPadContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.pencil_outline),
            SizedBox(width: 8.0),
            Text(
              "Signature numerique".toUpperCase(),
              style: GoogleFonts.mulish(
                  fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              numericSignature = null;
            });
            Modal.show(
              context,
              title:
                  "Veuillez utiliser un stylo numérique ou un doit pour signer !",
              height: 400.0,
              modalContent: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Signature(
                        controller: signatureController,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          if (signatureController.isNotEmpty) {
                            var signature = await exportSignature();
                            String b64Signature = base64Encode(signature);
                            setState(() {
                              strSignature = b64Signature;
                              numericSignature = signature;
                            });
                            if (signature != null) {
                              Get.back();
                            }
                          }
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        color: Colors.green[700],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RaisedButton(
                        color: Colors.pinkAccent,
                        onPressed: () {
                          signatureController.clear();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          child: Container(
            height: 250,
            width: 250,
            decoration: (numericSignature == null)
                ? BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: bgColor, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                  )
                : BoxDecoration(
                    border: Border.all(color: bgColor, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                    image: DecorationImage(
                      image: MemoryImage(numericSignature),
                      fit: BoxFit.fill,
                    ),
                  ),
            child: Center(
              child: Icon(
                CupertinoIcons.pencil_outline,
                size: 30.0,
                color: bgColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: signatureController.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature;
  }

  void takePhoto(ImageSource source, int imageNumber) async {
    final pickedFile = await _picker.getImage(
        source: source, maxHeight: 200, maxWidth: 200, imageQuality: 50);

    switch (imageNumber) {
      case 1:
        var bytes = File(pickedFile.path).readAsBytesSync();
        setState(() {
          _imageFile1 = pickedFile;
          photo = base64Encode(bytes);
        });
        break;
      case 2:
        var bytes = File(pickedFile.path).readAsBytesSync();
        setState(() {
          _imageFile2 = pickedFile;
          strSignature = base64Encode(bytes);
        });
        break;
    }
  }
}
