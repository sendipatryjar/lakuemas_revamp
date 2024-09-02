import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/physical_pull/data/models/physical_pull_checkout_req.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';
import 'blocs/charge/charge_bloc.dart';
import 'blocs/list_gold_brand/list_gold_brand_bloc.dart';
import 'blocs/physical_pull_gold_balance/physical_pull_gold_balance_bloc.dart';
import 'cubits/physical_pull/physical_pull_cubit.dart';
import 'cubits/physical_pull_counter/physical_pull_counter_cubit.dart';
import 'widgets/physical_pull_balance_widget.dart';
import 'widgets/physical_pull_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhysicalPullScreen extends StatelessWidget {
  const PhysicalPullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PhysicalPullCubit>()),
        BlocProvider(create: (context) => sl<PaymentCubit>()),
        BlocProvider(create: (context) => sl<PhysicalPullCounterCubit>()),
        BlocProvider(create: (context) => sl<ChargeBloc>()),
        BlocProvider(
          create: (context) => sl<PhysicalPullGoldBalanceBloc>()
            ..add(
              GetPhysicalPullGoldBalanceEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => sl<ListGoldBrandBloc>()
            ..add(
              GetListGoldBrandEvent(),
            ),
        ),
      ],
      child: BlocListener<ChargeBloc, ChargeState>(
        listener: (context, state) {
          if (state is ChargeLoadingState) {
            EasyLoading.show();
          }
          if (state is ChargeSuccessState) {
            EasyLoading.dismiss();

            context.goNamed(
              AppRoutes.physicalPullPayment,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'paymentCubit': context.read<PaymentCubit>(),
                'physicalPullCheckoutReq': PhysicalPullCheckoutReq(
                  transactionKey: state.chargeEntity.transactionKey,
                ),
                'checkout': CheckoutEntity(
                  grossAmount: state.chargeEntity.grossAmount,
                  transactionKey: state.chargeEntity.transactionKey,
                  detail: state.chargeEntity.detail,
                ),
              },
            );
          }
          if (state is ChargeFailureState) {
            EasyLoading.showError(
              state.message ?? '',
              dismissOnTap: true,
            );
          }
        },
        child: const _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    var maxHeight = MediaQuery.of(context).size.height;
    double bottomSheetHeight = 96;
    var dragableController = DraggableScrollableController();

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          body: Stack(
            children: [
              Column(
                children: [
                  PhysicalPullBalanceWidget(isElite: isElite),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: PhysicalPullTab(
                              isElite: isElite,
                              dragableController: dragableController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                initialChildSize: bottomSheetHeight / maxHeight,
                minChildSize: bottomSheetHeight / maxHeight,
                maxChildSize: 178 / maxHeight,
                snap: true,
                controller: dragableController,
                // snapSizes: [],
                builder: (context, scrollController) {
                  return BlocBuilder<PhysicalPullCounterCubit,
                      PhysicalPullCounterState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        physics: state.listGoldBrandEntity.isNotEmpty
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isElite ? clrBlack080 : clrWhite,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Biaya',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: (isElite
                                                  ? clrWhite
                                                  : clrBackgroundBlack)
                                              .withOpacity(0.75),
                                        ),
                                      ),
                                      BlocBuilder<PhysicalPullCounterCubit,
                                          PhysicalPullCounterState>(
                                        builder: (context, state) {
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Rp ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: isElite
                                                    ? clrWhite
                                                    : clrBackgroundBlack,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: (state.totalCost ?? 0)
                                                      .toString()
                                                      .toIdr(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  BlocBuilder<PhysicalPullCounterCubit,
                                      PhysicalPullCounterState>(
                                    builder: (context, state) {
                                      return MainButton(
                                        label: t.lblNext,
                                        labelStyle: isElite
                                            ? TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: clrBackgroundBlack,
                                              )
                                            : null,
                                        onPressed: (state.chargeReq.isEmpty)
                                            ? null
                                            : () {
                                                context.read<ChargeBloc>().add(
                                                    ChargePostEvent(
                                                        state.chargeReq));
                                              },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 41),
                              Text(
                                'Biaya Sertifikat',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      (isElite ? clrWhite : clrBackgroundBlack)
                                          .withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 10),
                              BlocBuilder<PhysicalPullCounterCubit,
                                  PhysicalPullCounterState>(
                                builder: (context, state) {
                                  return _amountWidget(
                                    title: (index) =>
                                        '${_title(state.listGoldBrandEntity[index].goldBrandId ?? 0)} - ${state.listGoldBrandEntity[index].fragment} gr',
                                    amount: (index) => state
                                        .listGoldBrandEntity[index]
                                        .certificatePrice
                                        .toString()
                                        .toIdr(),
                                    isElite: isElite,
                                    itemLength:
                                        state.listGoldBrandEntity.length,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _title(int goldBrandId) {
    switch (goldBrandId) {
      case 1:
        return 'Antam';
      case 4:
        return 'Lotus';
      default:
        return '-';
    }
  }

  Widget _amountWidget({
    String Function(int)? title,
    Widget? titleWidget,
    String Function(int)? amount,
    bool isElite = false,
    int itemLength = 0,
  }) {
    return Column(
      children: List.generate(
        itemLength,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: title != null
                    ? Text(
                        title(index),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: (isElite ? clrWhite : clrBackgroundBlack)
                              .withOpacity(0.75),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: (titleWidget ?? const SizedBox()),
                      ),
              ),
              RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.75),
                    ),
                    children: [
                      TextSpan(
                        text: 'Rp ${amount!(index)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
