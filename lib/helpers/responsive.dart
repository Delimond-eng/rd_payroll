
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({Key key, this.mobile, this.tablet, this.desktop}) : super(key: key);

  //This isMobile, isTablet, isDeskTop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

  @override
  Widget build(BuildContext context){
    final Size _size = MediaQuery.of(context).size;

    if(_size.width >= 1100){
      return desktop;
    }
    else if(_size.width >= 850 && tablet != null){
      return tablet;
    }
    else{
      return mobile;
    }
  }
}
