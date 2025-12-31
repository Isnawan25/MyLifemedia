import 'package:equatable/equatable.dart';
import 'package:mylm/data/models/support/term_conditions_response.dart';

abstract class TermConditionsState extends Equatable {
  const TermConditionsState();

  @override
  List<Object?> get props => [];
}

class TermConditionsLoading extends TermConditionsState {}

class TermConditionsLoaded extends TermConditionsState {
  final TermConditionsData data;
  const TermConditionsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class TermConditionsError extends TermConditionsState {
  final String message;
  const TermConditionsError(this.message);

  @override
  List<Object?> get props => [message];
}
