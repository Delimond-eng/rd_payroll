import 'package:flutter/material.dart';
import 'package:medpad/constants/style.dart';

class DropDownInput extends StatefulWidget {
  final List<String> dropdownItems;

  DropDownInput({Key key, this.dropdownItems}) : super(key: key);

  @override
  _DropDownInputState createState() => _DropDownInputState();
}

class _DropDownInputState extends State<DropDownInput> {
  String _dropDownValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: _dropDownValue == null
          ? Text('Sélectionnez item...')
          : Text(
              _dropDownValue,
              style: TextStyle(color: secondaryColor),
            ),
      isExpanded: true,
      iconSize: 30.0,
      style: TextStyle(color: secondaryColor),
      items: widget.dropdownItems.map(
        (val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          );
        },
      ).toList(),
      onChanged: (val) {
        setState(
          () {
            _dropDownValue = val;
          },
        );
      },
    );
  }
}
