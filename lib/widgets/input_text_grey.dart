import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/date_formater.dart';

class InputText extends StatelessWidget {
  final inputController;
  final String hintText;
  final IconData icon;
  final TextInputType keyType;
  final String title;
  final bool isRequired;
  final bool readOnly;
  final double radius;
  final bool isWithSelectable;
  String devise;

  InputText({
    Key key,
    this.inputController,
    this.hintText,
    this.icon,
    this.keyType,
    this.title,
    this.isRequired = false,
    this.readOnly = false,
    this.radius,
    this.isWithSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          SizedBox(
            height: 5.0,
          ),
        Row(
          children: [
            if (title != null)
              Text(
                "${title.toUpperCase()}",
                style: GoogleFonts.mulish(
                    color: bgColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    letterSpacing: 1.0),
              ),
            SizedBox(
              width: 5.0,
            ),
            if (isRequired == true)
              Text(
                "*",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              ),
          ],
        ),
        if (title != null)
          SizedBox(
            height: 5.0,
          ),
        if (isWithSelectable)
          Container(
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                border: Border.all(color: bgColor, width: 1)),
            child: TextField(
              readOnly: readOnly,
              focusNode: FocusNode(),
              controller: inputController,
              style: TextStyle(fontSize: 14.0),
              keyboardType: keyType == null ? TextInputType.text : keyType,
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.only(top: 15, bottom: 10),
                hintStyle: TextStyle(color: Colors.black38),
                icon: Container(
                    padding: EdgeInsets.only(right: 8),
                    height: 50.0,
                    width: 100,
                    decoration: BoxDecoration(color: bgColor),
                    child: Center(
                      child: Text("montant",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                          )),
                    )),
                suffixIcon: Container(
                  height: 50,
                  width: 100,
                  color: Colors.grey[100],
                  padding: EdgeInsets.all(10),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      menuMaxHeight: 300,
                      dropdownColor: Colors.white,
                      value: devise,
                      underline: SizedBox(),
                      hint: Text(
                        "Devise",
                        style: GoogleFonts.mulish(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic),
                      ),
                      isExpanded: false,
                      items: ["FC", "USD"].map((e) {
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "$e",
                                  style: GoogleFonts.mulish(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          devise = value;
                          appController.devise.value = value;
                        });
                      },
                    );
                  }),
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          )
        else
          Container(
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                border: Border.all(color: bgColor, width: 1)),
            child: keyType != TextInputType.datetime
                ? TextField(
                    readOnly: readOnly,
                    focusNode: FocusNode(),
                    controller: inputController,
                    style: TextStyle(fontSize: 14.0),
                    keyboardType:
                        keyType == null ? TextInputType.text : keyType,
                    decoration: InputDecoration(
                      hintText: hintText,
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                      hintStyle: TextStyle(color: Colors.black38),
                      icon: Container(
                        padding: EdgeInsets.only(right: 8),
                        height: 50.0,
                        width: 70.0,
                        decoration:
                            BoxDecoration(color: bgColor.withOpacity(.4)),
                        child: Icon(
                          icon,
                          color: bgColor,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  )
                : TextField(
                    // maxLength: 10,
                    keyboardType: TextInputType.datetime,
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: 'JJ / MM / YYYY',
                      hintStyle: TextStyle(color: Colors.black38),
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                      icon: Container(
                        padding: EdgeInsets.only(right: 8),
                        height: 50.0,
                        width: 70.0,
                        decoration:
                            BoxDecoration(color: bgColor.withOpacity(.4)),
                        child: Icon(
                          icon,
                          color: Colors.grey[100],
                          size: 20,
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
                  ),
          )
      ],
    );
  }
}
