import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color light = Color(0xFFF7F8FC);
Color lightGrey = Color(0xFFA4A6B3);
Color darker = Color(0xFF363740);
Color bgColor = Color(0xFF001f6b);

const primaryColor = Colors.cyan;
const secondaryColor = Color(0xFF0d4b84);
Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

List<String> provinceList = [
  "Kinshasa",
  "Bas-Uele",
  "Haut-Katanga",
  "Haut-Lomami",
  "Haut-Uele",
  "Ituri",
  "Kasaï",
  "Kasaï-central",
  "Kasaï-Oriental",
  "Kongo-Central",
  "Kwango",
  "Kwilu",
  "Lomami",
  "Lualaba",
  "Mai-Ndombe",
  "Maniema",
  "Mongala",
  "Nord-Kivu",
  "Nord-Ubangi",
  "Sankuru",
  "Sud-Ubangi",
  "Tanganyika",
  "Tshoko",
  "Tshuapa"
];

Image imageFromBase64String(String base64String) {
  try {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.scaleDown,
      height: 150,
      width: 150,
    );
  } catch (e) {
    print(e);
    return null;
  }
}

String truncateString(String text, int length) {
  return (text.length >= length) ? '${text.substring(0, length)}...' : text;
}

String formatDate(DateTime date) {
  final format = DateFormat.yMd('fr_FR');
  return format.format(date);
}

String convertToBase64Bytes(Uint8List data) => base64Encode(data);
Uint8List byteEncoding(String b64) => base64Decode(b64);

List<String> gStrSplitParser(String date) {
  String name = date;
  var strList = name.split(new RegExp(r"[,|]"));
  return strList;
}
