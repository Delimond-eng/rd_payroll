import 'dart:convert';

import 'package:get/get.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/models/agent_model.dart';
import 'package:medpad/models/empreinte_model.dart';
import 'package:medpad/models/paiement_model.dart';
import 'package:medpad/models/user_model.dart';
import 'package:medpad/services/db_helper_service.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();

  var selected = "".obs;
  // ignore: deprecated_member_use
  var agentList = List<Agent>().obs;
  // ignore: deprecated_member_use
  var empreintesList = List<Empreinte>().obs;
  // ignore: deprecated_member_use
  var paymentReportList = List<PaymentReporting>().obs;

  var agent = Agent().obs;

  var user = User().obs;

  @override
  void onInit() {
    super.onInit();
    loadDatas();
  }

  Future<void> getListClient() async {
    try {
      await DBHelper.getClients().then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<Agent> agents =
            List<Agent>.from(i.map((model) => Agent.fromMap(model)));
        agentList.value = agents;
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
        List<Empreinte> empreintes =
            List<Empreinte>.from(i.map((e) => Empreinte.fromMap(e)));
        empreintesList.value = empreintes;
        print(empreintes.toString());
      });
    } catch (err) {
      print("error from getListFinger $err");
    }
  }

  Future<void> getPaymentReport() async {
    try {
      await DBHelper.getPaymentReporting().then((value) {
        var json = jsonEncode(value);
        Iterable i = jsonDecode(json);
        List<PaymentReporting> reports = List<PaymentReporting>.from(
          i.map(
            (e) => PaymentReporting.fromMap(e),
          ),
        );
        paymentReportList.value = reports;
      });
    } catch (err) {
      print("error from getListReport $err");
    }
  }

  Future findClientByFingerId({int fingerId}) async {
    try {
      await DBHelper.foundAgent(empreinteId: fingerId).then(
        (value) {
          var json = jsonEncode(value);
          Iterable i = jsonDecode(json);
          List<Agent> agents = List<Agent>.from(
            i.map(
              (model) => Agent.fromMap(model),
            ),
          );
          agent.value = Agent(
              nom: agents[0].nom,
              postnom: agents[0].postnom,
              prenom: agents[0].prenom,
              adresse: agents[0].adresse,
              agentId: agents[0].agentId,
              dateNaissance: agents[0].dateNaissance,
              devise: agents[0].devise,
              etatCivil: agents[0].etatCivil,
              localite: agents[0].localite,
              empreinteId: agents[0].empreinteId,
              montant: agents[0].montant,
              numCompte: agents[0].numCompte,
              photo: agents[0].photo,
              sexe: agents[0].sexe,
              idUtilisateur: agents[0].idUtilisateur,
              portable: agents[0].portable,
              signature: agents[0].signature,
              dateCreation: agents[0].dateCreation,
              statut: agents[0].statut);
        },
      );
      return "success";
    } catch (err) {
      print("error from search $err");
    }
  }

  Future<void> loadUser() async {
    try {
      await DBHelper.viewUsers().then((result) {
        var json = jsonEncode(result);
        Iterable i = jsonDecode(json);
        List<User> users =
            List<User>.from(i.map((model) => User.fromMap(model)));
        User u = User(
          userId: users[0].userId,
          nom: users[0].nom,
          montant: users[0].montant,
          montantReste: users[0].montantReste,
          devise: users[0].devise,
        );
        storage.write("user_id", users[0].userId);
        storage.write("user_name", users[0].nom);
        storage.write("montant-alloue", users[0].montant);
        storage.write("montant-restant", users[0].montantReste);
        storage.write("devise", users[0].devise);
        user.value = u;
      });
    } catch (err) {
      print("$err");
    }
  }

  Future<void> loadDatas() async {
    getPaymentReport();
    loadUser();
    getListClient();
    getListFingers();
  }
}
