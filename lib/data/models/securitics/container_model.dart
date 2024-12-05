class ContainerModel {
  final String name;
  final String cultive;
  final String zone;
  final String date;
  final num user;
  final String directory;

  ContainerModel(this.name, this.cultive, this.zone, this.date, this.user, this.directory);

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      json['MbCntNameContainer'] ?? '',
      json['MbCntCultive'] ?? '',
      json['MbCntZone'] ?? '',
      json['SecDateCreate'] ?? '',
      num.tryParse(json['UsrCreate'].toString()) ?? 0,
      json['MbCntLinkDirectory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MbCntNameContainer': name,
      'MbCntCultive': cultive,
      'MbCntZone': zone,
      'SecDateCreate': date,
      'UsrCreate': user,
      'MbCntLinkDirectory' : directory
    };
  }

  @override
  String toString() {
    return 'ContainerModel{'
        'MbCntNameContainer: $name,MbCntCultive: $cultive,MbCntZone: $zone, '
        'SecDateCreate: $date,UsrCreate: $user, MbCntLinkDirectory: $directory}';
  }
}
