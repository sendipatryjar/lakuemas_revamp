// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../../../../cores/constants/app_color.dart';
// import '../../../../cores/services/cubits/countdown/countdown_cubit.dart';
// import '../../../../cores/utils/validation_utils.dart';
// import '../blocs/otp_pin/otp_pin_bloc.dart';

// class CountdownPinWidget extends StatelessWidget {
//   final String? parentScreenName;
//   final String? username;
//   // final OtpChooseEntity? otpChooseEntity;
//   const CountdownPinWidget({
//     super.key,
//     this.parentScreenName,
//     this.username,
//     // this.otpChooseEntity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     int countdownTime = 60;
//     return BlocProvider(
//       create: (context) => CountdownCubit()..startCountdown(countdownTime),
//       child: BlocListener<OtpPinBloc, OtpPinState>(
//         listener: (context, state) {
//           if (state is OtpPinSuccess) {
//             if (state.otp == OtpForgotPin.resend) {
//               context.read<CountdownCubit>().startCountdown(countdownTime);
//             }
//           }
//         },
//         child: Column(
//           children: [
//             Text(
//               t.lblRemainingTime,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: clrWhite,
//               ),
//             ),
//             const SizedBox(height: 2),
//             _Content(
//               t: t,
//               parentScreenName: parentScreenName,
//               username: username,
//               // otpChooseEntity: otpChooseEntity,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Content extends StatelessWidget {
//   final AppLocalizations t;
//   final String? parentScreenName;
//   final String? username;
//   // final OtpChooseEntity? otpChooseEntity;
//   const _Content({
//     Key? key,
//     required this.t,
//     this.parentScreenName,
//     this.username,
//     // this.otpChooseEntity,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         context.read<CountdownCubit>().stopCountdown();
//         return true;
//       },
//       child: BlocBuilder<CountdownCubit, String?>(
//         builder: (context, state) {
//           return InkWell(
//             onTap: state == null
//                 ? () {
//                     context.read<OtpPinBloc>().add(OtpReSendPressed(
//                           username: username ?? '',
//                           otpType:
//                               ValidationUtils.email(username ?? '') ? 0 : 1,
//                         ));
//                   }
//                 : null,
//             child: Text(
//               state ?? t.lblResendOtp,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 color: clrWhite,
//                 decoration: state == null ? TextDecoration.underline : null,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
