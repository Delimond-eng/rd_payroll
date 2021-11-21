import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/pages/agents/search_page.dart';
import 'package:medpad/pages/pay_session_cancel_page.dart';
import 'package:medpad/pages/payments/payment_page_scanning.dart';
import 'package:medpad/widgets/page_title.dart';
import 'package:medpad/widgets/user_session.dart';
import 'package:page_transition/page_transition.dart';

import 'widgets/dash_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get pAmount =>
      apiController.user.value.montant - apiController.user.value.montantReste;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Row(
          children: [
            PageTitle(),
            SizedBox(
              width: 4.0,
            ),
            Icon(
              Icons.arrow_right_alt_rounded,
              color: Colors.white,
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              "Agence de Kolwezi",
              style: GoogleFonts.lato(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              icon: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 15,
              ),
              label: Text(
                "Cloturer la session de paiement",
                style: GoogleFonts.lato(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: PaySessionCancelPage(),
                  ),
                );
              },
              color: Colors.orange,
            ),
          ),
          UserBox()
        ],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: _size.width,
                  margin:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: HomeNavCard(
                          icon: Icons.payments,
                          title: "Paiement agent",
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRightWithFade,
                                child: PaymentPageView(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: HomeNavCard(
                          icon: Icons.show_chart,
                          title: "Paiement reporting",
                          onPressed: () async {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: SearchPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Obx(() {
                  return Container(
                    child: GridView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.20,
                        crossAxisCount: 3,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                      children: [
                        DashCard(
                          title: "Montant alloué",
                          strIcon: "assets/svg/financial-growth.svg",
                          color: bgColor,
                          value:
                              "${apiController.user.value.montant.toDouble()} ${apiController.user.value.devise.toLowerCase()}",
                        ),
                        DashCard(
                          title: "Montant restant",
                          strIcon: "assets/svg/financial-statement.svg",
                          value:
                              "${apiController.user.value.montantReste.toDouble()} ${apiController.user.value.devise.toLowerCase()} ",
                          color: bgColor,
                        ),
                        DashCard(
                          title: "Montant payé",
                          strIcon: "assets/svg/payroll-salary.svg",
                          value:
                              "${pAmount.toDouble()} ${apiController.user.value.devise.toLowerCase()} ",
                          color: Colors.grey[800],
                        ),
                      ],
                    ),
                  );
                }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeNavCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;
  const HomeNavCard({
    this.title,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.zero,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: bgColor, size: 30),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
