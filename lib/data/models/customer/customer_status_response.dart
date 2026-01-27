class CustomerStatusResponse {
  final String custNumber;
  final String custStatus;

  CustomerStatusResponse({
    required this.custNumber,
    required this.custStatus,
  });

  factory CustomerStatusResponse.fromJson(Map<String, dynamic> json) {
    return CustomerStatusResponse(
      custNumber: json['custNumber'] ?? '',
      custStatus: json['custStatus'] ?? '',
    );
  }
}
