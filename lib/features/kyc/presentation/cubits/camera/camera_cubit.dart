import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState(permissionStatus: null));

  void changePermission(PermissionStatus? permissionStatus) {
    emit(CameraState(permissionStatus: permissionStatus));
  }
}
