class Faq {
  final int idFaq;
  final String titleFaq;
  final String descFaq;

  Faq({
    required this.idFaq,
    required this.titleFaq,
    required this.descFaq,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      idFaq: json['idFaq'],
      titleFaq: json['titleFaq'],
      descFaq: json['descFaq'],
    );
  }
}
