import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../features/elite/presentation/elite_screen.dart';
import '../../../../features/elite/presentation/is_elite_screen.dart';

import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../_core/transaction/domain/entities/price_entity.dart';

class EliteCombinedScreen extends StatelessWidget {
  final bool? isFromHome;
  final bool? isFromReferral;
  final bool? isFromOffers;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  const EliteCombinedScreen({
    super.key,
    this.isFromHome = false,
    this.isFromReferral = false,
    this.isFromOffers = false,
    this.isFromGrafik = false,
    this.priceEntity,
  });

  @override
  Widget build(BuildContext context) {
    appPrint("grafik : $isFromGrafik");
    return BlocBuilder<EliteCubit, bool>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, isElite) {
        return isElite
            ? IsEliteScreen(
                isFromHome: isFromHome ?? false,
                isFromReferral: isFromReferral ?? false,
                isFromOffers: isFromOffers ?? false,
              )
            : EliteScreen(
                isFromGrafik: isFromGrafik,
                priceEntity: priceEntity,
              );
      },
    );
  }
}
