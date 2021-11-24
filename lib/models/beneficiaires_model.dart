class Beneficiaire {
  int id;
  String beneficiaireId;
  String numCompte;
  String nom;
  String telephone;
  String matricule;
  String sexe;
  String etatCivil;
  String dateNais;
  String empreinteId;
  String photo;
  String signature;
  String ayantDroit;
  String netApayer;
  String devise;
  Beneficiaire(
      {this.id,
      this.beneficiaireId,
      this.numCompte,
      this.nom,
      this.telephone,
      this.matricule,
      this.sexe,
      this.etatCivil,
      this.dateNais,
      this.empreinteId,
      this.photo,
      this.signature,
      this.ayantDroit,
      this.netApayer,
      this.devise});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beneficiaire_id'] = beneficiaireId;
    data['num_compte'] = numCompte;
    data['matricule'] = matricule;
    data['nom'] = nom;
    data['telephone'] = telephone;
    data['netapayer'] = netApayer;
    data['sexe'] = sexe;
    data['etat_civil'] = etatCivil;
    data['date_naissance'] = dateNais;
    data['empreinte_id'] = empreinteId;
    data['photo'] = photo;
    data['signature'] = signature;
    data['ayant_droit'] = ayantDroit;
    data['devise'] = devise;
    return data;
  }

  Beneficiaire.fromJson(Map<String, dynamic> data) {
    beneficiaireId = data['beneficiaire_id'];
    numCompte = data['num_compte'];
    nom = data['nom'];
    telephone = data['telephone'];
    matricule = data['matricule'];
    netApayer = data['netapayer'];
    devise = data['devise'];
    sexe = data['sexe'];
    data['etat_civil'] = etatCivil;
    dateNais = data['date_naissance'];
    empreinteId = data['empreinte_id'];
    photo = data['photo'];
    signature = data['signature_capture'];
    ayantDroit = data['ayant_droit'];
  }
}
