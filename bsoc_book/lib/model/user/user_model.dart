class UserModel {
  String? username;
  String? email;
  List<int>? role;
  String? password;
  String? namePartner;
  int? id;
  bool? active;

  UserModel(
      {this.username,
      this.email,
      this.role,
      this.password,
      this.namePartner,
      this.id,
      this.active});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    role = json['role'].cast<int>();
    password = json['password'];
    namePartner = json['namePartner'];
    id = json['id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['password'] = password;
    data['namePartner'] = namePartner;
    data['id'] = id;
    data['active'] = active;
    return data;
  }
}
