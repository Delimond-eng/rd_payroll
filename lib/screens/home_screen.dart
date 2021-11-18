import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/pages/payments/payment_page_scanning.dart';
import 'package:medpad/pages/payments/payment_report_page.dart';
import 'package:medpad/widgets/user_session.dart';

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
            Icon(
              Icons.payment,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text("RD Payroll")
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
                              MaterialPageRoute(
                                builder: (context) => PaymentPageView(),
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
                              MaterialPageRoute(
                                builder: (context) => PaymentReportPage(),
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DashCard(
                          title: "Montant alloué",
                          icon: Icons.add_chart,
                          clIndex: 4,
                          value:
                              "${apiController.user.value.montant} ${apiController.user.value.devise}",
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        DashCard(
                          title: "Montant restant",
                          icon: Icons.bar_chart_sharp,
                          value:
                              "${apiController.user.value.montantReste} ${apiController.user.value.devise} ",
                          clIndex: 5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        DashCard(
                          title: "Montant payé",
                          icon: CupertinoIcons.chart_bar_circle,
                          value: "$pAmount ${apiController.user.value.devise} ",
                          clIndex: 5,
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
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Colors.cyan,
            onTap: onPressed,
            child: Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
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
      ),
    );
  }
}
