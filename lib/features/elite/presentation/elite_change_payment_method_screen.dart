import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../profile/presentation/blocs/profile/profile_bloc.dart';
import '../data/models/elite_models.dart';
import 'blocs/elite_blocs.dart';
import 'widgets/elite_widgets.dart';

class EliteChangePaymentMethodScreen extends StatelessWidget {
  final EliteRegisterReq eliteRegisterReq;
  final String? backScreen;
  const EliteChangePaymentMethodScreen({
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
          create: (context) => sl<ProfileBloc>()..add(ProfileGetDataEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<ElitePaymentMethodBloc>()..add(GetElitePaymentMethodEvent()),
        ),
        BlocProvider(
          create: (context) => sl<EliteRegisterBloc>(),
        ),
      ],
      child: BlocListener<EliteRegisterBloc, EliteRegisterState>(
        listener: (context, state) {
          if (state is EliteRegisterLoadingState) {
            EasyLoading.show();
          }
          if (state is EliteRegisterSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.eliteDetailsOrder,
              extra: {
                'eliteRegisterReq': eliteRegisterReq,
                'eliteRegisterEntity': state.eliteRegisterEntity,
                'eliteCubit': context.read<EliteCubit>(),
                'backScreen': backScreen,
              },
            );
          }
          if (state is EliteRegisterFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
            Future.delayed(const Duration(seconds: 2)).then((value) {
              EasyLoading.dismiss();
            });
          }
        },
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      PaymentMethodWidget(
                        isElite: isElite,
                        title: t.lblPayment,
                        itemLength: 0,
                        optionalWidget: ChangePaymentWidgetItem(
                          isElite: isElite,
                          onTap: () {
                            context.pop();
                            // context.goNamed(
                            //   AppRoutes.elitePaymentMethod,
                            //   extra: {
                            //     'eliteRegisterReq': eliteRegisterReq.copyWith(),
                            //     'eliteCubit': context.read<EliteCubit>(),
                            //   },
                            // );
                          },
                        ),
                        menuName: (index) => activationCodeTitle(t, index),
                        menuOnTap: (index) => accOnTap(context, index),
                        radioBtn: (index) =>
                            radio(index, 0, (value) {}, isElite),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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

  Widget radio(
    int index,
    int? groupValue,
    void Function(int?)? onChanged,
    bool isElite,
  ) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: clrNeutralGrey999.withOpacity(0.50),
    );
  }

  Widget _mainButton(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteRegisterBloc, EliteRegisterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: MainButton(
            label: t.lblContinue,
            onPressed: () {
              context.read<EliteRegisterBloc>().add(
                    EliteRegisterEvents(
                      eliteRegisterReq.customerId,
                      eliteRegisterReq.packageId,
                      eliteRegisterReq.paymentMethodId,
                      eliteRegisterReq.voucherId,
                      eliteRegisterReq.autoRenewalPaymentMethod,
                      eliteRegisterReq.referalCode,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}
