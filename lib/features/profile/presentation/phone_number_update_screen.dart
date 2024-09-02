import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import 'blocs/profile_update/profile_update_bloc.dart';
import 'cubits/change_username_validation/change_username_validation_cubit.dart';

class PhoneNumberUpdateScreen extends StatelessWidget {
  final String? phoneNumber;
  const PhoneNumberUpdateScreen({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileUpdateBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangeUsernameValidationCubit>(),
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
        child: _Content(key: key, t: t, phoneNumber: phoneNumber),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final String? phoneNumber;
  const _Content({
    super.key,
    required this.t,
    this.phoneNumber,
  });

  final AppLocalizations t;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late TextEditingController _phoneNumberTec;

  @override
  void initState() {
    super.initState();

    _phoneNumberTec = TextEditingController();
    _phoneNumberTec.text = widget.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          '${widget.t.lblEdit} ${widget.t.lblPhoneNumber}',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            _goToPofileSelfData(context);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: widget.t.lblSave,
          onPressed: () {
            context.read<ChangeUsernameValidationCubit>().validatePhoneNumber(
                widget.t, widget.phoneNumber, _phoneNumberTec.text);
            bool isPhoneValidated = context
                .read<ChangeUsernameValidationCubit>()
                .isPhoneValidated();
            if (isPhoneValidated) {
              context.read<ProfileUpdateBloc>().add(
                  PhoneNumberUpdatePressed(phoneNumber: _phoneNumberTec.text));
            }
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 32),
            BlocBuilder<ChangeUsernameValidationCubit,
                ChangeUsernameValidationState>(
              builder: (context, state) {
                return MainTextField(
                  title: widget.t.lblPhoneNumber,
                  titleColor: clrBackgroundBlack.withOpacity(0.75),
                  controller: _phoneNumberTec,
                  hintText: widget.t.lblInputYourPhoneNumber,
                  onChange: (val) {
                    context
                        .read<ChangeUsernameValidationCubit>()
                        .validatePhoneNumber(widget.t, widget.phoneNumber, val);
                  },
                  isError: state.phoneNumberError != null,
                  errorText: state.phoneNumberError,
                  isDarkMode: false,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  void _goToPofileSelfData(BuildContext context) {
    // context.pop();
    context.goNamed(
      AppRoutes.profile,
    );
  }
}
