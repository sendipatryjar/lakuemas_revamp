import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../features/physical_pull/domain/entities/fragment_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/extensions/currency_extension.dart';

import '../../../../cores/constants/app_color.dart';
import '../blocs/list_gold_brand/list_gold_brand_bloc.dart';
import '../cubits/physical_pull/physical_pull_cubit.dart';
import '../cubits/physical_pull_counter/physical_pull_counter_cubit.dart';

class PhysicalPullTab extends StatelessWidget {
  final bool isElite;
  final DraggableScrollableController? dragableController;

  const PhysicalPullTab({
    super.key,
    this.isElite = false,
    this.dragableController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final counterTec = TextEditingController(text: '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 32, bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<PhysicalPullCubit, PhysicalPullState>(
                  buildWhen: (previous, current) =>
                      previous.enPhysicalPull != current.enPhysicalPull,
                  builder: (context, state) {
                    return _tab(
                      title: t.lblAntam,
                      isSelected: state.enPhysicalPull == EnPhysicalPull.antam,
                      onTap: () {
                        context
                            .read<PhysicalPullCubit>()
                            .changeTab(EnPhysicalPull.antam);
                        context
                            .read<PhysicalPullCounterCubit>()
                            .changeTab(EnPhysicalPull.antam);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: BlocBuilder<PhysicalPullCubit, PhysicalPullState>(
                  builder: (context, state) {
                    return _tab(
                      title: t.lblLotus,
                      isSelected: state.enPhysicalPull == EnPhysicalPull.lotus,
                      onTap: () {
                        context
                            .read<PhysicalPullCubit>()
                            .changeTab(EnPhysicalPull.lotus);
                        context
                            .read<PhysicalPullCounterCubit>()
                            .changeTab(EnPhysicalPull.lotus);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<PhysicalPullCubit, PhysicalPullState>(
          buildWhen: (previous, current) =>
              previous.enPhysicalPull != current.enPhysicalPull,
          builder: (context, state) {
            return state.enPhysicalPull == EnPhysicalPull.antam
                ? BlocBuilder<ListGoldBrandBloc, ListGoldBrandState>(
                    builder: (context, state) {
                      if (state is ListGoldBrandLoadingState) {
                        return Column(
                          children: List.generate(
                            4,
                            (index) => Shimmer.fromColors(
                              baseColor: clrGreyShimmerBase,
                              highlightColor: clrGreyShimmerHighlight,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: clrWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (state is ListGoldBrandSuccessState) {
                        return _physicalPullItem(
                          title: (index) =>
                              '${state.listAntam!.fragments![index].fragment!.toInt().toString()} Gram',
                          sertifCost: (index) =>
                              'Biaya Sertifikat Rp ${state.listAntam?.fragments?[index].certificatePrice?.toIdr()}',
                          counterWidget: (index) => _counterBtn(
                            counterTec: counterTec,
                            index: index,
                            fragmentEntity: state.listAntam?.fragments?[index],
                          ),
                          itemLength: state.listAntam!.fragments!.length,
                          imgUrl: imgPhysicalPullGold,
                        );
                      }
                      return const SizedBox();
                    },
                  )
                : state.enPhysicalPull == EnPhysicalPull.lotus
                    ? BlocBuilder<ListGoldBrandBloc, ListGoldBrandState>(
                        builder: (context, state) {
                          if (state is ListGoldBrandLoadingState) {
                            return Shimmer.fromColors(
                              baseColor: clrGreyShimmerBase,
                              highlightColor: clrGreyShimmerHighlight,
                              child: _physicalPullItem(
                                title: (index) => '',
                                sertifCost: (index) => '',
                                counterWidget: (index) => const SizedBox(),
                                itemLength: 3,
                                imgUrl: imgPhysicalPullGold,
                              ),
                            );
                          }
                          if (state is ListGoldBrandSuccessState) {
                            return _physicalPullItem(
                              title: (index) =>
                                  '${state.listLotus!.fragments![index].fragment!.toInt().toString()} Gram',
                              sertifCost: (index) =>
                                  'Biaya Sertifikat Rp ${state.listLotus?.fragments?[index].certificatePrice?.toIdr()}',
                              counterWidget: (index) => _counterBtn(
                                fragmentEntity:
                                    state.listLotus?.fragments?[index],
                                counterTec: counterTec,
                                index: index,
                              ),
                              itemLength: state.listLotus!.fragments!.length,
                              imgUrl: imgPhysicalPullGold,
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    : const SizedBox();
          },
        ),
        const SizedBox(height: 110),
      ],
    );
  }

  Widget _tab({
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.16),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? clrBackgroundBlack
                : (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75),
          ),
        ),
      ),
    );
  }

  Widget _physicalPullItem({
    required String Function(int)? title,
    final String? imgUrl,
    final String Function(int)? sertifCost,
    final Widget Function(int)? counterWidget,
    int itemLength = 0,
  }) {
    return Column(
      children: List.generate(
        itemLength,
        (index) => Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: isElite
                  ? clrGreyE5e.withOpacity(0.12)
                  : clrGreyE5e.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: clrNeutralGrey999.withOpacity(0.16),
                width: 1,
              )),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.12)
                        : clrGreyE5e.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(imgUrl ?? ''),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!(index),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        height: 1,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                      Text(
                        sertifCost!(index),
                        style: TextStyle(
                          fontSize: 12,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      counterWidget!(index),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _counterBtn({
    TextEditingController? counterTec,
    int? index,
    FragmentEntity? fragmentEntity,
  }) {
    return BlocListener<PhysicalPullCounterCubit, PhysicalPullCounterState>(
      listenWhen: (previous, current) {
        return (previous.isMinChipError != current.isMinChipError) ||
            (previous.isBalanceError != current.isBalanceError);
      },
      listener: (context, state) {
        // print("start listener : " + state.isMinChipError.toString());
        // if (state.isMinChipError == true) {
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   const SnackBar(
        //   //     content: Text(
        //   //       'Anda telah mencapai batas maksimal penarikan keping emas per transaksi. Batas jumlah penarikan per transaksi adalah 3 keping.',
        //   //     ),
        //   //   ),
        //   // );
        //   print('isminchiperror');
        // }

        // if (state.isBalanceError == true) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Penarikan emas melebihi saldo yang anda miliki'),
        //     ),
        //   );
        // }
      },
      child: BlocBuilder<PhysicalPullCounterCubit, PhysicalPullCounterState>(
        builder: (context, state) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (state.enPhysicalPull == EnPhysicalPull.antam) {
                    state.listGoldBrandEntity.isNotEmpty
                        ? context
                            .read<PhysicalPullCounterCubit>()
                            .decrement(fragmentEntity!)
                        : null;
                    state.listGoldBrandEntity.isNotEmpty
                        ? dragableController
                        : dragableController?.reset();
                  } else if (state.enPhysicalPull == EnPhysicalPull.lotus) {
                    state.listGoldBrandEntity.isNotEmpty
                        ? context
                            .read<PhysicalPullCounterCubit>()
                            .decrement(fragmentEntity!)
                        : null;
                    state.listGoldBrandEntity.isNotEmpty
                        ? dragableController
                        : dragableController?.reset();
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.16)
                        : clrGreyE5e.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: clrNeutralGrey999.withOpacity(0.16),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: TextField(
                  controller: TextEditingController(
                      text: state.listGoldBrandEntity
                          .where((element) => element.id == fragmentEntity?.id)
                          .length
                          .toString()),
                  style:
                      TextStyle(color: isElite ? clrWhite : clrBackgroundBlack),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (state.enPhysicalPull == EnPhysicalPull.antam) {
                    context
                        .read<PhysicalPullCounterCubit>()
                        .increment(fragmentEntity!);

                    if (state.isBalanceError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Penarikan emas melebihi saldo yang anda miliki'),
                        ),
                      );
                    }
                    if (state.isMinChipError == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Anda telah mencapai batas maksimal penarikan keping emas per transaksi. Batas jumlah penarikan per transaksi adalah 3 keping.',
                          ),
                        ),
                      );
                    }
                  } else if (state.enPhysicalPull == EnPhysicalPull.lotus) {
                    context
                        .read<PhysicalPullCounterCubit>()
                        .increment(fragmentEntity!);
                    if (state.isBalanceError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Penarikan emas melebihi saldo yang anda miliki'),
                        ),
                      );
                    }
                    if (state.isMinChipError == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Anda telah mencapai batas maksimal penarikan keping emas per transaksi. Batas jumlah penarikan per transaksi adalah 3 keping.',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.12)
                        : clrGreyE5e.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: clrNeutralGrey999.withOpacity(0.16),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
