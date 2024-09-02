import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../features/elite/data/models/elite_register_req.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import 'blocs/elite_blocs.dart';
import 'cubits/elite_cubits.dart';
import 'widgets/elite_widgets.dart';

class ElitePaymentMethodScreen extends StatelessWidget {
  final EliteRegisterReq eliteRegisterReq;
  final String? backScreen;
  const ElitePaymentMethodScreen({
    super.key,
    required this.eliteRegisterReq,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<ElitePaymentMethodBloc>()..add(GetElitePaymentMethodEvent()),
        ),
        BlocProvider(
          create: (context) => SelectPaymentCubit(),
        ),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return Scaffold(
            backgroundColor: isElite ? clrBlack080 : null,
            appBar: AppBar(
              backgroundColor: clrBackgroundBlack,
              centerTitle: true,
              title: Text(
                t.lblRegistLakuemasElite,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: MainBackButton(
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            bottomNavigationBar: _mainButton(context),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    BlocBuilder<ElitePaymentMethodBloc,
                        ElitePaymentMethodState>(
                      builder: (context, state) {
                        if (state is ElitePaymentMethodSuccessState) {
                          final data = state.elitePaymentMethodEntity;

                          return PaymentMethodWidget(
                            isElite: isElite,
                            title: t.lblPayment,
                            itemLength: 0,
                            optionalWidget:
                                BlocBuilder<SelectPaymentCubit, int?>(
                              builder: (context, state) {
                                return PaymentMethodItemWidget(
                                  isElite: isElite,
                                  itemLength: 1,
                                  radioBtn: (index) {
                                    return radioPayment(
                                      data[index].id!,
                                      state,
                                      (value) {
                                        context
                                            .read<SelectPaymentCubit>()
                                            .changeOption(data[index].id!);
                                      },
                                      isElite,
                                    );
                                  },
                                );
                              },
                            ),
                            menuName: (index) => activationCodeTitle(t, index),
                            menuOnTap: (index) => accOnTap(context, index),
                            radioBtn: (index) => radio(index, 0, (value) {}),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String activationCodeTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblGoldBalance;
      default:
        return '-';
    }
  }

  void accOnTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // context.read<SubscriptionMethodCubit>().changeOption(0);
        break;
      case 1:
        // context.read<SubscriptionMethodCubit>().changeOption(1);
        break;
      default:
    }
  }

  Widget radio(int index, int? groupValue, void Function(Object?)? onChanged) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: clrNeutralGrey999.withOpacity(0.50),
    );
  }

  Widget radioPayment(int index, int? groupValue,
      void Function(int?)? onChanged, bool isElite) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateColor.resolveWith((states) =>
          (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75)),
    );
  }

  Widget _mainButton(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<ElitePaymentMethodBloc, ElitePaymentMethodState>(
      builder: (context, state) {
        if (state is ElitePaymentMethodSuccessState) {
          final data = state.elitePaymentMethodEntity[0].id;
          return Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: BlocBuilder<SelectPaymentCubit, int?>(
              builder: (context, state) {
                return MainButton(
                  label: t.lblContinue,
                  onPressed: state != null
                      ? () {
                          // if (customerId != null) {
                          context.goNamed(
                            AppRoutes.eliteChangePaymentMethod,
                            extra: {
                              'eliteRegisterReq': eliteRegisterReq.copyWith(
                                // customerId: customerId,
                                paymentMethodId: data!,
                              ),
                              'eliteCubit': context.read<EliteCubit>(),
                              'backScreen': backScreen,
                            },
                          );
                          // }
                        }
                      : null,
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
