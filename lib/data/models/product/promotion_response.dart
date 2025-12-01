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

  static const String baseImageUrl =
      "https://hospitality.lifemedia.id/cms-lifemedia/public/";

  factory Promotion.fromJson(Map<String, dynamic> json) {
    final rawPhoto = json['photo'] ?? "";

    return Promotion(
      id: json['id'],
      name: json['name'],
      photo: rawPhoto.startsWith("http")
          ? rawPhoto
          : "$baseImageUrl$rawPhoto",
      isActive: json['isActive'],
    );
  }
}
