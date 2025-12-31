import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_promotions.dart';
import 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final PromotionService promotionService;

  PromotionsCubit(this.promotionService)
      : super(PromotionsInitial());

  Future<void> fetchPromotions() async {
    emit(PromotionsLoading());
    try {
      final data = await promotionService.getPromotions();
      emit(PromotionsLoaded(data));
    } catch (e) {
      emit(const PromotionsError("Gagal memuat promosi"));
    }
  }
}
