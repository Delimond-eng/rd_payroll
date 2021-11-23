import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';

import 'package:medpad/pages/payments/payment_make_page.dart';
import 'package:medpad/widgets/user_session.dart';
import 'package:page_transition/page_transition.dart';

class PaymentPageView extends StatefulWidget {
  @override
  _PaymentPageViewState createState() => _PaymentPageViewState();
}

class _PaymentPageViewState extends State<PaymentPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agent scanning"),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [UserBox()],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white.withOpacity(.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              child: Center(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 220.0,
                      height: 250,
                      child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () async {
                                await apiController.findClientByFingerId(
                                    fingerId: "1");
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    child: PaymentFoundPage(),
                                    fullscreenDialog: true,
                                    type:
                                        PageTransitionType.leftToRightWithFade,
                                  ),
                                );
                                /*appController.showScan(
                                  context,
                                  onSuccess: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: PaymentFoundPage(),
                                        fullscreenDialog: true,
                                        type: PageTransitionType
                                            .leftToRightWithFade,
                                      ),
                                    );
                                  },
                                  onFailed: () {
                                    XDialog.show(
                                        context: context,
                                        icon: CupertinoIcons
                                            .person_crop_circle_fill_badge_exclam,
                                        title: "Agent non reconnue !",
                                        content:
                                            "Les empreintes de cet agent n'existent pas dans le système,\nveuillez cliquer sur valider pour rechercher cet agent dans le système !",
                                        onValidate: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: SearchPage(),
                                              fullscreenDialog: true,
                                              type: PageTransitionType
                                                  .leftToRightWithFade,
                                            ),
                                          );
                                        });
                                  },
                                );*/
                              },
                              child: Container(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Lottie.asset(
                                        "assets/lotties/4771-finger-print.json",
                                        width: 120.0,
                                        height: 120.0,
                                        reverse: true,
                                        fit: BoxFit.cover,
                                        animate: true),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                      top: -40,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 6),
                              color: lightGrey.withOpacity(.4),
                              blurRadius: 12.0,
                            )
                          ],
                        ),
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.person,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
