import 'package:flutter/material.dart';
import 'package:medpad/constants/style.dart';

class CustomInputText extends StatelessWidget {
  final controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyType;
  const CustomInputText(
      {Key key, this.controller, this.hintText, this.icon, this.keyType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.grey[200],
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14.0),
          keyboardType: keyType == null ? TextInputType.text : keyType,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.only(top: 8, bottom: 8),
            hintStyle: TextStyle(color: Colors.black38),
            icon: Icon(
              icon,
              color: secondaryColor,
              size: 20,
            ),
            border: InputBorder.none,
            counterText: '',
          ),
        ));
  }
}
