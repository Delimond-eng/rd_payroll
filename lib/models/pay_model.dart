class PayModel {
  int id;
  String paiementId;
  String preuve1;
  String preuve2;
  String preuve3;
  String preuve4;
  String preuve5;
  String preuve6;

  PayModel({
    this.id,
    this.paiementId,
    this.preuve1,
    this.preuve2,
    this.preuve3,
    this.preuve4,
    this.preuve5,
    this.preuve6,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["paiement_id"] = paiementId;
    data["preuve_1"] = preuve1;
    data["preuve_2"] = preuve2;
    data["preuve_3"] = preuve3;
    data["preuve_4"] = preuve4;
    data["preuve_5"] = preuve5;
    data["preuve_6"] = preuve6;
    return data;
  }

  PayModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    paiementId = data["paiement_id"];
    preuve1 = data["preuve_1"];
    preuve2 = data["preuve_2"];
    preuve3 = data["preuve_3"];
    preuve4 = data["preuve_4"];
    preuve5 = data["preuve_5"];
    preuve6 = data["preuve_6"];
  }
}
