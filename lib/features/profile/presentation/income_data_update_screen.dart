import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/extensions/str_extension.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_dropdown_search.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/profile_update/profile_update_bloc.dart';
import 'cubits/income_data_update/income_data_update_cubit.dart';

class IncomeDataUpdateScreen extends StatelessWidget {
  const IncomeDataUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<IncomeDataUpdateCubit>()..initSelfData(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileUpdateBloc>(),
        ),
      ],
      child: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) {
          if (state is ProfileUpdateLoadingState) {
            EasyLoading.show();
          }
          if (state is ProfileUpdateSuccessState) {
            EasyLoading.dismiss();
            context.read<HelperDataCubit>().updateUserData(null);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              context.goNamed(AppRoutes.profile);
            });
            DialogUtils.success(
              context: context,
              barrierDismissible: false,
              firstDesc: t.lblDataSavedSuccess,
            );
          }
          if (state is ProfileUpdateFailureState) {
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
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblIncomeData,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.profileSelfData,
                extra: {'bloc': context.read<ProfileBloc>()});
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblSave,
          onPressed: () {
            context.read<IncomeDataUpdateCubit>().validate(t: t);

            final occupation =
                context.read<IncomeDataUpdateCubit>().state.occupation;
            final income = context.read<IncomeDataUpdateCubit>().state.income;
            final purpose = context.read<IncomeDataUpdateCubit>().state.purpose;
            appPrint('occupation: $occupation');
            appPrint('income: $income');
            appPrint('purpose: $purpose');

            if ((occupation ?? '').isNotEmpty &&
                (income ?? '').isNotEmpty &&
                (purpose ?? '').isNotEmpty) {
              context.read<ProfileUpdateBloc>().add(IncomeDataUpdatePressed(
                    occupation: occupation,
                    income: income,
                    purpose: purpose,
                  ));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              BlocBuilder<IncomeDataUpdateCubit, IncomeDataUpdateState>(
                buildWhen: (previous, current) =>
                    previous.occupation != current.occupation ||
                    previous.occupationErrMessage !=
                        current.occupationErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<String?>(
                    title: t.lblJob,
                    hintText: '${t.lblSelect} ${t.lblJob}',
                    items: context.read<IncomeDataUpdateCubit>().occupations,
                    itemAsString: (value) => value ?? '',
                    selectedItem: state.occupation?.emptyStringToNull(),
                    onChanged: (value) {
                      context
                          .read<IncomeDataUpdateCubit>()
                          .changeOccupation(value);
                    },
                    errorMessage: state.occupationErrMessage ?? '',
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<IncomeDataUpdateCubit, IncomeDataUpdateState>(
                buildWhen: (previous, current) =>
                    previous.income != current.income ||
                    previous.incomeErrMessage != current.incomeErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<String?>(
                    title: t.lblIncomeType,
                    hintText: '${t.lblSelect} ${t.lblIncomeType}',
                    items: context.read<IncomeDataUpdateCubit>().incomes,
                    itemAsString: (value) => value ?? '',
                    selectedItem: state.income?.emptyStringToNull(),
                    onChanged: (value) {
                      context.read<IncomeDataUpdateCubit>().changeIncome(value);
                    },
                    errorMessage: state.incomeErrMessage ?? '',
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<IncomeDataUpdateCubit, IncomeDataUpdateState>(
                buildWhen: (previous, current) =>
                    previous.purpose != current.purpose ||
                    previous.purposeErrMessage != current.purposeErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<String?>(
                    title: t.lblAccCreatePurpose,
                    hintText: '${t.lblSelect} ${t.lblAccCreatePurpose}',
                    items: context.read<IncomeDataUpdateCubit>().purposes,
                    itemAsString: (value) => value ?? '',
                    selectedItem: state.purpose?.emptyStringToNull(),
                    onChanged: (value) {
                      context
                          .read<IncomeDataUpdateCubit>()
                          .changePurpose(value);
                    },
                    errorMessage: state.purposeErrMessage ?? '',
                  );
                },
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
