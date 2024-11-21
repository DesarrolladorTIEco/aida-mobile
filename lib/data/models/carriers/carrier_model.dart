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
  final num seatNumber;

  CarrierModel(
    this.dniDriver,
    this.driver,
    this.route,
    this.gate,{
    required this.licensePlateNumber,
    required this.occupantNumber,
    required this.type,
    required this.seatNumber,
    required this.qrDateReader,
    required this.user,
  });

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      json['MbptDniDriver'] ?? '', // dniDriver
      json['MbptDriver'] ?? '', // driver
      json['MbptRoute'] ?? '', // route
      json['MbptGate'] ?? '', // gate
      licensePlateNumber:
      json['MbptLicensePlateNumber'] ?? 'Nombre no disponible',
      occupantNumber: int.tryParse(json['MbptNumberSeats'] ?? '0') ?? 0,
      seatNumber: int.tryParse(json['MbptNumberSeats'] ?? '0') ?? 0,
      user: int.tryParse(json['UsrCreate'] ?? '0') ?? 0,
      type: json['MbptType'] ?? '0',
      // Ensure it’s the correct type
      qrDateReader: json['MbptDate'], // Asegúrate de que el campo es válido
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlateNumber': licensePlateNumber,
      'occupantNumber': occupantNumber,
      'dniDriver': dniDriver,
      'driver': driver,
      'route': route,
      'gate': gate,
      'type': type,
      'qrDateReader': qrDateReader,
      'user': user,
      'seatNumber' : seatNumber
    };
  }

  @override
  String toString() {
    return 'CarrierModel{licensePlateNumber: $licensePlateNumber, occupantNumber: $occupantNumber, dniDriver: $dniDriver, driver: $driver, route: $route, gate: $gate, type: $type, qrDateReader: $qrDateReader, user: $user, seatNumber : $seatNumber}';
  }
}
