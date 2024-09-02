part of 'bank_account_cubit.dart';

class BankAccountStateCubit extends Equatable {
  final GetBanksEntity? bankAccountEntity;

  const BankAccountStateCubit({this.bankAccountEntity});

  BankAccountStateCubit copyWith({
    GetBanksEntity? bankAccountEntity,
  }) =>
      BankAccountStateCubit(
        bankAccountEntity: bankAccountEntity ?? this.bankAccountEntity,
      );

  @override
  List<Object?> get props => [
        bankAccountEntity,
      ];
}
