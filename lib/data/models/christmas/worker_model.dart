class WorkerModel {
  final String workerDni;
  final String fullName;
  final String company;
  final String fechaEntrega;
  final String planilla;
  final String responsibleDni;
  final num user;

  WorkerModel(this.workerDni, this.fullName, this.company, this.fechaEntrega,
      this.planilla, this.responsibleDni,
      {required this.user});

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      json['MbPDni'] ?? '',
      json['MbPFullName'] ?? '',
      json['MbPCompany'] ?? '',
      json['MbPFechaEntrega'] ?? '',
      json['MbPlanilla'] ?? '',
      json['MbPrDni'] ?? '',
      user: int.tryParse(json['UsrCreate'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workerDni': workerDni,
      'fullName': fullName,
      'company': company,
      'fechaEntrega': fechaEntrega,
      'planilla': planilla,
      'responsibleDni': responsibleDni,
      'user': user,
    };
  }

  @override
  String toString() {
    return 'WorkerModel{workerDni: $workerDni, fullName: $fullName, company: $company, fechaEntrega: $fechaEntrega, planilla: $planilla, responsibleDni: $responsibleDni,  user: $user}';
  }
}
