part of 'select_payment_cubit.dart';

class SelectPaymentState extends Equatable {
  final Object? index;

  const SelectPaymentState({this.index});

  SelectPaymentState copyWith({
    Object? index,
  }) =>
      SelectPaymentState(
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [
        index,
      ];
}
