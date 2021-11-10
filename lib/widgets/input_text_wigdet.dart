import 'package:flutter/material.dart';
import 'package:medpad/constants/style.dart';

class GInputText extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;

  const GInputText({Key key, this.label, this.hint, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2)),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                icon,
              ),
            ),
          ),
        ));
  }
}
