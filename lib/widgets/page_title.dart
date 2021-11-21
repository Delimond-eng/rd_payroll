import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageTitle extends StatelessWidget {
  final double fontSize;

  const PageTitle({Key key, this.fontSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lato(
          fontSize: fontSize == null ? 22.0 : fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w900,
          shadows: [
            const Shadow(
                color: Colors.black26, blurRadius: 10.0, offset: Offset(0, 2))
          ],
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'GSA ',
            style: GoogleFonts.lato(
              letterSpacing: 1,
              color: Colors.blue,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'PayRoll',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              color: Colors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
