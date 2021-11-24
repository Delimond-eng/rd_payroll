import 'dart:convert';

import 'package:get/get.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/models/beneficiaires_model.dart';
import 'package:medpad/models/sync_data_model.dart';
import 'package:medpad/services/db_helper_service.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();

  var selected = "".obs;

  var agent = Agents().obs;

  var benefiaire = Beneficiaire().obs;

  var activite = Activites().obs;

  var paieInfo = Paiements().obs;

  // ignore: deprecated_member_use
  var empreintesList = List<Empreintes>().obs;

  @override
  void onInit() {
    super.onInit();
    loadDatas();
  }

  Future<void> getListClient() async {
    try {
      await DBHelper.viewDatas(tableName: "beneficiaires").then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<Beneficiaire> list =
            List<Beneficiaire>.from(i.map((e) => Beneficiaire.fromJson(e)));
        print(list.length);
      });
    } catch (err) {
      print("error from getListClient $err");
    }
  }

  Future<void> getListFingers() async {
    try {
      await DBHelper.getAllFingers().then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<Empreintes> empreintes =
            List<Empreintes>.from(i.map((e) => Empreintes.fromJson(e)));
        empreintesList.value = empreintes;
      });
    } catch (err) {
      print("error from getListFinger $err");
    }
  }

  Future<void> getPaymentInfo() async {
    try {} catch (err) {
      print("error from getListReport $err");
    }
  }

  Future findClientByFingerId({String fingerId}) async {
    try {} catch (err) {
      print("error from search $err");
    }
  }

  Future<void> loadUser() async {
    try {} catch (err) {
      print("$err");
    }
  }

  Future<void> loadDatas() async {}
}
