class ContainerModel {
  final String name;
  final String cultive;
  final String zone;
  final String date;
  final num user;
  final String directory;
  final num bkId;

  ContainerModel(this.name, this.cultive, this.zone, this.date, this.user, this.directory, this.bkId);

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      json['MbCntNameContainer'] ?? '',
      json['MbCntCultive'] ?? '',
      json['MbCntZone'] ?? '',
      json['SecDateCreate'] ?? '',
      num.tryParse(json['UsrCreate'].toString()) ?? 0,
      json['MbCntLinkDirectory'] ?? '',
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
      'MbCntLinkDirectory' : directory,
      'MbBkId': bkId,
    };
  }

  @override
  String toString() {
    return 'ContainerModel{'
        'MbCntNameContainer: $name,MbCntCultive: $cultive,MbCntZone: $zone, '
        'SecDateCreate: $date,UsrCreate: $user, MbCntLinkDirectory: $directory, MbBkId: $bkId}';
  }
}
