class Area {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Area({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an Area instance from a JSON map
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert an Area instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
