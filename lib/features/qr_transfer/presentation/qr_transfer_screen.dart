import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';

import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import 'blocs/balance/balance_bloc.dart';
import 'cubits/qr_transfer/qr_transfer_cubit.dart';
import 'widgets/qr_transfer_tab_widget.dart';

class QRTransferScreen extends StatelessWidget {
  const QRTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<QrTransferCubit>()),
        BlocProvider(
            create: (context) => sl<QRTransferBalanceBloc>()
              ..add(
                QRTransferBalanceGetEvent(
                    accountName: context
                        .read<HelperDataCubit>()
                        .state
                        .userDataEntity
                        ?.name),
              )),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isELite) {
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 2000) {
                context.goNamed(AppRoutes.beranda);
              }
            },
            child: QRTransferTab(
              isElite: isELite,
            ),
          );
        },
      ),
    );
  }
}
