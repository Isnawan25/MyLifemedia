import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_preview_state.dart';

class MainPreviewCubit extends Cubit<MainPreviewState> {
  MainPreviewCubit() : super(const MainPreviewState(2));

  void changeTab(int index) {
    emit(MainPreviewState(index));
  }
}
