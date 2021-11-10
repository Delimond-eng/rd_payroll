
class Empreinte {
  int empreinteId;
  String empreinte1;
  String empreinte2;
  String empreinte3;

  Empreinte(
      {this.empreinteId, this.empreinte1, this.empreinte2, this.empreinte3});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empreinte_id'] = this.empreinteId;
    data['empreinte_1'] = this.empreinte1;
    data['empreinte_2'] = this.empreinte2;
    data['empreinte_3'] = this.empreinte3;
    return data;
  }

  Empreinte.fromMap(Map<String, dynamic> map) {
    empreinte1 = map['empreinte_1'];
    empreinte2 = map['empreinte_2'];
    empreinte3 = map['empreinte_3'];
    empreinteId = map['empreinte_id'];
  }
}
