import 'dart:async';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/models/pay_model.dart';
import 'package:medpad/models/sync_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'rd_technologic.db';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int version) async {
    try {
      await db.transaction((txn) async {
        await txn.execute(
            "CREATE TABLE agents(id INTEGER PRIMARY KEY AUTOINCREMENT, agent_id TEXT, nom TEXT, telephone TEXT, pass TEXT, email TEXT)");
        await txn.execute(
            "CREATE TABLE beneficiaires(id INTEGER PRIMARY KEY AUTOINCREMENT, beneficiaire_id TEXT, num_compte TEXT, nom TEXT, telephone TEXT,matricule TEXT, netapayer TEXT, devise TEXT, sexe TEXT, etat_civil TEXT, date_naissance TEXT, empreinte_id TEXT, photo TEXT, signature_capture TEXT, ayant_droit TEXT)");
        await txn.execute(
            "CREATE TABLE activites(id INTEGER PRIMARY KEY AUTOINCREMENT, activite_id TEXT, montant_budget TEXT,devise TEXT, telephone_representant TEXT, site_id TEXT)");
        await txn.execute(
            "CREATE TABLE sites(id INTEGER PRIMARY KEY AUTOINCREMENT,site_id TEXT, site TEXT, province TEXT)");
        await txn.execute(
            "CREATE TABLE empreintes(id INTEGER PRIMARY KEY AUTOINCREMENT, empreinte_id TEXT, empreinte_1 TEXT, empreinte_2 TEXT, empreinte_3 TEXT)");
        await txn.execute(
            "CREATE TABLE paiements(id INTEGER PRIMARY KEY AUTOINCREMENT, paiement_id TEXT, preuve_1 TEXT, preuve_2 TEXT, preuve_3 TEXT,preuve_4 TEXT, preuve_5 TEXT, preuve_6 TEXT)");
      });
    } catch (err) {
      print("error from transaction");
    }
  }

  static Future registerUser(Agents user) async {
    var dbClient = await db;
    var lastInsertId;

    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
          "INSERT INTO agents(agent_id, nom, telephone,pass, email) VALUES(?,?,?,?,?)",
          [
            user.agentId,
            user.nom,
            user.telephone,
            user.pass,
            user.email,
          ],
        );
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from agents insert void $e");
    }

    if (lastInsertId == null) {
      print("null");
    }
    print("success $lastInsertId");
  }

  static Future enregistrerSites(Activites s) async {
    var dbClient = await db;
    var lastInsertId;

    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
            "INSERT INTO sites(site_id, site, province) VALUES(?,?,?)", [
          s.siteId,
          s.site,
          s.province,
        ]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from site insert void $e");
    }

    if (lastInsertId == null) {
      print("null");
      return;
    }
    print("success $lastInsertId");
  }

  static Future enregistrerActivites(Activites s) async {
    var dbClient = await db;
    var lastInsertId;
    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
            "INSERT INTO activites(activite_id, montant_budget, devise, telephone_representant, site_id) VALUES(?,?,?,?,?)",
            [
              s.activiteId,
              s.montantBudget,
              'CDF',
              s.telephoneRepresentant,
              s.siteId
            ]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from site insert void $e");
    }
    print("success $lastInsertId");
  }

  static Future viewDatas({String tableName}) async {
    var dbClient = await db;
    var map;

    try {
      await dbClient.transaction((txn) async {
        map = await txn.query(tableName);
      });
    } catch (err) {
      print("error from view beneficiaire void $err");
    }
    if (map == null) {
      return null;
    }
    return map;
  }

  static Future loginUser({Agents user}) async {
    var dbClient = await db;

    var map;
    try {
      map = await dbClient.query("agents",
          where: "telephone=? AND pass=?",
          whereArgs: [user.telephone, user.pass]);
    } catch (e) {
      print("error from $e");
    }
    return map;
  }

  static Future viewUsers() async {
    var dbClient = await db;
    int userId = storage.read('agent_id');
    return await dbClient
        .query("agents", where: "agent_id=?", whereArgs: [userId]);
  }

  static Future enregistrerEmpreintes(
      {Empreintes empreinte, Paiements paiement, String id}) async {
    var dbClient = await db;
    int lastUpdateId;

    try {
      await dbClient.transaction((txn) async {
        int empreinteId = await txn.insert("empreintes", empreinte.toJson());
        if (empreinteId != null) {
          lastUpdateId = await txn.rawUpdate(
              "UPDATE beneficiaires SET empreinte_id = ?, photo = ?, signature_capture = ? WHERE beneficiaire_id=?",
              ['$empreinteId', paiement.photo, paiement.signatureCapture, id]);
        }
      });
    } catch (err) {
      print('error from updating data!');
    }

    if (lastUpdateId == null) {
      return null;
    }
    return lastUpdateId;
  }

  static Future checkDatas(
      {String checkId, String where, String tableName}) async {
    var dbClient = await db;
    var map;
    try {
      await dbClient.transaction((txn) async {
        map =
            await txn.query(tableName, where: "$where=?", whereArgs: [checkId]);
      });
    } catch (e) {
      print("error from check beneficiaire $e");
    }
    if (map.isEmpty) {
      return "0";
    } else {
      return "1";
    }
  }

  static Future find({String checkId, String where, String tableName}) async {
    var dbClient = await db;
    var map;
    try {
      await dbClient.transaction((txn) async {
        map =
            await txn.query(tableName, where: "$where=?", whereArgs: [checkId]);
      });
    } catch (e) {
      print("error from check beneficiaire $e");
    }
    if (map.isEmpty) {
      return map;
    } else {
      return null;
    }
  }

  static Future enregistrerBeneficiaire({Paiements paiement}) async {
    var dbClient = await db;
    var lastInsertId;
    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();

        batch.rawInsert(
            "INSERT INTO beneficiaires(beneficiaire_id, num_compte, nom, netapayer,devise, telephone,matricule, sexe, etat_civil, date_naissance, empreinte_id, photo, signature_capture, ayant_droit) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              paiement.beneficiaireId,
              paiement.numCompte,
              paiement.nom,
              paiement.netApayer,
              paiement.devise,
              paiement.telephone,
              paiement.matricule,
              paiement.sexe,
              paiement.etatCivil,
              paiement.dateNaissance,
              paiement.empreinteId,
              paiement.photo,
              paiement.signatureCapture,
              paiement.ayantDroit
            ]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from register beneficiaire $e");
    }

    print("success $lastInsertId");
  }

  static Future effectuerPaiement({PayModel paie}) async {
    var dbClient = await db;
    var lastInsertedId;
    try {
      await dbClient.transaction((txn) async {
        lastInsertedId = await txn.insert("paiements", paie.toJson());
      });
    } catch (err) {
      print("error from payment statment $err");
    }

    if (lastInsertedId == null) return null;
    return lastInsertedId;
  }

  static Future scannerBeneficiaire({String empreinteId}) async {
    var dbClient = await db;
    return await dbClient.query('beneficiaires',
        where: 'empreinte_id=?', whereArgs: ['$empreinteId']);
  }

  static Future getAllFingers() async {
    var dbClient = await db;
    return await dbClient.query('empreintes');
  }

  static Future getPaymentReporting() async {
    var dbClient = await db;
    var list = await dbClient.rawQuery(
        "SELECT agents.nom, agents.postnom, agents.prenom, agents.num_compte, paiements.mois,paiements.annee, paiements.montant, paiements.devise,paiements.date_paie FROM paiements INNER JOIN agents ON paiements.agent_id=agents.agent_id ORDER BY paiements.paiement_id DESC");
    print(list);
    return list;
  }

  static Future getBeneficiaires() async {
    var dbClient = await db;
    var list = await dbClient.query("beneficiaires", orderBy: "id DESC");
    return list;
  }

  static Future delete(int id) async {
    var dbClient = await db;
    // Delete a record
    int count = await dbClient
        .rawDelete('DELETE FROM agents WHERE agent_id = ?', ['$id']);
    print(count);
  }
}
