import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'current_cust_state.dart';

class CurrentCustCubit extends Cubit<CurrentCustState> {
  CurrentCustCubit() : super(CurrentCustInitial());

  Future<void> load({
    required String defaultCustNumber,
    required String defaultCustGroupId,
  }) async {
    final savedCustNumber = await SecureStorage.getCustNumber();
    final savedCustGroupId = await SecureStorage.getCustGroupId();

    emit(CurrentCustLoaded(
      custNumber: savedCustNumber ?? defaultCustNumber,
      custGroupId: savedCustGroupId ?? defaultCustGroupId,
    ));
  }

  Future<void> change({
    required String custNumber,
    required String custGroupId,
  }) async {
    await SecureStorage.saveCustNumber(custNumber);
    await SecureStorage.saveCustGroupId(custGroupId);

    emit(CurrentCustLoaded(
      custNumber: custNumber,
      custGroupId: custGroupId,
    ));
  }
}
