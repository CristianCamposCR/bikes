class BikeModel {
  final int? id;
  final String brand;
  final String model;
  final String type;
  final String color;

  BikeModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.type,
    required this.color,
  });

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'type': type,
      'color': color,
    };
  }
}
