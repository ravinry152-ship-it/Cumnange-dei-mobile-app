class PostDataModel {
  final int? id;
  final String? system;
  final String? user;
  final String? name;
  final double? price;
  final String? village;

  PostDataModel({
    this.id,
    this.system,
    this.user,
    required this.name,
    required this.price,
    required this.village,
  });

  factory PostDataModel.fromJson(Map<String, dynamic> json) {
    return PostDataModel(
      id: _parseToInt(json['id']),
      
      system: json['system']?.toString(),
      user: json['user']?.toString(),
      name: json['name']?.toString() ?? '',
      
      price: _parseToDouble(json['price']),
      
      village: json['village']?.toString() ?? '',
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'village': village,
      'system': system,
      'user': user,
    };
  }
}