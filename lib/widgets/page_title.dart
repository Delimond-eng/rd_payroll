import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const PageTitle({Key key, this.title, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lato(
          fontSize: 22.0,
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
            ),
          ),
          TextSpan(
            text: 'PayRoll',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w900,
              color: Colors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
