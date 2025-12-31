import 'package:flutter_bloc/flutter_bloc.dart';
import 'term_conditions_state.dart';
import 'package:mylm/data/network/services/get/get_term_conditions.dart';

class TermConditionsCubit extends Cubit<TermConditionsState> {
  TermConditionsCubit() : super(TermConditionsLoading());

  Future<void> loadTerms() async {
    emit(TermConditionsLoading());
    try {
      final result = await TermConditionsService().getTermConditions();

      if (result?.data != null) {
        emit(TermConditionsLoaded(result!.data));
      } else {
        emit(const TermConditionsError("Gagal memuat Syarat & Ketentuan"));
      }
    } catch (e) {
      emit(TermConditionsError(e.toString()));
    }
  }
}
