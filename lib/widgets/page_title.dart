import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const PageTitle({Key key, this.title, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryColor,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "$title",
          style: GoogleFonts.mulish(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              letterSpacing: .2),
        ),
      ],
    );
  }
}
