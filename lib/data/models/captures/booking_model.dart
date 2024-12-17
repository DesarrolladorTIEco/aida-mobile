class BookingModel {
  final String name;
  final String cultive;
  final String zone;
  final String date;
  final num user;


  BookingModel(this.name, this.cultive, this.zone, this.date, this.user);

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
        json['MbBkName'] ?? '',
        json['MbBkCultive'] ?? '',
        json['MbBkZone'] ?? '',
        json['SecDateCreate'] ?? '',
        num.tryParse(json['UsrCreate'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'MbBkName': name,
      'MbBkCultive': cultive,
      'MbBkZone': zone,
      'SecDateCreate': date,
      'UsrCreate': user,
    };
  }

  @override
  String toString() {
    return 'BookingModel{'
        'MbBkName: $name, MbBkCultive: $cultive, MbBkZone: $zone, SecDateCreate: $date, UsrCreate: $user}';
  }
}
