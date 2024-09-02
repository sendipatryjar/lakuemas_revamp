part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final PermissionStatus? permissionStatus;
  const CameraState({required this.permissionStatus});

  @override
  List<Object?> get props => [permissionStatus];
}
