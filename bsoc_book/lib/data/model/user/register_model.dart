class RegisterModel {
  String? username;
  String? email;
  List<int>? role;
  String? password;
  String? phone;
  int? id;

  RegisterModel(
      {this.username,
      this.email,
      this.role,
      this.password,
      this.phone,
      this.id});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    role = json['role'].cast<int>();
    password = json['password'];
    phone = json['phone'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['password'] = password;
    data['phone'] = phone;
    data['id'] = id;
    return data;
  }
}
