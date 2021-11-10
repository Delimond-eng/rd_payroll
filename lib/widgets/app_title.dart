import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';

class AppTitle extends StatefulWidget {
  AppTitle({Key key}) : super(key: key);

  @override
  _AppTitleState createState() => _AppTitleState();
}

class _AppTitleState extends State<AppTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("RD",
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
                fontWeight: FontWeight.w900,
                color: primaryColor,
                fontSize: 18.0,
                letterSpacing: .1,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 1)
                ])),
        SizedBox(width: 5.0,),
        Text("TECHNOLOGIC",
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 18.0,
                letterSpacing: .1,
                shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(0, 2), blurRadius: 1)
                ])),
      ],
    );
  }
}
