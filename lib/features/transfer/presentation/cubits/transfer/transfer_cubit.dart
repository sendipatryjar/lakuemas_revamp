import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_core/user/domain/entities/user_favorite_entity.dart';
import '../../../domain/usecases/get_user_favorites_uc.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  final GetUserFavoritesUc getUserFavoritesUc;

  TransferCubit({required this.getUserFavoritesUc})
      : super(const TransferState(
          enTransfer: EnTransfer.newAccount,
          // isSelectedFavoriteError: false,
        ));

  void changeTab(EnTransfer enTransfer) => emit(state.copyWith(
        enTransfer: enTransfer,
        isNullifySelectedFavorite: true,
        // isSelectedFavoriteError: false,
        isFavorite: false,
      ));

  void toggleFavorite(bool isFavorite) =>
      emit(state.copyWith(isFavorite: isFavorite));

  void fillFavorites() async {
    final result = await getUserFavoritesUc();
    result.fold((l) => emit(state.copyWith()),
        (r) => emit(state.copyWith(favorites: r, favoritesSearch: r)));
  }

  void searchFavorites(String keyword) {
    var favoritesSearch = state.favorites
        .where((element) =>
            (element.accountName?.toLowerCase() ?? '')
                .contains(keyword.toLowerCase()) ||
            (element.accountNumber ?? '').contains(keyword))
        .toList();
    emit(state.copyWith(favoritesSearch: favoritesSearch));
  }

  void selectFavorite(UserFavoriteEntity? value) {
    emit(state.copyWith(
      selectedFavorite: value,
      isNullifySelectedFavorite: value == null,
      // isSelectedFavoriteError: value == null,
    ));
  }
}
