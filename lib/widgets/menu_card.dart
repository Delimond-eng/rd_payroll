import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AgenceCard extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final Color subColor;
  final Function onPressed;
  const AgenceCard({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.subColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.4),
                blurRadius: 12.0,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(5.0),
              onTap: onPressed,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 120.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          "assets/svg/$icon",
                          height: 50.0,
                          width: 50.0,
                          color: Colors.cyan[200],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: subColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 8.0,
              bottom: 8.0,
              top: 15.0,
            ),
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.0),
                topLeft: Radius.circular(50.0),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/payroll-salary.svg",
                color: Colors.white,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        )
      ],
    );
  }
}
