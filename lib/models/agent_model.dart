class Agent {
  int agentId;
  String numCompte;
  String nom;
  String postnom;
  String prenom;
  String portable;
  String sexe;
  String etatCivil;
  String adresse;
  String localite;
  String dateNaissance;
  String montant;
  String devise;
  String photo;
  String signature;
  int empreinteId;
  String statut;
  String dateCreation;
  int idUtilisateur;

  Agent(
      {this.agentId,
      this.numCompte,
      this.nom,
      this.postnom,
      this.prenom,
      this.portable,
      this.sexe,
      this.etatCivil,
      this.adresse,
      this.localite,
      this.dateNaissance,
      this.montant,
      this.devise,
      this.photo,
      this.signature,
      this.empreinteId,
      this.statut,
      this.dateCreation,
      this.idUtilisateur});

  Agent.fromMap(Map<String, dynamic> json) {
    agentId = json['agent_id'];
    numCompte = json['num_compte'];
    nom = json['nom'];
    postnom = json['postnom'];
    prenom = json['prenom'];
    portable = json['portable'];
    sexe = json['sexe'];
    etatCivil = json['etat_civil'];
    adresse = json['adresse'];
    localite = json['localite'];
    dateNaissance = json['date_naissance'];
    montant = json['montant'];
    devise = json['devise'];
    photo = json['photo'];
    signature = json['signature'];
    empreinteId = json['empreinte_id'];
    statut = json['statut'];
    dateCreation = json['date_creation'];
    idUtilisateur = json['id_utilisateur'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_compte'] = this.numCompte;
    data['nom'] = this.nom;
    data['postnom'] = this.postnom;
    data['prenom'] = this.prenom;
    data['portable'] = this.portable;
    data['sexe'] = this.sexe;
    data['etat_civil'] = this.etatCivil;
    data['adresse'] = this.adresse;
    data['localite'] = this.localite;
    data['date_naissance'] = this.dateNaissance;
    data['montant'] = this.montant;
    data['devise'] = this.devise;
    data['photo'] = this.photo;
    data['signature'] = this.signature;
    data['empreinte_id'] = this.empreinteId;
    data['statut'] = this.statut;
    data['date_creation'] = this.dateCreation;
    data['id_utilisateur'] = this.idUtilisateur;
    return data;
  }
}
