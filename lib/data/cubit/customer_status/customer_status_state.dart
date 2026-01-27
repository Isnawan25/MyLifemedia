import 'package:mylm/data/models/customer/customer_status_response.dart';

abstract class CustomerStatusState {}

class CustomerStatusInitial extends CustomerStatusState {}

class CustomerStatusLoading extends CustomerStatusState {}

class CustomerStatusLoaded extends CustomerStatusState {
  final CustomerStatusResponse status;

  CustomerStatusLoaded(this.status);
}

class CustomerStatusError extends CustomerStatusState {
  final String message;

  CustomerStatusError(this.message);
}
