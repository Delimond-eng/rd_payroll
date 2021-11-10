import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String strIcon;
  final String title;
  final Function navigate;
  final bool isActive;
  final bool isPopup;
  final Widget popupItems;
  final int clIndex;

  ActionCard(
      {Key key,
        this.icon,
        this.title,
        this.navigate,
        this.isActive = false,
        this.isPopup = false,
        this.popupItems,
        this.strIcon, this.clIndex = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        color: Colors.white,
        elevation: 20.0,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            splashColor: Colors.primaries[clIndex].withAlpha(100),
            onTap: navigate,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        color: Colors.primaries[clIndex].withAlpha(50)
                          ),
                      child: isPopup == true
                          ? popupItems
                          : (strIcon != null)
                          ? Container(
                        margin: EdgeInsets.all(15.0),
                        child: SvgPicture.asset(strIcon,
                            height: 30.0,
                            width: 30.0,
                            alignment: Alignment.center,
                            color: Colors.primaries[clIndex].shade900,
                            fit: BoxFit.fill),
                      )
                          : Icon(
                        icon,
                        color: Colors.primaries[clIndex].shade900,
                        size: 30.0,
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  Flexible(
                    child: Text(
                      "$title\n",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w700, color: Colors.primaries[clIndex].shade900),
                    ),
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