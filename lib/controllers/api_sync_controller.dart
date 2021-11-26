import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:medpad/models/sync_data_model.dart';
import 'package:medpad/services/api_manager_service.dart';
import 'package:medpad/services/db_helper_service.dart';

class ApiSyncController extends GetxController {
  static ApiSyncController instance = Get.find();

  var data = Data().obs;

  var isSyncData = false.obs;

  StreamSubscription<DataConnectionStatus> listener;

  @override
  void onInit() {
    super.onInit();
    getDatas();
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  Future<void> getDatas() async {
    listener = DataConnectionChecker().onStatusChange.listen((status) async {
      if (status == DataConnectionStatus.connected) {
        await loadDataFromServer();
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  Future<void> loadDataFromServer() async {
    EasyLoading.show(
      status: "Patientez!\nLa synchronisation de données en cours...",
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
    var d = await ApiManagerService.getDatas();
    d.data.agents.forEach((e) async {
      var checkMap = await DBHelper.checkDatas(
          checkId: e.agentId, tableName: "agents", where: "agent_id");
      if (checkMap == "0") {
        await DBHelper.registerUser(e);
      }
    });
    if (d.data.activites.isEmpty) {
      EasyLoading.dismiss();
      return;
    }

    d.data.activites.forEach((e) async {
      var checkMapActivity = await DBHelper.checkDatas(
          checkId: e.activiteId, tableName: "activites", where: "activite_id");
      if (checkMapActivity == "0") {
        await DBHelper.enregistrerActivites(e);
      }

      var checkSite = await DBHelper.checkDatas(
          checkId: e.siteId, tableName: "sites", where: "site_id");
      if (checkSite == "0") {
        await DBHelper.enregistrerSites(e);
      }

      for (int j = 0; j < e.paiements.length; j++) {
        var checkMap = await DBHelper.checkDatas(
            checkId: e.paiements[j].beneficiaireId,
            tableName: "beneficiaires",
            where: "beneficiaire_id");
        if (checkMap == "0") {
          await DBHelper.enregistrerBeneficiaire(paiement: e.paiements[j]);
        }
      }
      await ApiManagerService.inPutData();
      EasyLoading.dismiss();
    });

    data.value = d.data;
  }
}
