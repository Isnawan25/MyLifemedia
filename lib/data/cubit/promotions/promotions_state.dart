import 'package:equatable/equatable.dart';
import 'package:mylm/data/models/product/promotion_response.dart';

abstract class PromotionsState extends Equatable {
  const PromotionsState();

  @override
  List<Object?> get props => [];
}

class PromotionsInitial extends PromotionsState {}

class PromotionsLoading extends PromotionsState {}

class PromotionsLoaded extends PromotionsState {
  final List<Promotion> promotions;

  const PromotionsLoaded(this.promotions);

  @override
  List<Object?> get props => [promotions];
}

class PromotionsError extends PromotionsState {
  final String message;

  const PromotionsError(this.message);

  @override
  List<Object?> get props => [message];
}
