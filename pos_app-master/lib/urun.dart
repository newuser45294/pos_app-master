class Urun {
  String name;
  int fiyat;
  Urun(this.name, this.fiyat);
  factory Urun.fromJson(Map<dynamic, dynamic> map) {
    return Urun(map["name"], map["fiyat"]);
  }
}
