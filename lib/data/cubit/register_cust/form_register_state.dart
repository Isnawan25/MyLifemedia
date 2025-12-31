import 'package:equatable/equatable.dart';

abstract class FormRegisterState extends Equatable {
  const FormRegisterState();

  @override
  List<Object?> get props => [];
}

class FormRegisterInitial extends FormRegisterState {}

class FormRegisterTermLoading extends FormRegisterState {}

class FormRegisterSubmitLoading extends FormRegisterState {}

class FormRegisterSubmitSuccess extends FormRegisterState {}

class FormRegisterError extends FormRegisterState {
  final String message;
  const FormRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
