// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/widgets/menu_card.dart';
import 'package:medpad/widgets/page_title.dart';
import 'package:medpad/widgets/user_session.dart';
import 'package:page_transition/page_transition.dart';

import 'home_screen.dart';

class AgenceViewScreen extends StatefulWidget {
  AgenceViewScreen({Key key}) : super(key: key);

  @override
  _AgenceViewScreenState createState() => _AgenceViewScreenState();
}

class _AgenceViewScreenState extends State<AgenceViewScreen> {
  @override
  Widget build(BuildContext context) {
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
                "Paiements agences",
                style: GoogleFonts.lato(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          actions: [
            UserBox(),
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
                child: Scrollbar(
              radius: Radius.circular(10.0),
              thickness: 5.0,
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.20,
                    crossAxisCount: 4,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0),
                itemCount: 10,
                itemBuilder: (_, i) {
                  return AgenceCard(
                    color: Colors.blue[900].withOpacity(.7),
                    icon: 'bank-deposit.svg',
                    title: "agence name",
                    subColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: HomeScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            )),
          ),
        ));
  }
}
