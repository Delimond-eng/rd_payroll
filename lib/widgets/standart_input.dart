import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/helpers/date_formater.dart';

class StandardInput extends StatelessWidget {
  final controller;
  final String hintText;
  final String title;
  final IconData icon;
  final TextInputType keyType;

  const StandardInput(
      {Key key,
      this.controller,
      this.hintText,
      this.icon,
      this.keyType,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(color: Colors.cyan[500], width: 1.0)),
        child: keyType != TextInputType.datetime
            ? TextField(
                controller: controller,
                style: TextStyle(fontSize: 14.0),
                keyboardType: keyType == null ? TextInputType.text : keyType,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.black54),
                  icon: Container(
                    height: 50.0,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.cyan[500],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "$title",
                          style: GoogleFonts.mulish(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Icon(
                    icon,
                    color: Colors.cyan[800],
                    size: 18.0,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              )
            : TextField(
                controller: controller,
                style: TextStyle(fontSize: 14.0),
                keyboardType: keyType == null ? TextInputType.text : keyType,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  hintText: 'JJ / MM / AAAA',
                  hintStyle: TextStyle(color: Colors.black54),
                  icon: Container(
                    width: 200,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.cyan[500],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$title",
                            style: GoogleFonts.mulish(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            CupertinoIcons.calendar,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
                inputFormatters: [
                  // ignore: deprecated_member_use
                  WhitelistingTextInputFormatter(RegExp("[0-9/]")),
                  LengthLimitingTextInputFormatter(10),
                  DateFormatter(),
                ],
              ));
  }
}
