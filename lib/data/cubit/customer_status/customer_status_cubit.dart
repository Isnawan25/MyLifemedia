import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_user_status.dart';
import 'customer_status_state.dart';

class CustomerStatusCubit extends Cubit<CustomerStatusState> {
  final CustomerStatusService service;

  CustomerStatusCubit(this.service) : super(CustomerStatusInitial());

  Future<void> fetchStatus(String custNumber) async {
    emit(CustomerStatusLoading());
    try {
      final result = await service.getCustomerStatus(
        custNumber: custNumber,
      );
      if (result != null) {
        emit(CustomerStatusLoaded(result));
      } else {
        emit(CustomerStatusError("Status tidak ditemukan"));
      }
    } catch (e) {
      emit(CustomerStatusError(e.toString()));
    }
  }
}
