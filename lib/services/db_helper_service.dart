import 'dart:async';
import 'package:get/get.dart';
import 'package:medpad/constants/style.dart';
import 'package:medpad/helpers/data_storage.dart';
import 'package:medpad/models/agent_model.dart';
import 'package:medpad/models/empreinte_model.dart';
import 'package:medpad/models/paiement_model.dart';
import 'package:medpad/models/user_model.dart';
import 'package:medpad/services/cryptage_service.dart';
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
    print("init db");
    try {
      await db.transaction((txn) async {
        await txn.execute(
            "CREATE TABLE agents(agent_id INTEGER PRIMARY KEY AUTOINCREMENT, num_compte TEXT, nom TEXT, postnom TEXT, prenom TEXT, portable TEXT, sexe TEXT, etat_civil TEXT, adresse TEXT, localite TEXT, date_naissance TEXT, montant TEXT, devise TEXT, photo TEXT, signature TEXT, empreinte_id INTEGER, statut TEXT, date_creation TEXT, id_utilisateur INTEGER)");
        await txn.execute(
            "CREATE TABLE empreinte(empreinte_id INTEGER PRIMARY KEY AUTOINCREMENT, empreinte_1 TEXT, empreinte_2 TEXT, empreinte_3 TEXT)");
        await txn.execute(
            "CREATE TABLE paiements(paiement_id INTEGER PRIMARY KEY AUTOINCREMENT, agent_id INTEGER, montant INTEGER, devise TEXT, mois TEXT, annee TEXT, date_paie TEXT, id_utilisateur INTEGER, capture TEXT, statut TEXT)");
        await txn.execute(
            "CREATE TABLE reserve(reserve_id INTEGER PRIMARY KEY AUTOINCREMENT, montant INTEGER, devise TEXT, reste INTEGER, montantatt INTEGER, mois TEXT, annee TEXT, date_creation TEXT, statut TEXT)");
        await txn.execute(
            "CREATE TABLE utilisateurs(utilisateur_id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, email TEXT, pass TEXT, date_creation TEXT, montant INTEGER, devise TEXT, montant_reste INTEGER, id_reserve INTEGERT, statut TEXT)");
      });
    } catch (err) {
      print("error from transaction");
    }
  }

  static Future registerUser() async {
    var dbClient = await db;
    int userId;
    User user = User(
        email: "rtgroup@gmail.com",
        montant: 300000,
        devise: "FC",
        dateCreation: formatDate(DateTime.now()),
        nom: "RT GROUP",
        montantReste: 300000,
        statut: "actif",
        password: "12345",
        idReserve: 1);
    await dbClient.transaction((txn) async {
      List<Map> map = await txn.query("utilisateurs");
      if (map.isEmpty) {
        userId = await txn.insert("utilisateurs", user.toMap());
      } else {
        print("user exist!");
      }
    });
    storage.write("user_id", userId);
    print("user id: $userId");
  }

  static Future loginUser({User user}) async {
    var dbClient = await db;
    String pwd = GxdCryptor.encrypt(user.password);
    String userEmail = user.email;
    return await dbClient.query("utilisateurs",
        where: "email=? AND pass=?", whereArgs: ['$userEmail', '$pwd']);
  }

  static Future viewUsers() async {
    var dbClient = await db;
    int userId = storage.read('user_id');
    return await dbClient
        .query("utilisateurs", where: "utilisateur_id=?", whereArgs: [userId]);
  }

  /*static Future savePictures({String photo, String signature}) async{
    var dbClient = await db;
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['picture_photo'] = photo;
    map['picture_signature'] = signature;
    int pictureId = await dbClient.insert("pictures", map);
    return pictureId;
  }

  static Future viewPictures() async{
    var dbClient = await db;
    return dbClient.query("pictures");
  }*/

  static Future saveAgent({Empreinte empreinte, Agent agent}) async {
    var dbClient = await db;
    var lastInsertId;
    await dbClient.transaction((txn) async {
      try {
        int empreinte_id = await txn.insert("empreinte", empreinte.toMap());
        if (empreinte_id != null) {
          agent.empreinteId = empreinte_id;
          int userId = storage.read("user_id");
          agent.idUtilisateur = userId;
          lastInsertId = await txn.insert("agents", agent.toMap());
        }
      } catch (err) {
        print("statment err $err");
      }
    });
    return lastInsertId;
  }

  static Future savePaiement({Payment payment}) async {
    var dbClient = await db;
    int lastInsertId;
    await dbClient.transaction((txn) async {
      try {
        int userId = storage.read("user_id");
        payment.userId = userId;
        //stmt insert finger firstly
        lastInsertId = await txn.insert("paiements", payment.toMap());
        if (lastInsertId != null) {
          List<Map> map = await txn.query("utilisateurs",
              where: "utilisateur_id = ?", whereArgs: ['$userId']);
          if (map.isNotEmpty) {
            List<User> user = [];
            user.add(User.fromMap(map[0]));
            if (payment.montant <= user[0].montantReste) {
              int updateAmount = (user[0].montantReste - payment.montant);
              int update = await txn.rawUpdate(
                  "UPDATE utilisateurs SET montant_reste=? WHERE utilisateur_id=?",
                  ['$updateAmount', '$userId']);
              print(update);
            }
          }
        }
      } catch (err) {
        print("payment statment error $err");
      }
    });
    if (lastInsertId != null) {
      return lastInsertId;
    } else {
      return null;
    }
  }

  static Future foundAgent({int empreinteId}) async {
    var dbClient = await db;
    return await dbClient
        .query('agents', where: 'empreinte_id=?', whereArgs: ['$empreinteId']);
  }

  static Future getAllFingers() async {
    var dbClient = await db;
    return await dbClient.query('empreinte');
  }

  static Future getPaymentReporting() async {
    var dbClient = await db;
    var list = await dbClient.rawQuery(
        "SELECT agents.nom, agents.postnom, agents.prenom, agents.num_compte, paiements.mois,paiements.annee, paiements.montant, paiements.devise,paiements.date_paie FROM paiements INNER JOIN agents ON paiements.agent_id=agents.agent_id ORDER BY paiements.paiement_id DESC");
    print(list);
    return list;
  }

  static Future getClients() async {
    var dbClient = await db;
    var list = await dbClient.query("agents", orderBy: "agent_id DESC");
    print(list);
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
