import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/main_icon_circle.dart';
import '../blocs/profile/profile_bloc.dart';

class ProfileWidget extends StatelessWidget {
  final bool isAtHome;
  final bool isElite;
  const ProfileWidget({super.key, this.isAtHome = false, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SizedBox(
      child: Row(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String backgroundImage = '';
              if (state is ProfileSuccessState &&
                  (state.userDataEntity?.avatarUrl ?? '').isNotEmpty) {
                backgroundImage = state.userDataEntity?.avatarUrl ?? '';
              }
              return CircleAvatar(
                backgroundColor: clrBlack040.withOpacity(0.8),
                child: Image.network(
                  backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(icProfile, fit: BoxFit.cover),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String name = '-';
                  if (state is ProfileSuccessState) {
                    name = state.userDataEntity?.name ?? '';
                  }
                  return Text(
                    t.lblHi(name),
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? (isAtHome ? clrDarkBrown : clrWhite)
                          : clrWhite,
                    ),
                  );
                },
              ),
              isElite
                  ? Row(
                      children: [
                        Image.asset(
                          icEliteColorfull,
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.lblEliteMember,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: (isElite
                                    ? (isAtHome ? clrDarkBrown : clrWhite)
                                    : clrWhite)
                                .withOpacity(0.75),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      t.lblRegularMember,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (isElite ? clrDarkBrown : clrWhite)
                            .withOpacity(0.75),
                      ),
                    ),
            ],
          ),
          const Spacer(),
          isAtHome ? _trailingAtHome(context) : _trailingAtProfile(context, t),
        ],
      ),
    );
  }

  SizedBox _trailingAtProfile(BuildContext context, AppLocalizations t) {
    return SizedBox(
      height: 24,
      child: MainButton(
        label: t.lblCreateAvatar,
        labelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: clrDarkBrown,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        bgColor: clrYellow,
        borderRadius: 30,
        onPressed: () {
          context.goNamed(
            AppRoutes.avatar,
            extra: {'isElite': isElite.toString()},
          );
        },
      ),
    );
  }

  Row _trailingAtHome(BuildContext context) {
    return Row(
      children: [
        // MainIconCircle(
        //   icon: Icons.search,
        //   isElite: isElite,
        // ),
        // const SizedBox(width: 16),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            int unreadNotif = 0;
            if (state is ProfileSuccessState) {
              unreadNotif = state.userDataEntity?.unreadNotifications ?? 0;
            }
            return MainIconCircle(
              icon: Icons.notifications_none,
              flag: unreadNotif > 0
                  ? Icon(
                      Icons.circle,
                      color: clrRed,
                      size: 10,
                    )
                  : null,
              isElite: isElite,
              onTap: () => context.goNamed(AppRoutes.notification, extra: {
                'eliteCubit': context.read<EliteCubit>(),
              }),
            );
          },
        ),
      ],
    );
  }
}
