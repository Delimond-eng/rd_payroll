import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';

class NavCard extends StatelessWidget {
  final String icon;
  final String title;
  final Function pressed;

  const NavCard({Key key, this.icon, this.title, this.pressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(1),
      child: InkWell(
        onTap: pressed,
        borderRadius: BorderRadius.circular(1),
        child: Container(
          height: 95.0,
          width: 180,
          child: Card(
            color: primaryColor,
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SvgPicture.asset(
                    icon,
                    alignment: Alignment.center,
                    width: 35.0,
                    height: 35.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
