class ContainerModel {
  final String name;
  final String cultive;
  final String zone;
  final String date;
  final num user;

  ContainerModel(this.name, this.cultive, this.zone, this.date, this.user);

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel (
        json['MbCntNameContainer'] ?? '',
        json['MbCntCultive'] ?? '',
        json['MbCntZone'] ?? '',
        json['SecDateCreate'] ?? '',
        json['UsrCreate'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MbCntNameContainer' : name,
      'MbCntCultive' : cultive,
      'MbCntZone' : zone,
      'SecDateCreate' : date,
      'UsrCreate' : user,
    };
  }
  
  @override
  String toString() {
    return 'ContainerModel{'
        'MbCntNameContainer: $name,MbCntCultive: $cultive,MbCntZone: $zone,       SecDateCreate: $date,UsrCreate: $user}';
  }
}