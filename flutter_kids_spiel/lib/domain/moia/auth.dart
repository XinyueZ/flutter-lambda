class AuthResponse {
  final String tokenType;
  final String idToken;
  final num expiresIn;

  AuthResponse(this.tokenType, this.idToken, this.expiresIn);
}

class AuthBody {
  final String grantType;
  final String username;
  final String password;

  AuthBody(this.grantType, this.username, this.password);
}
