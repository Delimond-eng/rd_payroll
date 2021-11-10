// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/utilities.dart';
import 'package:medpad/models/agent_model.dart';
import 'package:medpad/models/paiement_model.dart';
import 'package:medpad/pages/agents/widgets/user_field_widget.dart';
import 'package:medpad/pages/payments/payment_report_page.dart';
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/widgets/input_text_grey.dart';
import 'package:medpad/widgets/user_session.dart';
import 'package:page_transition/page_transition.dart';

class PaymentFoundPage extends StatefulWidget {
  @override
  _PaymentFoundPageState createState() => _PaymentFoundPageState();
}

class _PaymentFoundPageState extends State<PaymentFoundPage> {
  String selectedMonth;
  String selectedYear;
  String devise;

  Agent agent = apiController.agent.value;

  final textAmount = TextEditingController();

  String preuveCapture = "";

  Future<PickedFile> takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 50);

    if (pickedFile != null) {
      return pickedFile;
    }
  }

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
              padding: EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      // ignore: deprecated_member_use
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                              Flexible(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: 10.0, left: 180.0, right: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: FieldRead(
                                              headingTitle:
                                                  "Localité & adresse",
                                              value:
                                                  "${agent.localite}, ${agent.adresse}",
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            child: FieldRead(
                                              headingTitle: "Date de naissance",
                                              value: "${agent.dateNaissance}",
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
                                              headingTitle: "Etat civil",
                                              value: "${agent.etatCivil}",
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            child: FieldRead(
                                              headingTitle: "Montant à payer",
                                              value:
                                                  "${agent.montant} ${agent.devise}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 15.0,
                          right: 15.0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.person_circle_fill,
                                        color: bgColor,
                                        size: 17.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${agent.nom.toUpperCase()} ${agent.postnom.toUpperCase()} ${agent.prenom.capitalize}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          color: secondaryColor,
                                          fontSize: 14.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                image: MemoryImage(base64Decode(agent.photo)),
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
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: bgColor, width: 1.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 50.0,
                                                width: 100.0,
                                                padding: EdgeInsets.all(15.0),
                                                color: bgColor,
                                                child: Center(
                                                  child: Text(
                                                    "Mois",
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: DropdownButton<String>(
                                                  menuMaxHeight: 300,
                                                  dropdownColor: Colors.white,
                                                  value: selectedMonth,
                                                  underline: SizedBox(),
                                                  hint: Text(
                                                    " mois",
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.grey[400],
                                                        fontSize: 14.0,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                  isExpanded: true,
                                                  items: [
                                                    "Janvier",
                                                    "Février",
                                                    "Mars",
                                                    "Avril",
                                                    "Mai",
                                                    "Juin",
                                                    "Juillet",
                                                    "Septembre",
                                                    "Octobre",
                                                    "Novembre",
                                                    "Décembre"
                                                  ].map((e) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: e,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "$e",
                                                              style: GoogleFonts.mulish(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMonth = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: bgColor, width: 1.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 50.0,
                                                width: 100,
                                                padding: EdgeInsets.all(15.0),
                                                color: bgColor,
                                                child: Center(
                                                  child: Text(
                                                    "Année",
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: DropdownButton<String>(
                                                  menuMaxHeight: 300,
                                                  dropdownColor: Colors.white,
                                                  value: selectedYear,
                                                  underline: SizedBox(),
                                                  hint: Text(
                                                    " année",
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.grey[400],
                                                        fontSize: 14.0,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                  isExpanded: true,
                                                  items: [
                                                    "2021",
                                                    "2022",
                                                  ].map((e) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: e,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "$e",
                                                              style: GoogleFonts.mulish(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedYear = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: InputText(
                                    icon: Icons.money,
                                    inputController: textAmount,
                                    hintText: "Entrer montant",
                                    keyType: TextInputType.number,
                                    isWithSelectable: true,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  height: 80.0,
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),

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
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> paymentPut() async {
    int agentId = apiController.agent.value.agentId;
    int userId = apiController.user.value.userId;
    setState(() {
      devise = appController.devise.value;
    });
    if (textAmount.text.isEmpty) {
      Get.snackbar(
          "Montant à payer requis !", "vous devez entrer le montant à payer!",
          snackPosition: SnackPosition.TOP,
          colorText: light,
          backgroundColor: Colors.amber[800],
          maxWidth: 500,
          borderRadius: 0);
      return;
    }
    if (selectedMonth == null || selectedMonth == "") {
      Get.snackbar("Mois requis !", "vous devez sélectionner un mois!",
          snackPosition: SnackPosition.TOP,
          colorText: light,
          backgroundColor: Colors.amber[800],
          maxWidth: 500,
          borderRadius: 20);
      return;
    }
    if (selectedYear == null || selectedYear == "") {
      Get.snackbar("Année requise !", "vous devez sélectionner une année!",
          snackPosition: SnackPosition.TOP,
          colorText: light,
          backgroundColor: Colors.amber[800],
          maxWidth: 500,
          borderRadius: 0);
      return;
    }
    if (devise == null || devise == "") {
      Get.snackbar(
          "La devise est requise !", "vous devez sélectionner une devise!",
          snackPosition: SnackPosition.TOP,
          colorText: light,
          backgroundColor: secondaryColor,
          maxWidth: 500,
          borderRadius: 0);
      return;
    }

    if (preuveCapture.isEmpty) {
      Modal.show(
        context,
        height: 200,
        width: 300,
        title: "Capture",
        icon: Icons.photo_camera_sharp,
        modalContent: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Text("Veuillez prendre une capture de preuve"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 60.0,
              width: 300,
              child: RaisedButton(
                color: bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onPressed: () async {
                  var image = await takePhoto();
                  if (image != null) {
                    Get.back();
                    var bytes = await image.readAsBytes();
                    setState(() {
                      preuveCapture = base64Encode(bytes);
                    });
                  } else {
                    Get.back();
                    XDialog.showErrorMessage(context,
                        color: Colors.red[300],
                        title: "Echec !",
                        message:
                            "Paiement non effectué !!\n cause : la capture de la preuve de paiement n'a pas été prise !");
                    return;
                  }
                },
                child: Icon(
                  CupertinoIcons.photo_camera,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
      return;
    }

    try {
      Payment payment = Payment(
        agentId: agentId,
        montant: int.parse(textAmount.text),
        annee: selectedYear,
        mois: selectedMonth,
        devise: devise,
        datePaie: formatDate(DateTime.now()),
        capture: preuveCapture,
        userId: userId,
        statut: "actif",
      );

      appController.showScan(context, onSuccess: () async {
        await DBHelper.savePaiement(payment: payment).then((result) async {
          Xloading.dismiss();
          if (result != null) {
            XDialog.showSuccessAnimation(context);
            textAmount.text = "";
            await apiController.loadDatas();
          }
        }).catchError((error) {
          Xloading.dismiss();
          XDialog.showErrorMessage(context,
              title: "Echec", message: "Paiement non effectué!");
        });
      }, onFailed: () {
        Get.back();

        XDialog.showErrorMessage(context,
            color: Colors.red[300],
            title: "Agent non reconnu !",
            message:
                "vous devez scanner les empreintes d'un agent valide\npour effectuer un paiement!");
      });
    } catch (err) {
      XDialog.showErrorMessage(context,
          title: "Echec", message: "Paiement non effectué! $err");
    }
  }
}
