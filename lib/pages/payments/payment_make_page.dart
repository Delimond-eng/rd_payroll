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
import 'package:medpad/services/db_helper_service.dart';
import 'package:medpad/widgets/input_text_grey.dart';
import 'package:medpad/widgets/user_session.dart';

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

  String preuve1 = "";
  String preuve2 = "";
  String preuve3 = "";
  String preuve4 = "";

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
              padding: EdgeInsets.only(
                  top: 20.0, right: 10.0, left: 10.0, bottom: 20.0),
              physics: BouncingScrollPhysics(),
              child: Column(
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
                  Container(
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
                                    margin: EdgeInsets.only(
                                        top: 10.0, left: 180.0, right: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                    "${agent.nom} ${agent.postnom} ${agent.prenom}",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Flexible(
                                              child: FieldRead(
                                                headingTitle: "Etat civil",
                                                value: "${agent.etatCivil}",
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: FieldRead(
                                            headingTitle: "Date de naissance",
                                            value: "${agent.dateNaissance}",
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
                  Container(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
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
                                        style: GoogleFonts.lato(
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CalendarField(
                                      title: "Mois",
                                      value: "Janvier",
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    CalendarField(
                                      title: "Année",
                                      value: "2021",
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
                                    currency: "FC",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                  style: GoogleFonts.lato(color: Colors.white)),
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
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.10,
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                                children: [
                                  StatefulBuilder(
                                    builder: (context, setter) => CaptureTile(
                                      title: "Preuve de la carte d'identité",
                                      tileHeaderColor: Colors.red[400],
                                      onCaptured: () async {
                                        var byteImage = await takePhoto();
                                        var i = await byteImage.readAsBytes();
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
                                    builder: (context, setter) => CaptureTile(
                                      title: "Autre",
                                      onCaptured: () async {
                                        var byteImage = await takePhoto();
                                        var i = await byteImage.readAsBytes();
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
                                    builder: (context, setter) => CaptureTile(
                                      title: "Autre",
                                      onCaptured: () async {
                                        var byteImage = await takePhoto();
                                        var i = await byteImage.readAsBytes();
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
                                    builder: (context, setter) => CaptureTile(
                                      title: "Autre",
                                      onCaptured: () async {
                                        var byteImage = await takePhoto();
                                        var i = await byteImage.readAsBytes();
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
                    XDialog.showConfirmation(
                      context: context,
                      title: "Paiement non effectué !",
                      content:
                          "Aucune preuve en image n'a été fournie pour effectuer ce paiement,\nveuillez fournir toutes les preuves requises en image !",
                    );
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

class CalendarField extends StatelessWidget {
  final String title;
  final String value;
  const CalendarField({
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
