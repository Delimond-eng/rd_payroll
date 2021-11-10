import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/style.dart';

class FingerControl extends StatelessWidget {
  final Function onEnrollSuccess;
  final String strFingerImage;
  final int number;

  const FingerControl(
      {Key key, this.onEnrollSuccess, this.strFingerImage, this.number})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: bgColor, width: 1.0),
            color: Colors.grey[100],
          ),
          child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              color: Colors.grey,
              child: Material(
                color: Colors.grey[100],
                child: InkWell(
                  splashColor: Colors.cyanAccent,
                  onTap: onEnrollSuccess,
                  child: Container(
                    height: 170.0,
                    width: 170.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          blurRadius: 12.0,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: strFingerImage.isEmpty
                            ? Lottie.asset(
                                "assets/lotties/4771-finger-print.json",
                                width: 120.0,
                                height: 120.0,
                                reverse: true,
                                fit: BoxFit.cover,
                                animate: true)
                            : Center(
                                child: imageFromBase64String(strFingerImage),
                              ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        Positioned(
          top: -5,
          right: -5,
          child: Container(
            height: 30.0,
            width: 30.0,
            color: (strFingerImage.isNotEmpty && strFingerImage != null)
                ? Colors.green[700]
                : Colors.grey[500],
            child: Center(
              child: Text(
                "$number",
                style: GoogleFonts.mulish(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
