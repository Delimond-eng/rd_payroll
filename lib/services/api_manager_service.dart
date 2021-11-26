import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as Api;
import 'package:medpad/models/sync_data_model.dart';
import 'package:medpad/services/db_helper_service.dart';

class ApiManagerService {
  static final String baseURL = "http://gsa-central-server.rtgroup-rdc.com";

  static Future<SynchroneDatas> getDatas() async {
    final response = await Api.get(
      Uri.parse("$baseURL/data/sync/out"),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return SynchroneDatas.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future inPutData() async {
    var sql1 = await DBHelper.query(
        sql:
            "SELECT beneficiaire_id, photo, signature_capture FROM beneficiaires");

    var sql2 = await DBHelper.query(
        sql:
            "SELECT beneficiaire_id, empreinte_1,empreinte_2,empreinte_3 FROM empreintes INNER JOIN beneficiaires ON empreintes.empreinte_id = beneficiaires.empreinte_id");
    var sql3 = await DBHelper.query(sql: "SELECT paiement_id FROM paiements");

    var sql4 = await DBHelper.query(
        sql:
            "SELECT paiement_id, preuve_1,preuve_2,preuve_3,preuve_4 FROM paiements");
    String json = jsonEncode({
      'beneficiaires': sql1,
      'empreintes': sql2,
      'paiements': sql3,
      'paiement_preuves': sql4
    });

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = "file.json";

    var res;

    File file = new File(tempPath + "/" + filename);
    file.createSync();
    file.writeAsStringSync(json);
    try {
      var request =
          Api.MultipartRequest('POST', Uri.parse("$baseURL/data/sync/in"));

      //request.fields['agent_id'] = "1";

      request.files.add(
        Api.MultipartFile.fromBytes(
          'data',
          file.readAsBytesSync(),
          filename: filename.split("/").last,
        ),
      );
      request
          .send()
          .then((result) async {
            Api.Response.fromStream(result).then((response) {
              if (response.statusCode == 200) {
                res = response.body;
                print(response.body);
              }
            });
          })
          .catchError((err) => print('error : ' + err.toString()))
          .whenComplete(() {});
    } catch (err) {
      print("error from $err");
    }
    if (res == null) {
      return null;
    } else {
      return res;
    }
  }
}
