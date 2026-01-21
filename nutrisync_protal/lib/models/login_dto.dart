class LoginDTO {
  final String username;
  final String password;
  final bool rememberMe;

  LoginDTO({
    required this.username,
    required this.password,
    this.rememberMe = false,
  });

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "rememberMe": rememberMe,
    };
  }
}
