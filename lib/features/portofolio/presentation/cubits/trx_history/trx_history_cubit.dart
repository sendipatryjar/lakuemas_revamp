import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/trx_history_entity.dart';

part 'trx_history_state.dart';

class TrxHistoryCubit extends Cubit<TrxHistoryCubitState> {
  TrxHistoryCubit() : super(const TrxHistoryCubitState());

  void pickDate(List<DateTime?>? date) {
    if (state.trxDateSelected == 4) {
      emit(state.copyWith(date: date));
    }
    emit(state.copyWith(date: date));
  }

  String _filterTrxType(int? trxTypeSelected) {
    switch (trxTypeSelected) {
      case 0:
        return '';
      case 1:
        return 'selling';
      case 2:
        return 'purchase';
      case 3:
        return 'redeem';
      case 4:
        return 'deposit';
      case 5:
        return 'trade';
      case 6:
        return 'transfer';
      case 7:
        return 'elite';
      default:
        return '';
    }
  }

  String _trxType(int? trxTypeSelected) {
    switch (trxTypeSelected) {
      case 0:
        return 'Semua Transaksi';
      case 1:
        return 'Jual Emas';
      case 2:
        return 'Beli Emas';
      case 3:
        return 'Redeem';
      case 4:
        return 'Laku Simpan';
      case 5:
        return 'Laku Tukar';
      case 6:
        return 'Transfer';
      case 7:
        return 'Elite';
      default:
        return 'Semua Transaksi';
    }
  }

  String _filterTrxStatus(int? trxStatusSelected) {
    switch (trxStatusSelected) {
      case 0:
        return 'Semua Status';
      case 1:
        return 'Dalam Proses';
      case 2:
        return 'Berhasil';
      case 3:
        return 'Gagal';
      default:
        return 'Semua Status';
    }
  }

  String _filterTrxDate(int? trxDateSelected) {
    switch (trxDateSelected) {
      case 0:
        return '';
      case 1:
        return '7days';
      case 2:
        return '30days';
      case 3:
        return '90days';
      case 4:
        return '';
      default:
        return '';
    }
  }

  String _trxDate(int? trxDateSelected) {
    switch (trxDateSelected) {
      case 0:
        return 'Semua Tanggal';
      case 1:
        return '7 Hari Terakhir';
      case 2:
        return '30 Hari Terakhir';
      case 3:
        return '90 Hari Terakhir';
      case 4:
        return 'Pilih Tanggal Sendiri';
      default:
        return 'Semua Tanggal';
    }
  }

  int? _trxStatus(int? trxStatusSelected, int? trxTypeSelected) {
    switch (trxStatusSelected) {
      case 0:
        return null;
      case 1:
        if (_filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'purchase' ||
            _filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'transfer') {
          return 0;
        } else if (_filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'selling' ||
            _filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'cashout') {
          return 3;
        }
        return 0;
      case 2:
        if (_filterTrxType(
                    trxTypeSelected ?? state.trxTypeSelected) ==
                'purchase' ||
            _filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'transfer' ||
            _filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'elite') {
          return 1;
        } else if (_filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'selling' ||
            _filterTrxType(trxTypeSelected ?? state.trxTypeSelected) ==
                'cashout') {
          return 1;
        }
        return 1;
      case 3:
        return 2;
      case 4:
        return 0;
      case 5:
        return 0;
      default:
        return null;
    }
  }

  void removeTrxHistory() {
    emit(state.copyWith(trxHistory: []));
  }

  void changeTrxType(int? trxTypeSelected) {
    var trxStatus = _trxStatus(state.trxStatusSelected, trxTypeSelected);
    emit(state.copyWith(
      trxTypeSelected: trxTypeSelected,
      filterTrxType: _filterTrxType(trxTypeSelected),
      trxType: _trxType(trxTypeSelected),
      trxStatus: trxStatus,
      // nullifyTrxStatus: trxStatus == null,
    ));
  }

  void changeTrxStatus(int? trxStatusSelected) {
    var trxStatus = _trxStatus(
        trxStatusSelected ?? state.trxStatusSelected, state.trxTypeSelected);
    var filterTrxStatus = _filterTrxStatus(trxStatusSelected);
    emit(
      state.copyWith(
        trxStatusSelected: trxStatusSelected,
        filterTrxStatus: filterTrxStatus,
        trxStatus: trxStatus,
        nullifyTrxStatus: trxStatus == null,
      ),
    );
  }

  void changeTrxDate(int? trxDateSelected) {
    emit(
      state.copyWith(
        trxDateSelected: trxDateSelected,
        filterTrxDate: _filterTrxDate(trxDateSelected),
        trxDate: _trxDate(trxDateSelected),
        trxStatus: _trxStatus(state.trxStatusSelected, state.trxTypeSelected),
      ),
    );
  }

  void resetFilter() {
    emit(state.copyWith(
      filterTrxType: _filterTrxType(0),
      filterTrxStatus: _filterTrxStatus(0),
      filterTrxDate: _filterTrxDate(0),
      trxTypeSelected: 0,
      trxStatusSelected: 0,
      trxDateSelected: 0,
      trxType: _trxType(0),
      trxDate: _trxDate(0),
      trxStatus: _trxStatus(0, null),
    ));
  }

  void updateLoadingTrue() => emit(state.copyWith(
        isLoading: true,
        trxStatus: state.trxStatus,
      ));

  void updateErrorTrue() => emit(state.copyWith(
        isError: true,
        trxStatus: state.trxStatus,
      ));

  void updateTrxHistory({
    required int page,
    required List<TrxHistoryEntity> trxHistory,
    required MetaDataApi? metaData,
    bool isInitData = false,
  }) {
    List<TrxHistoryEntity> data = [];
    if (isInitData == false) {
      data.addAll(state.trxHistory);
    }
    data.addAll(trxHistory);

    emit(state.copyWith(
      trxHistory: data,
      isLoading: false,
      isError: false,
      meta: metaData,
      trxStatus: state.trxStatus,
    ));
  }
}
