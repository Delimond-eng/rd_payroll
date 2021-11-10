import 'package:medpad/services/cryptage_service.dart';

class User{
  int userId;
  String nom, email, password;
  String dateCreation;
  int montant;
  String devise;
  int montantReste;
  int idReserve;
  String statut;

  User({this.userId, this.nom, this.email, this.password, this.dateCreation, this.montant, this.devise, this.montantReste, this.idReserve, this.statut});

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["nom"] = this.nom;
    data["email"] = this.email;
    data["pass"] = GxdCryptor.encrypt(this.password);
    data["date_creation"] = this.dateCreation;
    data["montant"] = this.montant;
    data["devise"] = this.devise;
    data["montant_reste"] = this.montantReste;
    data["id_reserve"] = this.idReserve;
    data["statut"] = this.statut;
    return data;
  }


  User.fromMap(Map<String, dynamic> map){
    userId = map['utilisateur_id'];
    nom = map['nom'];
    email = map['email'];
    password = map['pass'];
    montant = map['montant'];
    devise = map['devise'];
    montantReste = map['montant_reste'];
    idReserve = map['id_reserve'];
    statut = map['statut'];
  }
}