class RegisterResponse {
  int id;
  String token;

  RegisterResponse({required this.id, required this.token});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(id: json['id'], token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "token": token};
  }
}
