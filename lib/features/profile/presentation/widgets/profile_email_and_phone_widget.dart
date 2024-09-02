import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/profile/profile_bloc.dart';

class ProfileEmailAndPhoneWidget extends StatelessWidget {
  const ProfileEmailAndPhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: clrGreyE5e.withOpacity(0.03),
        border: Border.all(color: clrNeutralGrey999.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String email = '-';
              bool isEmailVerified = true;
              if (state is ProfileSuccessState) {
                email = state.userDataEntity?.email ?? '-';
                isEmailVerified = state.userDataEntity?.isEmailVerified == 1;
              }
              return _label(
                context: context,
                forWhat: 'email',
                title: 'Email yang digunakan',
                value: email,
                isVerified: isEmailVerified,
              );
            },
          ),
          Divider(
            color: clrNeutralGrey999.withOpacity(0.16),
            height: 33,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String? phone = '-';
              bool isPhoneVerified = true;
              if (state is ProfileSuccessState) {
                phone = state.userDataEntity?.handphone ?? '-';
                isPhoneVerified =
                    state.userDataEntity?.isPhoneNumberVerified == 1;
              }
              return _label(
                context: context,
                forWhat: 'phone',
                title: 'Nomor yang digunakan',
                value: phone,
                isVerified: isPhoneVerified,
              );
            },
          ),
        ],
      ),
    );
  }

  Column _label({
    required BuildContext context,

    /// email or phone
    String? forWhat,
    String? title,
    String? value,
    bool isVerified = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title ?? '',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: clrWhite.withOpacity(0.5),
                ),
              ),
            ),
            if (isVerified == false)
              InkWell(
                onTap: () {
                  if (forWhat == 'email') {
                    context.goNamed(
                      AppRoutes.emailUpdate,
                      extra: {
                        'bloc': context.read<ProfileBloc>(),
                        'email': value,
                      },
                    );
                  }
                  if (forWhat == 'phone') {
                    context.goNamed(
                      AppRoutes.phoneNumberUpdate,
                      extra: {
                        'bloc': context.read<ProfileBloc>(),
                        'phoneNumber': value,
                      },
                    );
                  }
                },
                child: Icon(
                  Icons.edit_square,
                  size: 16,
                  color: clrNeutralGrey999,
                ),
              ),
          ],
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Row(
              children: [
                Text(
                  value ?? '',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isVerified ? clrWhite : clrRed,
                  ),
                ),
                if (isVerified == false) ...[
                  const SizedBox(width: 6),
                  Image.asset(
                    icWarningRed,
                    height: 16,
                    width: 16,
                  ),
                ]
              ],
            );
          },
        ),
      ],
    );
  }
}
