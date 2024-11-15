class LoginResponse {
  final int id;
  final String name;
  final String email;
  final List<dynamic> role;
  final List<dynamic> roles;
  final List<dynamic> permissions;

  LoginResponse(
      this.id, this.name, this.email, this.role, this.roles, this.permissions);
}
