import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';

class Dbutton extends StatelessWidget {
  final IconData icon;
  final Function press;
  final String label;
  final double width;
  final double height;
  final Color color;
  Dbutton({
    Key key,
    this.press,
    this.label,
    this.width,
    this.height,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? null,
      height: height ?? null,
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: color == null
                  ? [Colors.blue[900],primaryColor]
                  : [color, color])),
      // ignore: deprecated_member_use
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
          onPressed: press,
          child: icon == null
              ? Text(
                  label,
                  style: GoogleFonts.mulish(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.w600),
                )
              : SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        label,
                        style: GoogleFonts.mulish(color: Colors.white, letterSpacing: 1.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
    );
  }
}
