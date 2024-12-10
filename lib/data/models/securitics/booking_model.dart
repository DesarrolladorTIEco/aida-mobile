class BookingModel {
  final String name;
  final String cultive;
  final String zone;
  final num isSp;
  final num isExp;
  final String date;
  final num user;

  BookingModel(this.name, this.cultive, this.zone, this.isSp, this.isExp,
      this.date, this.user);

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
        json['MbBkName'] ?? '',
        json['MbBkCultive'] ?? '',
        json['MbBkZone'] ?? '',
        num.tryParse(json['MbBkIsSP'].toString()) ?? 0,
        num.tryParse(json['MbBkIsExp'].toString()) ?? 0,
        json['SecDateCreate'] ?? '',
        num.tryParse(json['UsrCreate'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'MbBkName': name,
      'MbBkCultive': cultive,
      'MbBkZone': zone,
      'MbBkIsSP': isSp,
      'MbBkIsExp': isExp,
      'SecDateCreate': date,
      'UsrCreate': user,
    };
  }

  @override
  String toString() {
    return 'BookingModel{'
        'MbBkName: $name, MbBkCultive: $cultive, MbBkZone: $zone, MbBkIsSP: $isSp, MbBkIsExo: $isExp, SecDateCreate: $date, UsrCreate: $user}';
  }
}
