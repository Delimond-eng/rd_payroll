import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/pages/agents/agent_page_view.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text("Recherche de l'agent..."),
        elevation: 0,
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
            margin: EdgeInsets.symmetric(horizontal: 100.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchInput(
                    controller: controller,
                    onSearched: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentPageView(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearched;
  const SearchInput({
    this.controller,
    this.onSearched,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 25.0, color: bgColor),
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                hintText: "Entrez l'identifiant de l'agent...",
                contentPadding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                hintStyle: GoogleFonts.mulish(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          Container(
            height: 80.0,
            width: 150.0,
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 0,
              color: Colors.amber[800],
              child: const Icon(
                CupertinoIcons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onSearched,
            ),
          )
        ],
      ),
    );
  }
}
