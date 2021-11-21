import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/widgets/user_session.dart';

class PaySessionCancelPage extends StatefulWidget {
  PaySessionCancelPage({Key key}) : super(key: key);

  @override
  _PaySessionCancelPageState createState() => _PaySessionCancelPageState();
}

class _PaySessionCancelPageState extends State<PaySessionCancelPage> {
  String preuveImg = "";
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloture de la session de paiement"),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [UserBox()],
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
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
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, setter) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      // ignore: deprecated_member_use
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          height: 250.0,
                          width: 300.0,
                          decoration: preuveImg.isEmpty
                              ? BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12.0,
                                      color: Colors.grey.withOpacity(.4),
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                )
                              : BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(
                                      base64Decode(preuveImg),
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12.0,
                                      color: Colors.grey.withOpacity(.4),
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.zero,
                            child: InkWell(
                              borderRadius: BorderRadius.zero,
                              onTap: () async {
                                var picked = await takePhoto();
                                var i = await picked.readAsBytes();

                                setter(() {
                                  preuveImg = base64Encode(i);
                                });
                              },
                              child: preuveImg.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Lottie.asset(
                                            "assets/lotties/5383-loading-16-camera.json"),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 40.0,
                            width: 300.0,
                            color:
                                preuveImg.isEmpty ? bgColor : Colors.green[700],
                            child: Center(
                              child: Text(
                                "Appuyez pour capture la preuve !",
                                style: GoogleFonts.lato(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        if (preuveImg.isNotEmpty)
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 12.0,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50.0),
                                  onTap: () {
                                    setter(() {
                                      preuveImg = "";
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 60.0,
                      width: 300.0,
                      // ignore: deprecated_member_use
                      child: RaisedButton.icon(
                        color: Colors.orange[800],
                        elevation: 10.0,
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          size: 15.0,
                          color: Colors.white,
                        ),
                        label: Text("Cloturer la session de paiement",
                            style: GoogleFonts.lato(color: Colors.white)),
                        onPressed: () {},
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
