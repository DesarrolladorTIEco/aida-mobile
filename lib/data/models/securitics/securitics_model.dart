class CultiveModel {
  final String cultive;
  final num user;

  CultiveModel(this.cultive, this.user);

  factory CultiveModel.fromJson(Map<String, dynamic> json) {
    return CultiveModel(
      json['MbCltDescription'] ?? '',
      json['UsrCreate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'cultive': cultive, 'user': user};
  }

  @override
  String toString() {
    return 'CultiveModel{cultive: $cultive, user : $user}';
  }
}

class RegisterZoneModel {
  final String registerZone;
  final num user;

  RegisterZoneModel(this.registerZone, this.user);

  factory RegisterZoneModel.fromJson(Map<String, dynamic> json) {
    return RegisterZoneModel(
      json['MbRzDescription'] ?? '',
      json['UsrCreate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'registerZone': registerZone, 'user': user};
  }

  @override
  String toString() {
    return 'RegisterZoneModel{registerZone: $registerZone, user: $user}';
  }
}
