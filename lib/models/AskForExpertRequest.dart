class AskForExpertRequest {
  final String name;
  final String phone;
  final String carType;
  final String carModel;
  final int manufacturingYear;
  final String problemDetails;
  final int areaId;

  AskForExpertRequest({
    required this.name,
    required this.phone,
    required this.carType,
    required this.carModel,
    required this.manufacturingYear,
    required this.problemDetails,
    required this.areaId,
  });

  // Convert request object to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'car_type': carType,
      'car_model': carModel,
      'manufacturing_year': manufacturingYear,
      'problem_details': problemDetails,
      'area_id': areaId,
    };
  }
}

class AskForExpertResponse {
  final int id;
  final String name;
  final String phone;
  final String carType;
  final String carModel;
  final int manufacturingYear;
  final String problemDetails;
  final int areaId;
  final String createdAt;
  final String updatedAt;

  AskForExpertResponse({
    required this.id,
    required this.name,
    required this.phone,
    required this.carType,
    required this.carModel,
    required this.manufacturingYear,
    required this.problemDetails,
    required this.areaId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an AskForExpertResponse from JSON data
  factory AskForExpertResponse.fromJson(Map<String, dynamic> json) {
    return AskForExpertResponse(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      carType: json['car_type'],
      carModel: json['car_model'],
      manufacturingYear: json['manufacturing_year'],
      problemDetails: json['problem_details'],
      areaId: json['area_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
