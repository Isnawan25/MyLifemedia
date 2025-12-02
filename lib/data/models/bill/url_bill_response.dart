class UrlBillResponse {
  final String url;

  UrlBillResponse({required this.url});

  factory UrlBillResponse.fromJson(Map<String, dynamic> json) {
    return UrlBillResponse(
      url: json['data']['urlPay'],
    );
  }
}
