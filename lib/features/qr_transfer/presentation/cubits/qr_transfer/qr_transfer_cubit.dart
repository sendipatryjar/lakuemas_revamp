import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'qr_transfer_state.dart';

class QrTransferCubit extends Cubit<QrTransferState> {
  QrTransferCubit()
      : super(const QrTransferState(
          enQRTransfer: EnQRTransfer.scanQR,
          cameraPermission: null,
        ));

  void changeTab(EnQRTransfer enQRTransfer) => emit(state.copyWith(
        enQRTransfer: enQRTransfer,
      ));

  void changeCameraPermission(PermissionStatus? cameraPermission) {
    emit(state.copyWith(
      isNullifyCameraPermission: true,
    ));
    emit(state.copyWith(
      cameraPermission: cameraPermission,
    ));
  }
}
