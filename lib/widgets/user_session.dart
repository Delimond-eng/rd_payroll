import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/utilities.dart';
import 'package:medpad/pages/auth/authenticate_page_route.dart';
import 'package:page_transition/page_transition.dart';

class UserBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
        height: 50.0,
        padding: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.6),
            borderRadius: BorderRadius.circular(2)),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50.0,
              width: 45.0,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.4),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    CupertinoIcons.person,
                    color: bgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Obx(() {
              return Container(
                height: 50.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apiController.user.value.nom.capitalizeFirst,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "agent payeur",
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      onSelected: (value) {
        switch (value) {
          case 1:
            XDialog.show(
              icon: Icons.logout,
              context: context,
              content:
                  "Etes-vous sûr de vouloir vous déconnecter de votre compte ?",
              title: "Déconnexion",
              onValidate: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      child: AuthenticationPageRoute(),
                      type: PageTransitionType.bottomToTop),
                  (route) => false,
                );
              },
            );
            break;
          case 2:
            XDialog.show(
              icon: Icons.help,
              context: context,
              content: "Etes-vous sûr de vouloir fermer l'application ?",
              title: "Fermeture",
              onValidate: () {
                exit(0);
              },
            );
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: bgColor,
                  ),
                ),
                Text(
                  'Déconnexion',
                  style:
                      GoogleFonts.mulish(color: Colors.black54, fontSize: 14.0),
                )
              ],
            )),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.redAccent,
                ),
              ),
              Text(
                "Quitter",
                style:
                    GoogleFonts.mulish(color: Colors.black54, fontSize: 14.0),
              )
            ],
          ),
        ),
      ],
    );
  }
}
