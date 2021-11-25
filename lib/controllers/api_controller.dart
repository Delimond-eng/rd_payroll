import 'dart:convert';

import 'package:get/get.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/models/beneficiaires_model.dart';
import 'package:medpad/models/site_model.dart';
import 'package:medpad/models/sync_data_model.dart';
import 'package:medpad/services/db_helper_service.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();

  var selected = "".obs;

  var agent = Agents().obs;

  var benefiaire = Beneficiaire().obs;

  var activite = Activites().obs;

  // ignore: deprecated_member_use
  var sites = List<Sites>().obs;
  // ignore: deprecated_member_use
  var activites = List<Activites>().obs;

  var montantGlobalPayer = 0.0.obs;

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
    String response = "";
    try {
      await DBHelper.find(
              checkId: fingerId, tableName: "empreintes", where: "empreinte_id")
          .then((res) async {
        if (res.isNotEmpty) {
          await DBHelper.find(
                  checkId: fingerId,
                  tableName: "beneficiaires",
                  where: "empreinte_id")
              .then((data) {
            if (data.isNotEmpty) {
              var json = jsonEncode(data);
              Iterable i = jsonDecode(json);
              List<Beneficiaire> list = List<Beneficiaire>.from(
                  i.map((e) => Beneficiaire.fromJson(e)));
              benefiaire.value = list[0];
              response = "success";
            }
          });
        } else {
          response = "";
        }
      });
    } catch (err) {
      print("error from search $err");
    }
    return response;
  }

  Future<void> getActivity(String id) async {
    try {
      await DBHelper.viewDatas(tableName: "activites").then((res) {
        var json = jsonEncode(res);
        Iterable i = jsonDecode(json);
        List<Activites> list =
            List<Activites>.from(i.map((e) => Activites.fromJson(e)));
        storage.write("activite_id", list[0].activiteId);
        list.forEach((a) async {
          if (a.activiteId == id) {
            activite.value = list[0];
            double amount = 0;
            await DBHelper.getPaieReport().then((res) {
              res.forEach((map) {
                amount += double.parse(map['netapayer']);
                montantGlobalPayer.value = amount;
              });
            });
          }
        });
      });
    } catch (err) {
      print("$err");
    }
  }

  Future<void> loadDatas() async {
    try {
      await DBHelper.viewDatas(tableName: "sites").then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<Sites> list = List<Sites>.from(i.map((e) => Sites.fromJson(e)));
        sites.value = list;
      });
    } catch (err) {
      print("error from loading data $err");
    }
  }
}
