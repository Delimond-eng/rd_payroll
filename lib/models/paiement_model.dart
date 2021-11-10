class PaymentReporting {
  String nom;
  String postnom;
  String prenom;
  String numCompte;
  String mois;
  String annee;
  int montant;
  String devise;
  String datePaie;

  PaymentReporting(
      {this.nom,
      this.postnom,
      this.prenom,
      this.numCompte,
      this.mois,
      this.annee,
      this.montant,
      this.devise,
      this.datePaie});

  PaymentReporting.fromMap(Map<String, dynamic> json) {
    nom = json['nom'];
    postnom = json['postnom'];
    prenom = json['prenom'];
    numCompte = json['num_compte'];
    mois = json['mois'];
    annee = json['annee'];
    montant = json['montant'];
    devise = json['devise'];
    datePaie = json['date_paie'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['postnom'] = this.postnom;
    data['prenom'] = this.prenom;
    data['num_compte'] = this.numCompte;
    data['mois'] = this.mois;
    data['annee'] = this.annee;
    data['montant'] = this.montant;
    data['devise'] = this.devise;
    data['date_paie'] = this.datePaie;
    return data;
  }
}

class Payment {
  int paiementId;
  int agentId;
  int montant;
  String devise;
  String mois;
  String annee;
  String datePaie;
  int userId;
  String capture;
  String statut;

  Payment(
      {this.paiementId,
      this.agentId,
      this.montant,
      this.devise,
      this.mois,
      this.annee,
      this.datePaie,
      this.userId,
      this.capture,
      this.statut});

  Payment.fromMap(Map<String, dynamic> data) {
    paiementId = data['paiement_id'];
    agentId = data['agent_id'];
    montant = data['montant'];
    mois = data['mois'];
    annee = data['annee'];
    devise = data['devise'];
    datePaie = data['date_paie'];
    userId = data['id_utilisateur'];
    capture = data['capture'];
    statut = data['statut'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agent_id'] = this.agentId;
    data['montant'] = this.montant;
    data['mois'] = this.mois;
    data['annee'] = this.annee;
    data['devise'] = this.devise;
    data['date_paie'] = this.datePaie;
    data['id_utilisateur'] = userId;
    data['capture'] = capture;
    data['statut'] = this.statut;
    return data;
  }
}
