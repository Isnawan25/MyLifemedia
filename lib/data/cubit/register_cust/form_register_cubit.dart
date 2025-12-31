import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_register_state.dart';
import 'package:mylm/data/network/services/post/post_register_customer.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_request.dart';

class FormRegisterCubit extends Cubit<FormRegisterState> {
  FormRegisterCubit() : super(FormRegisterInitial());

  // === REGISTER CUSTOMER ===
  Future<void> register(RegisterCustomerRequest request) async {
    emit(FormRegisterSubmitLoading());
    try {
      final response =
      await RegisterCustomerService().registerCustomer(request);

      if (response.success == 1) {
        emit(FormRegisterSubmitSuccess());
      } else {
        emit(FormRegisterError(response.message));
      }
    } catch (e) {
      emit(FormRegisterError(e.toString()));
    }
  }
}
