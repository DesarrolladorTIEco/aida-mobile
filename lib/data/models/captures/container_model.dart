class ContainerModel {
  final String name;
  final String cultive;
  final String zone;
  final String date;
  final num user;
  final num bkId;

  ContainerModel(this.name, this.cultive, this.zone, this.date, this.user, this.bkId);

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      json['MbCntNameContainer'] ?? '',
      json['MbCntCultive'] ?? '',
      json['MbCntZone'] ?? '',
      json['SecDateCreate'] ?? '',
      num.tryParse(json['UsrCreate'].toString()) ?? 0,
      num.tryParse(json['MbBkId'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MbCntNameContainer': name,
      'MbCntCultive': cultive,
      'MbCntZone': zone,
      'SecDateCreate': date,
      'UsrCreate': user,
      'MbBkId': bkId,
    };
  }

  @override
  String toString() {
    return 'ContainerModel{'
        'MbCntNameContainer: $name,MbCntCultive: $cultive,MbCntZone: $zone, '
        'SecDateCreate: $date,UsrCreate: $user, MbBkId: $bkId}';
  }
}
