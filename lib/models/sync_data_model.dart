class SynchroneDatas {
  Data data;

  SynchroneDatas({this.data});

  SynchroneDatas.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Agents> agents;
  List<Activites> activites;

  Data({this.agents, this.activites});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['agents'] != null) {
      agents = new List<Agents>();
      json['agents'].forEach((v) {
        agents.add(new Agents.fromJson(v));
      });
    }
    if (json['activites'] != null) {
      activites = new List<Activites>();
      json['activites'].forEach((v) {
        activites.add(new Activites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agents != null) {
      data['agents'] = this.agents.map((v) => v.toJson()).toList();
    }
    if (this.activites != null) {
      data['activites'] = this.activites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agents {
  String agentId;
  String adminId;
  String nom;
  String email;
  String telephone;
  String pass;
  String photo;
  String agentStatus;
  String empreinteId;
  String dateEnregistrement;

  Agents(
      {this.agentId,
      this.adminId,
      this.nom,
      this.email,
      this.telephone,
      this.pass,
      this.photo,
      this.agentStatus,
      this.empreinteId,
      this.dateEnregistrement});

  Agents.fromJson(Map<String, dynamic> json) {
    agentId = json['agent_id'];
    adminId = json['admin_id'];
    nom = json['nom'];
    email = json['email'];
    telephone = json['telephone'];
    pass = json['pass'];
    photo = json['photo'];
    agentStatus = json['agent_status'];
    empreinteId = json['empreinte_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agent_id'] = this.agentId;
    data['nom'] = this.nom;
    data['email'] = this.email;
    data['telephone'] = this.telephone;
    data['pass'] = this.pass;
    data['photo'] = this.photo;
    ;
    data['empreinte_id'] = this.empreinteId;
    return data;
  }
}

class Activites {
  int id;
  String activiteId;
  String siteId;
  String montantBudget;
  String devise;
  String nomRepresentant;
  String telephoneRepresentant;
  String site;
  String province;
  List<Paiements> paiements;

  Activites(
      {this.id,
      this.activiteId,
      this.siteId,
      this.montantBudget,
      this.nomRepresentant,
      this.telephoneRepresentant,
      this.site,
      this.province,
      this.paiements});

  Activites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activiteId = json['activite_id'];
    siteId = json['site_id'];
    montantBudget = json['montant_budget'];
    devise = json['devise'];
    nomRepresentant = json['nom_representant'];
    telephoneRepresentant = json['telephone_representant'];
    site = json['site'];
    province = json['province'];
    if (json['paiements'] != null) {
      paiements = new List<Paiements>();
      json['paiements'].forEach((v) {
        paiements.add(new Paiements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activite_id'] = this.activiteId;
    data['site_id'] = this.siteId;
    data['montant_budget'] = this.montantBudget;
    data['nom_representant'] = this.nomRepresentant;
    data['devise'] = this.devise;
    data['telephone_representant'] = this.telephoneRepresentant;
    data['site'] = this.site;
    data['province'] = this.province;
    if (this.paiements != null) {
      data['paiements'] = this.paiements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paiements {
  int id;
  String paiementId;
  String societe;
  String netApayer;
  String devise;
  String beneficiaireId;
  String numCompte;
  String nom;
  String matricule;
  String telephone;
  String sexe;
  String etatCivil;
  String dateNaissance;
  String empreinteId;
  String photo;
  String signatureCapture;
  String ayantDroit;
  List<Empreintes> empreintes;

  Paiements(
      {this.id,
      this.paiementId,
      this.societe,
      this.netApayer,
      this.devise,
      this.beneficiaireId,
      this.numCompte,
      this.nom,
      this.matricule,
      this.telephone,
      this.sexe,
      this.etatCivil,
      this.dateNaissance,
      this.empreinteId,
      this.photo,
      this.signatureCapture,
      this.ayantDroit,
      this.empreintes});

  Paiements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paiementId = json['paiement_id'];
    societe = json['societe'];
    netApayer = json['netapayer'];
    devise = json['devise'];
    beneficiaireId = json['beneficiaire_id'];
    numCompte = json['num_compte'];
    matricule = json['matricule'];
    nom = json['nom'];
    telephone = json['telephone'];
    sexe = json['sexe'];
    etatCivil = json['etat_civil'];
    dateNaissance = json['date_naissance'];
    empreinteId = json['empreinte_id'];
    photo = json['photo'];
    signatureCapture = json['signature_capture'];
    ayantDroit = json['ayant_droit'];
    if (json['empreintes'] != null) {
      empreintes = new List<Empreintes>();
      json['empreintes'].forEach((v) {
        empreintes.add(new Empreintes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paiement_id'] = this.paiementId;
    data['societe'] = this.societe;
    data['netapayer'] = this.netApayer;
    data['devise'] = this.devise;
    data['beneficiaire_id'] = this.beneficiaireId;
    data['num_compte'] = this.numCompte;
    data['matricule'] = this.matricule;
    data['nom'] = this.nom;
    data['telephone'] = this.telephone;
    data['sexe'] = this.sexe;
    data['etat_civil'] = this.etatCivil;
    data['date_naissance'] = this.dateNaissance;
    data['empreinte_id'] = this.empreinteId;
    data['photo'] = this.photo;
    data['signature_capture'] = this.signatureCapture;
    data['ayant_droit'] = this.ayantDroit;
    if (this.empreintes != null) {
      data['empreintes'] = this.empreintes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Empreintes {
  int id;
  String empreinteId;
  String empreinte1;
  String empreinte2;
  String empreinte3;

  Empreintes(
      {this.id,
      this.empreinteId,
      this.empreinte1,
      this.empreinte2,
      this.empreinte3});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empreinte_id'] = this.empreinteId;
    data['empreinte_1'] = this.empreinte1;
    data['empreinte_2'] = this.empreinte2;
    data['empreinte_3'] = this.empreinte3;
    return data;
  }

  Empreintes.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    empreinte1 = map['empreinte_1'];
    empreinte2 = map['empreinte_2'];
    empreinte3 = map['empreinte_3'];
    empreinteId = map['empreinte_id'];
  }
}
