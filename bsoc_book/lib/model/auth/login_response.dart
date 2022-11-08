class LoginResponse {
  String token;

  LoginResponse({required this.token});

  factory LoginResponse.formJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {"token": token};
  }
}
