class UserModel {
  final String userName;
  final String fullName;

  UserModel({required this.userName, required this.fullName});

  // Método para crear un UserModel a partir de un mapa
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['UsrLogin'] ?? 'Usuario no disponible',
      fullName: json['UsrFullName'] ?? 'Nombre no disponible',
    );
  }
}
