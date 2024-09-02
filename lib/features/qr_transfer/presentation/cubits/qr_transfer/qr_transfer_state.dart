part of 'qr_transfer_cubit.dart';

enum EnQRTransfer { scanQR, codeQR }

class QrTransferState extends Equatable {
  final EnQRTransfer enQRTransfer;
  final PermissionStatus? cameraPermission;
  const QrTransferState({
    required this.enQRTransfer,
    required this.cameraPermission,
  });

  QrTransferState copyWith({
    EnQRTransfer? enQRTransfer,
    PermissionStatus? cameraPermission,
    bool isNullifyCameraPermission = false,
  }) =>
      QrTransferState(
        enQRTransfer: enQRTransfer ?? this.enQRTransfer,
        cameraPermission: isNullifyCameraPermission ? null : (cameraPermission ?? this.cameraPermission),
      );

  @override
  List<Object?> get props => [enQRTransfer, cameraPermission];
}
