import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medpad/constants/controllers.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/models/paiement_model.dart';
import 'package:medpad/widgets/user_session.dart';

class PaymentReportPage extends StatefulWidget {
  @override
  _PaymentReportPageState createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  String selectedMonth;
  String selectedYear;
  @override
  Widget build(BuildContext context) {
    var _style = GoogleFonts.mulish(
        color: bgColor, fontWeight: FontWeight.w700, fontSize: 18.0);
    return Scaffold(
        appBar: AppBar(
          title: Text("Payements reporting"),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30.0),
                physics: BouncingScrollPhysics(),
                child: PaginatedDataTable(
                    dataRowHeight: 60.0,
                    arrowHeadColor: bgColor,
                    header: Row(
                      children: [
                        Icon(
                          Icons.table_chart,
                          color: bgColor,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Reporting",
                          style: GoogleFonts.mulish(
                              color: bgColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    rowsPerPage: 4,
                    columns: [
                      DataColumn(
                          label: Text(
                        "Nom",
                        style: _style,
                      )),
                      DataColumn(label: Text("Post-nom", style: _style)),
                      DataColumn(label: Text("Prénom", style: _style)),
                      DataColumn(label: Text("Matricule", style: _style)),
                      DataColumn(label: Text("Mois", style: _style)),
                      DataColumn(label: Text("Année", style: _style)),
                      DataColumn(label: Text("Montant", style: _style)),
                      DataColumn(label: Text("Devise", style: _style)),
                      DataColumn(label: Text("Date paiement", style: _style)),
                    ],
                    source: _DataSource(context)),
              ),
            ),
          ),
        ));
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  List<PaymentReporting> _rows;
  _DataSource(this.context) {
    _rows = apiController.paymentReportList;
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= _rows.length) return null;

    final _row = _rows[index];

    return DataRow.byIndex(index: index, selected: false, cells: [
      DataCell(Text(_row.nom)),
      DataCell(Text(_row.postnom)),
      DataCell(Text(_row.prenom)),
      DataCell(Text(_row.numCompte)),
      DataCell(Text(_row.mois)),
      DataCell(Text(_row.annee)),
      DataCell(Text('${_row.montant}')),
      DataCell(Text('${_row.devise}')),
      DataCell(Text('${_row.datePaie}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => _selectedCount;
}
