import 'package:equatable/equatable.dart';
import 'package:mylm/data/models/product/packages_response.dart';

abstract class PackagesState extends Equatable {
  const PackagesState();

  @override
  List<Object?> get props => [];
}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final List<PackageData> packages;
  final String? selectedPackageId;

  const PackagesLoaded({
    required this.packages,
    this.selectedPackageId,
  });

  PackagesLoaded copyWith({
    List<PackageData>? packages,
    String? selectedPackageId,
  }) {
    return PackagesLoaded(
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId,
    );
  }

  @override
  List<Object?> get props => [packages, selectedPackageId];
}

class PackagesError extends PackagesState {
  final String message;

  const PackagesError(this.message);

  @override
  List<Object?> get props => [message];
}
