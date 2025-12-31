abstract class CurrentCustState {}

class CurrentCustInitial extends CurrentCustState {}

class CurrentCustLoaded extends CurrentCustState {
  final String custNumber;
  final String custGroupId;

  CurrentCustLoaded({
    required this.custNumber,
    required this.custGroupId,
  });
}
