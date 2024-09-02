import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/support_contact/support_contact_bloc.dart';

class SupportScreen extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const SupportScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (context.read<SupportContactBloc>().state
        is SupportContactFailureState) {
      context.read<SupportContactBloc>().add(SupportContactGetEvent());
    }
    return BlocListener<SupportContactBloc, SupportContactState>(
      listener: (context, state) {
        if (state is SupportContactLoadingState) {
          EasyLoading.show();
        }
        if (state is SupportContactSuccessState) {
          EasyLoading.dismiss();
        }
        if (state is SupportContactFailureState) {
          EasyLoading.showError(
            errorMessage(state.appFailure) ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
        }
      },
      child: _Content(key: key, t: t, extra: extra),
    );
  }
}

class _Content extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const _Content({
    super.key,
    required this.t,
    this.extra,
  });

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblSupport,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(
                  extra?['backScreen'] ?? AppRoutes.profile,
                  extra: extra,
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.12)
                        : clrGreyE5e.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: isElite
                            ? clrNeutralGrey999.withOpacity(0.16)
                            : clrBackgroundBlack.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        dense: true,
                        title: Text(
                          'FAQ',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isElite ? clrWhite.withOpacity(0.32) : null,
                        ),
                        onTap: () => context.goNamed(
                          AppRoutes.faq,
                          extra: {
                            'eliteCubit': context.read<EliteCubit>(),
                            ...(extra ?? {})
                          },
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: clrBackgroundBlack.withOpacity(0.08),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        title: Text(
                          'Chat ${t.lblUs}',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isElite ? clrWhite.withOpacity(0.32) : null,
                        ),
                        onTap: () => context.goNamed(
                          AppRoutes.chatUs,
                          extra: {
                            'eliteCubit': context.read<EliteCubit>(),
                            ...(extra ?? {})
                          },
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: clrBackgroundBlack.withOpacity(0.08),
                      ),
                      BlocBuilder<SupportContactBloc, SupportContactState>(
                        builder: (context, state) {
                          String email = '';
                          if (state is SupportContactSuccessState) {
                            email = state.email ?? '';
                          }
                          return InkWell(
                            onTap: () {
                              if (email.isNotEmpty) {
                                AppUtils.sendEmailTo(email);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: (isElite
                                              ? clrWhite
                                              : clrBackgroundBlack)
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        email,
                                        textScaler: TextScaler.linear(
                                            TextUtils.textScaleFactor(context)),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (email.isNotEmpty) {
                                            Clipboard.setData(
                                                    ClipboardData(text: email))
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Email address copied to clipboard")));
                                            });
                                          }
                                        },
                                        child: Text(
                                          t.lblCopy,
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: clrBlue006,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: clrBackgroundBlack.withOpacity(0.08),
                      ),
                      BlocBuilder<SupportContactBloc, SupportContactState>(
                        builder: (context, state) {
                          String phone = '';
                          if (state is SupportContactSuccessState) {
                            phone = state.phone ?? '';
                          }
                          return InkWell(
                            onTap: () {
                              if (phone.isNotEmpty) {
                                AppUtils.phoneCall(phone);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.lblPhoneNumber,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: (isElite
                                              ? clrWhite
                                              : clrBackgroundBlack)
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    phone,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: clrBlue006,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
