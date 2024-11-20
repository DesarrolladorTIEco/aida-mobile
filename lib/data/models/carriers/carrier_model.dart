class CarrierModel {
  final String licensePlateNumber;
  final num occupantNumber;
  final String dniDriver;
  final String driver;
  final String route;
  final String gate;
  final String type;
  final String qrDateReader;
  final num user;

  CarrierModel(
      this.dniDriver,
      this.driver,
      this.route,
      this.gate,{
        required this.licensePlateNumber,
        required this.occupantNumber,
        required this.type,
        required this.qrDateReader,
        required this.user,
      });

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      json['MbptDniDriver'] ?? '', // dniDriver
      json['MbptDriver'] ?? '', // driver
      json['MbptRoute'] ?? '', // route
      json['MbptGate'] ?? '', // gate

      licensePlateNumber: json['MbptLicensePlateNumber'] ?? 'Nombre no disponible',
      occupantNumber: json['MbptOccupantsNumber'] ?? 0,
      user: json['UsrCreate'] ?? 0, // user
      type: json['MbptType'] ?? '0', // Ensure it’s the correct type
      qrDateReader: json['MbptDate'], // Asegúrate de que el campo es válido
    );
  }
}
