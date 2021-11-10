import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';

class DashCard extends StatelessWidget {
  final IconData icon;
  final String strIcon;
  final String title;
  final String value;
  final int clIndex;

  DashCard(
      {Key key,
      this.icon,
      this.title,
      this.strIcon,
      this.clIndex = 0,
      this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      width: 250.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(.2),
                ),
                child: Icon(
                  icon,
                  color: Colors.cyan[50],
                  size: 50.0,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "$title",
              textAlign: TextAlign.center,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w400, color: Colors.cyan[50]),
            ),
            SizedBox(
              height: 5.0,
            ),
            Flexible(
              child: Text(
                "$value\n",
                textAlign: TextAlign.center,
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w900,
                    color: Colors.cyan[50],
                    fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
