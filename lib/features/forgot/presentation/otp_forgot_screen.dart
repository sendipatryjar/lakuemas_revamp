import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/bottom_sheet_utils.dart';
import '../../../cores/utils/validation_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../otp/domain/entities/otp_choose_entity.dart';
import '../../otp/presentation/cubits/otp_validation/otp_validation_cubit.dart';
import '../../otp/presentation/widgets/otp_image_content_widget.dart';
import '../../support/presentation/blocs/support_contact/support_contact_bloc.dart';
import 'blocs/otp_forgot/otp_forgot_bloc.dart';
import 'widgets/countdown_forgot_widget.dart';

class OtpForgotScreen extends StatelessWidget {
  final String? parentScreenName;
  final OtpChooseEntity? otpChooseEntity;
  final int? otpType;
  final String? username;
  final bool smsOTP;
  final bool emailOTP;
  final String? backScreen;
  final String? nextScreen;
  final Map<String, Object?> extra;

  const OtpForgotScreen({
    super.key,
    this.parentScreenName,
    this.otpChooseEntity,
    this.otpType,
    this.username,
    this.emailOTP = false,
    this.smsOTP = false,
    this.backScreen,
    this.nextScreen = AppRoutes.beranda,
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
      child: BlocListener<OtpForgotBloc, OtpForgotState>(
        listener: (context, state) {
          if (state is OtpForgotLoading) {
            EasyLoading.show();
          }
          if (state is OtpForgotFailure) {
            EasyLoading.showError(
              state.message ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
          if (state is OtpForgotSuccess) {
            if (state.otp == OtpForgot.resend) {
              EasyLoading.dismiss();
              return;
            }
            if (state.otp == OtpForgot.send) return;
            EasyLoading.dismiss();
            if (parentScreenName == AppRoutes.forgotPassword) {
              context.goNamed(
                AppRoutes.newPassword,
                extra: {
                  'bloc': context.read<OtpForgotBloc>(),
                  'parentScreenName': AppRoutes.forgotPassword,
                  'phoneNumber': userNameHelper,
                  'email': userNameHelper,
                  'smsOTP': smsOTP,
                  'emailOTP': emailOTP,
                  ...extra,
                  'username':
                      (state.otpType == 0 ? userNameHelper : userNameHelper),
                  'otpType': otpType.toString(),
                },
                // pathParameters: {
                //   'username': (state.otpType == 0 ? userNameHelper : userNameHelper),
                //   'otpType': otpType.toString(),
                // },
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: clrBackgroundBlack,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'OTP',
              style: TextStyle(
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
            child: _Content(
              subTitle: subTitle,
              userNameHelper: userNameHelper,
              parentScreenName: parentScreenName,
              otpChooseEntity: otpChooseEntity,
              otpType: otpType,
            ),
          ),
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

  _Content({
    Key? key,
    required this.subTitle,
    required this.userNameHelper,
    required this.parentScreenName,
    required this.otpChooseEntity,
    required this.otpType,
  }) : super(key: key);

  final TextEditingController _otpTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
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
                          final isError =
                              context.read<OtpValidationCubit>().state.isError;
                          if (isError == false) {
                            appPrint('username: $userNameHelper');
                            appPrint('otpCode: ${_otpTec.text}');
                            appPrint('otpType: $otpType');
                            appPrint('parentScreenName: $parentScreenName');
                            context.read<OtpForgotBloc>().add(OtpVerifyPressed(
                                  username: userNameHelper,
                                  otpCode: _otpTec.text,
                                  otpType: otpType,
                                ));
                          }
                        }
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: CountdownForgotWidget(
                    parentScreenName: parentScreenName,
                    username: userNameHelper,
                    // otpChooseEntity: otpChooseEntity,
                  ),
                ),
              ],
            ),
          ),
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
              text: TextSpan(
                text: '${t.lblNotReceived} OTP? ',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: clrWhite),
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
    );
  }
}
