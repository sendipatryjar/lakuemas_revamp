import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import 'blocs/master_data/master_data_lakusave_bloc.dart';
import 'cubits/lakusave/lakusave_cubit.dart';
import 'cubits/lakusave_auto_extended/lakusave_auto_extended_cubit.dart';
import 'widgets/auto_extend_deposit_info_widget.dart';
import 'widgets/lakusave_expandable_widget.dart';

class LakuSaveAutoDepositScreen extends StatelessWidget {
  const LakuSaveAutoDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<LakusaveAutoExtendedCubit>(),
      child: _Content(t: t),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblLakuSave,
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblContinue,
              onPressed: context
                          .watch<LakusaveCubit>()
                          .state
                          .selectedExtendedEntity
                          ?.id !=
                      null
                  ? () {
                      var lkSaveCbtState = context.read<LakusaveCubit>().state;
                      if (lkSaveCbtState.selectedExtendedEntity?.id != null) {
                        context.goNamed(
                          AppRoutes.lakuSaveDetail,
                          extra: {
                            'isElite': isElite.toString(),
                            'berandaBalancesBloc':
                                context.read<BerandaBalancesBloc>(),
                            'lakusaveCubit': context.read<LakusaveCubit>(),
                            'masterDataLakusaveBloc':
                                context.read<MasterDataLakusaveBloc>(),
                          },
                        );
                      }
                    }
                  : null,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    t.lblExtendDeposit,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isElite
                          ? clrGreyE5e.withOpacity(0.12)
                          : clrGreyE5e.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 2,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _autoDepositOption(
                          context,
                          itemLength: 2,
                          isElite: isElite,
                          title: (index) => _depoOption(context, index),
                          radioBtn: (index) => _radioBtn(
                            index: index,
                            groupValue: context
                                .watch<LakusaveAutoExtendedCubit>()
                                .state,
                            onChanged: (value) {
                              context
                                  .read<LakusaveAutoExtendedCubit>()
                                  .change(index);
                              if (value == 0) {
                                context
                                    .read<LakusaveCubit>()
                                    .changeExtended(null);
                              }
                              if (value == 1) {
                                var extended = (context
                                            .read<MasterDataLakusaveBloc>()
                                            .state
                                        as MasterDataLakusaveSuccessState)
                                    .goldDepositEntity
                                    ?.extendss
                                    .where((element) => element.id == 1)
                                    .toList();
                                context
                                    .read<LakusaveCubit>()
                                    .changeExtended(extended?[0]);
                              }
                            },
                            isElite: isElite,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (context.watch<LakusaveAutoExtendedCubit>().state ==
                            0)
                          AutoExtendDepositInfoWidget(
                            isElite: isElite,
                          ),
                        Text(
                          t.lblAccNumberExtendDepo,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isElite
                                ? clrWhite.withOpacity(0.75)
                                : clrBackgroundBlack.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 6),
                        BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
                          builder: (context, state) {
                            String accountNumber = '-';
                            if (state is BerandaBalancesSuccessState) {
                              accountNumber =
                                  state.goldBalanceEntity?.accountNumber ?? '-';
                            }
                            return MainTextField(
                              isDarkMode: isElite,
                              controller:
                                  TextEditingController(text: accountNumber),
                              enabled: false,
                            );
                          },
                        ),
                        if (context.watch<LakusaveAutoExtendedCubit>().state ==
                            0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                t.lblExtendStatus,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isElite
                                      ? clrWhite.withOpacity(0.75)
                                      : clrBackgroundBlack.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 6),
                              LakusaveExpandableWidget(
                                isElite: isElite,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _depoOption(BuildContext context, int? index) {
    final t = AppLocalizations.of(context)!;

    switch (index) {
      case 0:
        return t.lblYes;
      case 1:
        return t.lblNo;
      default:
        return '-';
    }
  }

  Widget _autoDepositOption(
    BuildContext context, {
    int itemLength = 0,
    required String Function(int) title,
    required Widget Function(int) radioBtn,
    bool isElite = false,
  }) {
    return Row(
      children: List.generate(
        itemLength,
        (index) => Row(
          children: [
            radioBtn(index),
            Text(
              title(index),
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
            if (index == 0) const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _radioBtn({
    required int index,
    int? groupValue,
    void Function(int?)? onChanged,
    bool isElite = false,
  }) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return (isElite)
              ? clrWhite.withOpacity(0.75)
              : clrBackgroundBlack.withOpacity(0.75);
        },
      ),
    );
  }
}
