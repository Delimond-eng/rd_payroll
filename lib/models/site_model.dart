class Sites {
  int id;
  String siteId;
  String siteNom;
  String province;

  Sites({
    this.id,
    this.siteId,
    this.siteNom,
    this.province,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_id'] = siteId;
    data['site'] = siteNom;
    data['province'] = province;

    return data;
  }

  Sites.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    siteId = json["site_id"];
    siteNom = json['site'];
    province = json['province'];
  }
}
