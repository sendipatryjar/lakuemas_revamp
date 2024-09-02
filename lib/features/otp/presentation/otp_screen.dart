import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/otp_type.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/bottom_sheet_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/utils/validation_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../login/presentation/blocs/login/login_bloc.dart';
import '../../support/presentation/blocs/support_contact/support_contact_bloc.dart';
import '../domain/entities/otp_choose_entity.dart';
import 'blocks/otp/otp_bloc.dart';
import 'cubits/otp_validation/otp_validation_cubit.dart';
import 'widgets/countdown_widget.dart';
import 'widgets/otp_image_content_widget.dart';

class OtpScreen extends StatelessWidget {
  final String? parentScreenName;
  final OtpChooseEntity? otpChooseEntity;
  final int? otpType;
  final String? username;
  final String? backScreen;
  final String? nextScreen;
  final bool isPrivyRegister;
  final Map<String, Object?> extra;

  const OtpScreen({
    super.key,
    this.parentScreenName,
    this.otpChooseEntity,
    this.otpType,
    this.username,
    this.backScreen,
    this.nextScreen = AppRoutes.beranda,
    this.isPrivyRegister = false,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final userNameHelper = username ?? '0812xxxxxx';
    var subTitle = '${t.lblInputOtpDesc} ${t.lblNumber}';
    if (ValidationUtils.email(userNameHelper)) {
      subTitle = '${t.lblInputOtpDesc} email';
    }
    return BlocProvider(
      create: (context) => sl<OtpValidationCubit>(),
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpLoading) {
            EasyLoading.show();
          }
          if (state is OtpFailure) {
            EasyLoading.showError(
              state.message ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
          if (state is OtpSuccess) {
            if (state.otp == Otp.resend) {
              EasyLoading.dismiss();
              return;
            }
            if (state.otp == Otp.send) return;
            EasyLoading.dismiss();
            if (parentScreenName == AppRoutes.register) {
              DialogUtils.success(
                barrierDismissible: false,
                context: context,
                firstDesc: '${t.lblCongrats}! ${t.lblRegisterSuccess}',
                secondDesc: t.lblPleaseLogBackIn,
                btnText: t.lblBackToLogin,
                btnOnPressed: () {
                  context.goNamed(
                    AppRoutes.login,
                  );
                },
              );
            }
            if (parentScreenName == AppRoutes.login) {
              if (state.pinStatus == true) {
                context.read<HelperDataCubit>().alreadyInputPin(true);
                context.goNamed(AppRoutes.beranda);
                return;
              }
              context.goNamed(
                AppRoutes.pin,
                extra: {
                  'pinType': state.pinStatus == true
                      ? '${PinType.validate}'
                      : '${PinType.create}',
                  'nextScreenPin': AppRoutes.beranda,
                  'backScreenPin': AppRoutes.login,
                },
              );
            }
            if (parentScreenName == AppRoutes.profile) {
              context.read<HelperDataCubit>().updateUserData(null);
              Future.delayed(const Duration(seconds: 2)).then((value) {
                context.goNamed(AppRoutes.profile);
              });
              DialogUtils.success(
                barrierDismissible: false,
                context: context,
                firstDesc: '${t.lblVerification} ${t.lblSuccess}',
              );
            }
            if (parentScreenName == AppRoutes.pin) {
              context.goNamed(
                AppRoutes.newPin,
                extra: {
                  ...extra,
                  'bloc': context.read<OtpBloc>(),
                  'parentScreenName': AppRoutes.pin,
                  'phoneNumber': otpChooseEntity?.phoneNumber,
                  'email': otpChooseEntity?.email,
                  'pinType': '${PinType.validate}',
                  'backScreenNewPin': backScreen ?? '',
                  'nextScreenNewPin': nextScreen ?? '',
                  'username':
                      (state.otpType == 0 ? userNameHelper : userNameHelper),
                  'otpType': otpType.toString(),
                },
              );
            }
          }
        },
        child: _Content(
          subTitle: subTitle,
          userNameHelper: userNameHelper,
          parentScreenName: parentScreenName,
          otpChooseEntity: otpChooseEntity,
          otpType: otpType,
          isPrivyRegister: isPrivyRegister,
          extra: extra,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String subTitle;
  final String userNameHelper;
  final String? parentScreenName;
  final OtpChooseEntity? otpChooseEntity;
  final int? otpType;
  final bool isPrivyRegister;
  final Map<String, Object?> extra;

  _Content({
    Key? key,
    required this.subTitle,
    required this.userNameHelper,
    required this.parentScreenName,
    required this.otpChooseEntity,
    required this.otpType,
    required this.isPrivyRegister,
    this.extra = const {},
  }) : super(key: key);

  final TextEditingController _otpTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    int otpLocation = OtpLocation.verify;
    if (parentScreenName == AppRoutes.login) {
      otpLocation = OtpLocation.login;
    }
    if (parentScreenName == AppRoutes.register || isPrivyRegister) {
      otpLocation = OtpLocation.register;
    }
    if (parentScreenName == AppRoutes.pin) {
      otpLocation = OtpLocation.forgotPin;
    }
    return Scaffold(
      backgroundColor: clrBackgroundBlack,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'OTP',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: MainBackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OtpImageContentWidget(
                title: t.lblInputOtp,
                subTitle: subTitle,
                username: ' $userNameHelper',
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 160,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    BlocBuilder<OtpValidationCubit, OtpValidationState>(
                      builder: (context, state) {
                        return MainTextField(
                          controller: _otpTec,
                          letterSpacing: 16,
                          isCenterText: true,
                          textInputType: TextInputType.number,
                          textInputFormatter: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          isError: state.isError ?? false,
                          errorText: state.errorMessages,
                          onChange: (value) {
                            if (value.length == 6) {
                              context.read<OtpValidationCubit>().validate(
                                    t: t,
                                    value: _otpTec.text,
                                  );
                              final isError = context
                                  .read<OtpValidationCubit>()
                                  .state
                                  .isError;
                              if (isError == false) {
                                String? privyId;
                                if (isPrivyRegister) {
                                  privyId = (context.read<LoginBloc>().state
                                          as LoginSuccess)
                                      .privyId;
                                }
                                appPrint('username: $userNameHelper');
                                appPrint('otpCode: ${_otpTec.text}');
                                appPrint('otpType: $otpType');
                                appPrint('parentScreenName: $parentScreenName');
                                appPrint('privyId: $privyId');
                                context.read<OtpBloc>().add(OtpVerifyPressed(
                                      username: userNameHelper,
                                      otpCode: _otpTec.text,
                                      otpType: otpType,
                                      otpLocation: otpLocation,
                                      privyId: privyId,
                                    ));
                              }
                            }
                          },
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: CountdownWidget(
                        parentScreenName: parentScreenName,
                        username: userNameHelper,
                        otpLocation: otpLocation,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  String? phoneNumber;
                  var supportContactState =
                      context.read<SupportContactBloc>().state;
                  if (supportContactState is SupportContactSuccessState) {
                    phoneNumber = supportContactState.phone;
                  }
                  BottomSheetUtils.contactUs(
                    context: context,
                    titleText: 'Tidak Menerima OTP?',
                    bodyText:
                        'Jika kamu tidak menerima OTP Via SMS/Email, pastikan hal berikut:\n\n'
                        '1. Pastikan nomor ponsel / email yang anda gunakan sudah sesuai dan aktif.\n\n'
                        '2. Untuk OTP via Email dapat dilakukan pengecekan pada folder SPAM jika tidak terkirim ke inbox anda.\n\n'
                        '3. Tunggu 1 Menit untuk mengirimkan kembali OTP dengan menekan "Kirim Ulang OTP"\n\n\n'
                        'Selamat bergabung Laku Friends !\n\n'
                        'Jangan membagikan kode OTP ke siapapun, Lakuemas tidak pernah meminta Kode OTP kamu dalam kondisi apapun, Waspada penipuan!',
                    phoneNumber: phoneNumber,
                  );
                },
                child: RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: '${t.lblNotReceived} OTP? ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: clrWhite),
                    children: [
                      TextSpan(
                        text: t.lblContactUs,
                        style: TextStyle(
                          color: clrYellow,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
