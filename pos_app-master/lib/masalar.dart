class Masa {
  String key;
  String name;
  Masa(this.key, this.name);
  factory Masa.fromJson(String key, Map<dynamic, dynamic> map) {
    return Masa(key,map["masa"]);
  }
}
