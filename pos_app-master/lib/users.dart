class Users {
  var uid;
  Users(this.uid);
  factory Users.fromJson(Map<dynamic, dynamic> map) {
    return Users(map["uid"]);
  }
}
