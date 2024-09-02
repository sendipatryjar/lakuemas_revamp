import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/utils/app_utils.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/services/firebase/firebase_messaging_service.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import 'blocs/update_settings/update_settings_bloc.dart';
import 'cubits/setting_data/setting_data_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SettingDataCubit>()..init(),
        ),
        BlocProvider(
          create: (context) => sl<UpdateSettingsBloc>(),
        ),
      ],
      child: BlocListener<UpdateSettingsBloc, UpdateSettingsState>(
        listener: (context, state) {
          if (state is UpdateSettingsLoadingState) {
            EasyLoading.show();
          }
          if (state is UpdateSettingsSuccessState) {
            EasyLoading.dismiss();
            FirebaseMessagingService.subscribeTopics(
              subscribePricing: state.withPrice,
              subscribePromo: state.withPromo,
            );
            Future.delayed(const Duration(seconds: 2)).then((value) {
              context.read<HelperDataCubit>().updateUserData(null);
              context.goNamed(AppRoutes.profile);
            });
            DialogUtils.success(
              context: context,
              barrierDismissible: false,
              firstDesc: t.lblDataSavedSuccess,
            );
          }
          if (state is UpdateSettingsFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(t: t),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblSettings,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.profile);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<SettingDataCubit, SettingDataState>(
          builder: (context, state) {
            var isUpdate = (state.currentData.withPrice != state.priceNotif) ||
                (state.currentData.withPromo != state.promoNotif);
            return MainButton(
              label: t.lblSave,
              onPressed: isUpdate
                  ? () {
                      final settingData =
                          context.read<SettingDataCubit>().state;
                      if ((settingData.currentData.withPrice !=
                              settingData.priceNotif) ||
                          (settingData.currentData.withPromo !=
                              settingData.promoNotif)) {
                        context
                            .read<UpdateSettingsBloc>()
                            .add(UpdateSettingsPressed(
                              withPrice: settingData.priceNotif,
                              withPromo: settingData.promoNotif,
                            ));
                      }
                    }
                  : null,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              BlocBuilder<SettingDataCubit, SettingDataState>(
                buildWhen: (previous, current) =>
                    previous.priceNotif != current.priceNotif,
                builder: (context, state) {
                  return _section(
                    context,
                    title: t.lblPriceNotification,
                    subTitle: t.lblUpdateGoldPrice,
                    value: state.priceNotif,
                    onSwitchChanged: (value) {
                      context
                          .read<SettingDataCubit>()
                          .updateSetting(priceNotif: value);
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<SettingDataCubit, SettingDataState>(
                buildWhen: (previous, current) =>
                    previous.promoNotif != current.promoNotif,
                builder: (context, state) {
                  return _section(
                    context,
                    title: t.lblPromotionNotification,
                    subTitle: t.lblSpecialOffer,
                    value: state.promoNotif,
                    onSwitchChanged: (value) {
                      context
                          .read<SettingDataCubit>()
                          .updateSetting(promoNotif: value);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required String subTitle,
    required bool value,
    Function(bool)? onSwitchChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: clrGreyE5e.withOpacity(0.25),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: clrNeutralGrey999.withOpacity(0.16))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: clrBackgroundBlack.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: clrYellow,
            onChanged: onSwitchChanged,
          ),
        ],
      ),
    );
  }
}
