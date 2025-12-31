import 'package:equatable/equatable.dart';

class MainPreviewState extends Equatable {
  final int index;

  const MainPreviewState(this.index);

  @override
  List<Object> get props => [index];
}
