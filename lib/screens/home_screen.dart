import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';

import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/pages/pay_session_cancel_page.dart';
import 'package:medpad/pages/payments/payment_page_scanning.dart';
import 'package:medpad/widgets/page_title.dart';
import 'package:medpad/widgets/user_session.dart';

import 'widgets/dash_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get total =>
      double.parse(apiController.activite.value.montantBudget) -
      apiController.montantGlobalPayer.value;
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
                            Navigator.push(
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
                          icon: Icons.warning_rounded,
                          color: Colors.orange[700],
                          title: "Cloturer la session de paiement",
                          onPressed: () async {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PaySessionCancelPage(),
                                type: PageTransitionType.bottomToTop,
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
                              "${double.parse(apiController.activite.value.montantBudget)} ${apiController.activite.value.devise}",
                        ),
                        DashCard(
                          title: "Montant restant",
                          strIcon: "assets/svg/financial-statement.svg",
                          value:
                              "${apiController.montantGlobalPayer} ${apiController.activite.value.devise}",
                          color: bgColor,
                        ),
                        DashCard(
                          title: "Montant payé",
                          strIcon: "assets/svg/payroll-salary.svg",
                          value:
                              "$total ${apiController.activite.value.devise}",
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
  final Color color;
  const HomeNavCard({
    this.title,
    this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: color == null ? Colors.white : color,
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
                  Icon(icon,
                      color: color == null ? bgColor : Colors.white, size: 30),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: color == null ? null : Colors.white),
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
