import 'dart:convert';

import 'package:http/http.dart' as Api;
import 'package:medpad/helpers/data_storage.dart';

class ApiManagerService {
  static final String baseURL = "http://medpad.rtgroup-rdc.com";

  static Future createHospitalAccount(
      {nom, tel, province, ville, adresse, pwd, email}) async {
    final response = await Api.post(
      Uri.parse("$baseURL/hopitals/compte/register"),
      body: jsonEncode(
        <String, dynamic>{
          "nom": nom,
          "telephone": tel,
          "province": province,
          "ville": ville,
          "adresse": adresse,
          "email": email,
          "pass": pwd
        },
      ),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var status = jsonResponse["reponse"]["status"];

      if (status == "success" && status != null) {
        var hName = jsonResponse["reponse"]["data"]["nom"];
        var hId = jsonResponse["reponse"]["data"]["hopital_id"];
        storage.write("hospital_name", hName);
        storage.write("hospital_id", hId);
        return jsonResponse;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
