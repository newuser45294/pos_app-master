class Siparis {
  int fiyat;
  String name;
  Siparis(this.fiyat, this.name);
  factory Siparis.fromJson(Map<dynamic, dynamic> map) {
    return Siparis(map["fiyat"], map["name"]);
  }
}
