// ignore_for_file: non_constant_identifier_names

class SystemListModel {
  final int? id;
  final String? user; 
  final String name;
  final String? created_at;


  SystemListModel({
    this.id,
    this.user,
    required this.name,
    this.created_at,
  });

  
  factory SystemListModel.fromJson(Map<String, dynamic> json) {
    return SystemListModel(
      id: json['id'],
      user: json['user']?.toString(), 
      name: json['name'] ?? '',
      created_at: json['created_at'] ?? '',
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user': user
    };
  }
}