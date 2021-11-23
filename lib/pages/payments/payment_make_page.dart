// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/utilities.dart';
import 'package:medpad/models/beneficiaires_model.dart';
import 'package:medpad/models/pay_model.dart';
import 'package:medpad/pages/agents/widgets/user_field_widget.dart';
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/widgets/user_session.dart';

class PaymentFoundPage extends StatefulWidget {
  @override
  _PaymentFoundPageState createState() => _PaymentFoundPageState();
}

class _PaymentFoundPageState extends State<PaymentFoundPage> {
  String preuve1 = "";
  String preuve2 = "";
  String preuve3 = "";
  String preuve4 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment agent"),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [UserBox()],
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
                colors: [Colors.transparent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 20.0, right: 10.0, left: 10.0, bottom: 20.0),
                physics: BouncingScrollPhysics(),
                child: Obx(() {
                  return Column(
                    children: [
                      Container(
                        height: 40.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(.9),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.person,
                                color: Colors.white, size: 15.0),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("Agent informations",
                                style: GoogleFonts.lato(color: Colors.white)),
                          ],
                        ),
                      ),
                      userInfos(context),
                      payInfos(context),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 270.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.4),
                              blurRadius: 12.0,
                              offset: const Offset(0, 3),
                            )
                          ],
                          color: Colors.white.withOpacity(.4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.0,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(.9),
                              ),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.photo_fill,
                                      color: Colors.white, size: 15.0),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text("Preuves de paiements",
                                      style: GoogleFonts.lato(
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Scrollbar(
                                  thickness: 5,
                                  radius: Radius.circular(10.0),
                                  child: GridView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.10,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    children: [
                                      StatefulBuilder(
                                        builder: (context, setter) =>
                                            CaptureTile(
                                          title:
                                              "Preuve de la carte d'identité",
                                          tileHeaderColor: Colors.red[400],
                                          onCaptured: () async {
                                            var byteImage = await takePhoto();
                                            var i =
                                                await byteImage.readAsBytes();
                                            if (byteImage != null) {
                                              setter(() {
                                                preuve1 = base64Encode(i);
                                              });
                                            }
                                          },
                                          onCanceled: () {
                                            setter(() {
                                              preuve1 = '';
                                            });
                                          },
                                          b64Image: preuve1,
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setter) =>
                                            CaptureTile(
                                          title: "Autre",
                                          onCaptured: () async {
                                            var byteImage = await takePhoto();
                                            var i =
                                                await byteImage.readAsBytes();
                                            if (byteImage != null) {
                                              setter(() {
                                                preuve2 = base64Encode(i);
                                              });
                                            }
                                          },
                                          onCanceled: () {
                                            setter(() {
                                              preuve2 = '';
                                            });
                                          },
                                          b64Image: preuve2,
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setter) =>
                                            CaptureTile(
                                          title: "Autre",
                                          onCaptured: () async {
                                            var byteImage = await takePhoto();
                                            var i =
                                                await byteImage.readAsBytes();
                                            if (byteImage != null) {
                                              setter(() {
                                                preuve3 = base64Encode(i);
                                              });
                                            }
                                          },
                                          onCanceled: () {
                                            setter(() {
                                              preuve3 = '';
                                            });
                                          },
                                          b64Image: preuve3,
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setter) =>
                                            CaptureTile(
                                          title: "Autre",
                                          onCaptured: () async {
                                            var byteImage = await takePhoto();
                                            var i =
                                                await byteImage.readAsBytes();
                                            if (byteImage != null) {
                                              setter(() {
                                                preuve4 = base64Encode(i);
                                              });
                                            }
                                          },
                                          onCanceled: () {
                                            setter(() {
                                              preuve4 = '';
                                            });
                                          },
                                          b64Image: preuve4,
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        // ignore: deprecated_member_use
                        child: RaisedButton.icon(
                          elevation: 10.0,
                          onPressed: paymentPut,
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          color: bgColor,
                          label: Text(
                            "Payer".toUpperCase(),
                            style: GoogleFonts.mulish(
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
          ),
        ),
      ),
    );
  }

  Container payInfos(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 130.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.4),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
              color: Colors.white.withOpacity(.4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(.9),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on,
                          color: Colors.white, size: 15.0),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text("Paiement renseignements",
                          style: GoogleFonts.lato(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldSet(
                        title: "Mois",
                        value: "Janvier",
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      FieldSet(
                        title: "Année",
                        value: "2021",
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      FieldSet(
                        title: "Montant",
                        value:
                            "${apiController.benefiaire.value.netApayer}  ${apiController.benefiaire.value.devise}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container userInfos(BuildContext context) {
    return Container(
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 260.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.4),
                      blurRadius: 12.0,
                      offset: const Offset(0, 3),
                    )
                  ],
                  color: Colors.white.withOpacity(.4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.only(top: 10.0, left: 180.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: FieldRead(
                                  headingTitle: "Matricule",
                                  value:
                                      "${apiController.benefiaire.value.matricule}",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: FieldRead(
                                  headingTitle: "Nom complet",
                                  value:
                                      "${apiController.benefiaire.value.nom} ",
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Flexible(
                                child: FieldRead(
                                  headingTitle: "Téléphone",
                                  value:
                                      "${apiController.benefiaire.value.telephone}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: FieldRead(
                              headingTitle: "Etat civil",
                              value:
                                  "${apiController.benefiaire.value.etatCivil}",
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          // ignore: deprecated_member_use
                          Flexible(
                            child: FieldRead(
                              headingTitle: "Date de naissance",
                              value:
                                  "${apiController.benefiaire.value.dateNais}",
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: FieldRead(
                              headingTitle: "Montant à payer",
                              value:
                                  "${apiController.benefiaire.value.netApayer} ${apiController.benefiaire.value.devise}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(
                      base64Decode(apiController.benefiaire.value.photo)),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.black26,
                    blurRadius: 12.0,
                  )
                ],
              ),
              alignment: Alignment.bottomCenter,
            ),
          )
        ],
      ),
    );
  }

  Future<void> paymentPut() async {
    List<String> preuves = [
      preuve1,
      preuve2,
      preuve3,
      preuve4,
    ];
    preuves.forEach((i) {
      if (i.isEmpty) {
        Get.snackbar("Action requise !",
            "vous devez capturer toutes les preuves requises!",
            snackPosition: SnackPosition.TOP,
            colorText: light,
            backgroundColor: secondaryColor,
            maxWidth: 500,
            borderRadius: 0);
        return;
      }
    });

    try {
      PayModel paiement = PayModel(
        paiementId: apiController.paieInfo.value.paiementId,
        preuve1: preuve1,
        preuve2: preuve2,
        preuve3: preuve3,
        preuve4: preuve4,
        preuve5: "",
        preuve6: "",
      );
      appController.showScan(context, onSuccess: () async {
        await DBHelper.effectuerPaiement(paie: paiement);
      }, onFailed: () {
        XDialog.showConfirmation(
            context: context,
            title: "Agent non reconnu !",
            content:
                "vous devez scanner les empreintes d'un agent valide\npour effectuer un paiement!");
      });
    } catch (err) {
      XDialog.showErrorMessage(context,
          title: "Echec", message: "Paiement non effectué! $err");
    }
  }
}

class FieldSet extends StatelessWidget {
  final String title;
  final String value;
  const FieldSet({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        alignment: Alignment.topLeft,
        child: Container(
          height: 50,
          padding: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: bgColor, width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: 100.0,
                padding: EdgeInsets.all(15.0),
                color: bgColor,
                child: Center(
                  child: Text(
                    title,
                    style: GoogleFonts.mulish(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
                child: Text(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaptureTile extends StatelessWidget {
  final String title;
  final String b64Image;
  final Color tileHeaderColor;
  final Function onCaptured;
  final Function onCanceled;
  const CaptureTile({
    Key key,
    this.title,
    this.b64Image = "",
    this.tileHeaderColor,
    this.onCaptured,
    this.onCanceled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                height: 40.0,
                color: (b64Image.isNotEmpty)
                    ? Colors.green[700]
                    : (tileHeaderColor == null)
                        ? bgColor
                        : tileHeaderColor,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    title,
                    style:
                        GoogleFonts.lato(color: Colors.white, fontSize: 14.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: b64Image.isEmpty
                      ? BoxDecoration(
                          color: Colors.black.withOpacity(.4),
                        )
                      : BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(
                              base64Decode(b64Image),
                            ),
                          ),
                        ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.zero,
                    child: InkWell(
                      onTap: onCaptured,
                      child: Center(
                        child: b64Image.isEmpty
                            ? Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                                size: 30.0,
                              )
                            : Container(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (b64Image.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.red[200],
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.zero,
                child: InkWell(
                    onTap: onCanceled,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      child: Center(
                        child: Icon(Icons.clear,
                            size: 15.0, color: Colors.red[800]),
                      ),
                    )),
              ),
            ),
          )
      ],
    );
  }
}
