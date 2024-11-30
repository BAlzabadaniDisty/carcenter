class ReservationModel {
  final int id;
  final String name;
  final String phone;
  final String carType;
  final String carModel;
  final int manufacturingYear;
  final String problemDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReservationModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.carType,
    required this.carModel,
    required this.manufacturingYear,
    required this.problemDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      carType: json['car_type'],
      carModel: json['car_model'],
      manufacturingYear: json['manufacturing_year'],
      problemDetails: json['problem_details'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

}
class ReservationResponse {
  final bool success;
  final ReservationModel? data;

  ReservationResponse({
    required this.success,
    this.data,
  });

  // Factory method to create an instance from JSON
  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      success: json['success'],
      data: json['data'] != null ? ReservationModel.fromJson(json['data']) : null,
    );
  }
}
