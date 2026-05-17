import 'package:mylm/data/models/product/newpackages_response.dart';

abstract class NewPackagesState {}

class NewPackagesInitial extends NewPackagesState {}

class NewPackagesLoading extends NewPackagesState {}

class NewPackagesLoaded extends NewPackagesState {
  final List<NewPackagesModel> packages;

  NewPackagesLoaded(this.packages);
}

class NewPackagesError extends NewPackagesState {
  final String message;

  NewPackagesError(this.message);
}