import 'package:mylm/data/models/product/exists_package_response.dart';

abstract class ExistsPackageState {}

class ExistsPackageInitial extends ExistsPackageState {}
class ExistsPackageLoading extends ExistsPackageState {}

class ExistsPackageLoaded extends ExistsPackageState {
  final ExistsPackage? package;
  ExistsPackageLoaded(this.package);
}

class ExistsPackageError extends ExistsPackageState {
  final String message;
  ExistsPackageError(this.message);
}
