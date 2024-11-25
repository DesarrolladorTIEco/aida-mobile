class UserModel {
  final String userName;
  final String fullName;
  final String userID;
  final String userDNI;

  UserModel({required this.userName, required this.fullName, required this.userID, required this.userDNI});

  // Método para crear un UserModel a partir de un mapa
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['UsrLogin'] ?? 'Usuario no disponible',
      fullName: json['UsrFullName'] ?? 'Nombre no disponible',
      userID: json['UsrID'] ?? '0',
      userDNI: json['UsrDni'] ?? '12345678',
    );
  }
}
