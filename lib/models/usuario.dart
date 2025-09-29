class Usuario {
  String correoElectronico;
  String direccion;
  String nombreCompleto;
  String password;
  String telefono;
  String username;
  int idRol;
  int status;

  Usuario({
    required this.correoElectronico,
    required this.direccion,
    required this.nombreCompleto,
    required this.password,
    required this.telefono,
    required this.username,
    required this.idRol,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "correoElectronico": correoElectronico,
      "direccion": direccion,
      "nombreCompleto": nombreCompleto,
      "password": password,
      "telefono": telefono,
      "username": username,
      "idRol": idRol,
      "status": status,
    };
  }
}
