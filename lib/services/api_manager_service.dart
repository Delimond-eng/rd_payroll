import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as Api;
import 'package:medpad/models/sync_data_model.dart';

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

  static Future inPutData({String content}) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = "file.json";

    var res;

    File file = new File(tempPath + "/" + filename);
    file.createSync();
    file.writeAsStringSync(content);
    try {
      var request =
          Api.MultipartRequest('POST', Uri.parse("$baseURL/data/sync/in"));
      request.files.add(
        Api.MultipartFile.fromBytes(
          'jsonfile',
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
