class Promotion {
  final int id;
  final String name;
  final String photo;
  final int isActive;

  Promotion({
    required this.id,
    required this.name,
    required this.photo,
    required this.isActive,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'],
      photo: (json['photo'] ?? ""),
      isActive: json['isActive'],
    );
  }
}
