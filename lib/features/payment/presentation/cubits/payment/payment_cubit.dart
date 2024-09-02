import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';
import '../../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../../coupon/domain/entities/coupon_detail_entity.dart';
import '../../../domain/entities/payment_debet_entity.dart';
import '../../../domain/entities/payment_method_entity.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentCbtState> {
  PaymentCubit() : super(const PaymentCbtState());

  void fillAllData(PaymentCbtState newState) => emit(newState);

  void addCheckoutData(CheckoutEntity? checkout) => emit(state.copyWith(checkoutEntity: checkout));

  void changePaymentMethod(PaymentMethodEntity? paymentMethod) {
    bool isNull = paymentMethod?.id == null;
    emit(state.copyWith(
      paymentMethodSelected: paymentMethod?.id,
      nullifyPaymentMethod: isNull,
      paymentMethodEntity: paymentMethod,
    ));
  }

  void changeIsNpwpAlreadyKyc(bool value) => emit(state.copyWith(isNpwpAlreadyKyc: value));

  void changeCoupon({
    bool? isValid,
    CouponDetailEntity? couponDetailEntity,
    String? couponErrMessage,
  }) {
    bool isNull = (couponDetailEntity?.couponCode == null) && isValid != true;
    bool isNotErr = couponErrMessage == null;
    emit(state.copyWith(
      nullifyCouponDetail: isNull,
      couponDetailEntity: couponDetailEntity,
      nullifyCouponErrMessage: isNotErr,
      couponErrMessage: couponErrMessage,
    ));
  }

  void removeCoupon() => emit(state.copyWith(
        nullifyCouponDetail: true,
        nullifyCouponErrMessage: true,
      ));

  void addOvoPhoneNumber(String? phoneNumb) => emit(state.copyWith(ovoPhoneNumber: phoneNumb));

  void resetOvoPhoneNumber() => emit(state.copyWith(ovoPhoneNumber: ""));

  void updateDebetCardNumber({
    required AppLocalizations t,
    String? cardNumber,
  }) {
    if ((cardNumber ?? '').isEmpty) {
      _debetCardNumberError(errMessage: t.lblCantBeEmpty);
      return;
    }
    bool isValid = ValidationUtils.rekeningNumber(cardNumber ?? '');
    if (isValid != true) {
      _debetCardNumberError(errMessage: 'masukkan nomor kartu dengan benar');
      return;
    }
    _debetCardNumberError(cardNumber: cardNumber, errMessage: null);
  }

  _debetCardNumberError({String? cardNumber, String? errMessage}) {
    PaymentDebetEntity? data = const PaymentDebetEntity();
    if (state.paymentDebetEntity != null) {
      data = state.paymentDebetEntity;
    }
    PaymentDebetEntityErr? dataErr = const PaymentDebetEntityErr();
    if (state.paymentDebetEntityErr != null) {
      dataErr = state.paymentDebetEntityErr;
    }
    emit(state.copyWith(
      paymentDebetEntity: data?.copyWith(
        cardNumber: cardNumber,
      ),
      paymentDebetEntityErr: dataErr?.copyWith(
        nullifyCardNumber: errMessage == null,
        cardNumber: errMessage,
      ),
    ));
  }

  void updateDebetExpDate({
    required AppLocalizations t,
    String? expDate,
  }) {
    if ((expDate ?? '').isEmpty) {
      _debetExpDateError(errMessage: t.lblCantBeEmpty);
      return;
    }
    if ((expDate ?? '').contains('/')) {
      String? strMonth = expDate?.split('/')[0];
      String? strYear = expDate?.split('/')[1];
      if (strMonth?.length != 2 && strYear?.length != 2) {
        _debetExpDateError(errMessage: 'tidak valid');
        return;
      }
      int month = int.tryParse(strMonth ?? '') ?? 0;
      int year = int.tryParse(strYear ?? '') ?? 0;

      final now = DateTime.now();
      String? strYear4 = (strYear ?? '').isNotEmpty ? '20$strYear' : '';
      int year4 = int.tryParse(strYear4) ?? 0;
      final expirationDate = DateTime(year4, month);
      final bool isExpired = expirationDate.isBefore(now);
      if (isExpired) {
        _debetExpDateError(errMessage: 'tidak valid');
        return;
      }

      _debetExpDateError(month: month, year: year, errMessage: null);
    } else {
      _debetExpDateError(errMessage: 'tidak valid');
    }
  }

  _debetExpDateError({int? month, int? year, String? errMessage}) {
    PaymentDebetEntity? data = const PaymentDebetEntity();
    if (state.paymentDebetEntity != null) {
      data = state.paymentDebetEntity;
    }
    PaymentDebetEntityErr? dataErr = const PaymentDebetEntityErr();
    if (state.paymentDebetEntityErr != null) {
      dataErr = state.paymentDebetEntityErr;
    }
    emit(state.copyWith(
      paymentDebetEntity: data?.copyWith(
        month: month,
        year: year,
      ),
      paymentDebetEntityErr: dataErr?.copyWith(
        nullifyExpDate: errMessage == null,
        expDate: errMessage,
      ),
    ));
  }

  void updateDebetCvv({
    required AppLocalizations t,
    String? cvv,
  }) {
    if ((cvv ?? '').isEmpty) {
      _debetCvvError(cvv: cvv, errMessage: t.lblCantBeEmpty);
      return;
    }
    _debetCvvError(cvv: cvv, errMessage: null);
  }

  _debetCvvError({String? cvv, String? errMessage}) {
    PaymentDebetEntity? data = const PaymentDebetEntity();
    if (state.paymentDebetEntity != null) {
      data = state.paymentDebetEntity;
    }
    PaymentDebetEntityErr? dataErr = const PaymentDebetEntityErr();
    if (state.paymentDebetEntityErr != null) {
      dataErr = state.paymentDebetEntityErr;
    }
    emit(state.copyWith(
      paymentDebetEntity: data?.copyWith(
        cvv: cvv,
      ),
      paymentDebetEntityErr: dataErr?.copyWith(
        nullifyCvv: errMessage == null,
        cvv: errMessage,
      ),
    ));
  }

  void resetDebet() {
    emit(state.copyWith(nullifyPaymentDebet: true));
  }

  bool isDebetValid() {
    if (state.paymentMethodSelected == 25) {
      var cardNumber = state.paymentDebetEntity?.cardNumber;
      var cardNumberErr = state.paymentDebetEntityErr?.cardNumber;
      var month = state.paymentDebetEntity?.month;
      var year = state.paymentDebetEntity?.year;
      var expDateErr = state.paymentDebetEntityErr?.expDate;
      var cvv = state.paymentDebetEntity?.cvv;
      var cvvErr = state.paymentDebetEntityErr?.cvv;
      if (cardNumber != null && month != null && year != null && cvv != null) {
        if (cardNumberErr == null && expDateErr == null && cvvErr == null) {
          return true;
        }
        return false;
      }
      return false;
    }
    return true;
  }
}
