part of 'transfer_cubit.dart';

enum EnTransfer { newAccount, favAccount }

class TransferState extends Equatable {
  final EnTransfer enTransfer;
  final bool isFavorite;
  final List<UserFavoriteEntity> favorites;
  final List<UserFavoriteEntity> favoritesSearch;
  final UserFavoriteEntity? selectedFavorite;
  const TransferState({
    required this.enTransfer,
    this.isFavorite = false,
    this.favorites = const [],
    this.favoritesSearch = const [],
    this.selectedFavorite,
  });

  TransferState copyWith({
    EnTransfer? enTransfer,
    bool? isFavorite,
    List<UserFavoriteEntity>? favorites,
    List<UserFavoriteEntity>? favoritesSearch,
    UserFavoriteEntity? selectedFavorite,
    bool isNullifySelectedFavorite = false,
  }) =>
      TransferState(
        enTransfer: enTransfer ?? this.enTransfer,
        isFavorite: isFavorite ?? this.isFavorite,
        favorites: favorites ?? this.favorites,
        favoritesSearch: favoritesSearch ?? this.favoritesSearch,
        selectedFavorite: isNullifySelectedFavorite
            ? null
            : (selectedFavorite ?? this.selectedFavorite),
      );

  @override
  List<Object> get props => [
        enTransfer,
        isFavorite,
        favorites,
        favoritesSearch,
        [selectedFavorite],
      ];
}
