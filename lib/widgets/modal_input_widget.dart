import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medpad/constants/style.dart';

class ModalInputText extends StatelessWidget {
  final controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyType;
  const ModalInputText(
      {Key key, this.controller, this.hintText, this.icon, this.keyType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            bottom: BorderSide(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade900,
              width: 2.0
            )
          )
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14.0),
          keyboardType: keyType == null ? TextInputType.text : keyType,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.only(top: 10, bottom: 10),
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
