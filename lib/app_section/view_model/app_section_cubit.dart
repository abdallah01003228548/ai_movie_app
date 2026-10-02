import 'package:ai_movie_app/app_section/view_model/app_section_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSectionCubit extends Cubit<AppSectionState> {
  AppSectionCubit() : super(AppSectionState(currentIndex: 0));

  void changeIndex(int index) {
    emit(AppSectionState(currentIndex: index));
  }
}
