import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../data/models/menu_model.dart';
import '../../../domain/entities/menu_entity.dart';
import '../../../domain/usecases/get_menus_uc.dart';

part 'beranda_menus_event.dart';
part 'beranda_menus_state.dart';

class BerandaMenusBloc extends Bloc<BerandaMenusEvent, BerandaMenusState> {
  final GetMenusUc getMenusUc;

  BerandaMenusBloc({required this.getMenusUc})
      : super(BerandaMenusInitialState()) {
    on<BerandaMenusGetEvent>((event, emit) async {
      if ((event.helperDataCubit?.state.berandaMenus ?? []).isNotEmpty) {
        event.helperDataCubit?.state.berandaMenus.sort(
          (a, b) => (a.position ?? 0).compareTo((b.position ?? 0)),
        );
        final primary = (event.helperDataCubit?.state.berandaMenus ?? [])
            .getRange(0, 4)
            .toList();
        final secondary =
            event.helperDataCubit?.state.berandaMenus.getRange(4, 7).toList();
        secondary?.add(const MenuModel(
          id: 0,
          isActive: 1,
        ));
        emit(BerandaMenusSuccessState(
          menuPrimary: primary,
          menuSecondary: secondary ?? [],
          allMenu: event.helperDataCubit?.state.berandaMenus ?? [],
        ));
        return;
      }
      emit(BerandaMenusLoadingState());
      final result = await getMenusUc();
      result.fold(
        (l) => emit(BerandaMenusFailureState(l, l.code, l.messages)),
        (r) {
          r.sort(
            (a, b) => (a.position ?? 0).compareTo((b.position ?? 0)),
          );
          final allMenu = r.take(8).toList();
          event.helperDataCubit?.updateBerandaMenus(allMenu);
          final primary = r.getRange(0, 4).toList();
          final secondary = r.getRange(4, 7).toList();
          secondary.add(const MenuModel(
            id: 0,
            isActive: 1,
          ));
          emit(BerandaMenusSuccessState(
            menuPrimary: primary,
            menuSecondary: secondary,
            allMenu: allMenu,
          ));
        },
      );
    });
  }
}
