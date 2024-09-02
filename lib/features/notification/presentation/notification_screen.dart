import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/transaction_detail_type.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/models/data_with_meta.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/notification_entity.dart';
import 'blocs/notification_oth/notification_oth_bloc.dart';
import 'blocs/notification_read/notification_read_bloc.dart';
import 'cubits/notification/notification_cubit.dart';
import 'widgets/notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NotificationOthBloc>()
            ..add(NotificationOthGetEvent(
              page: 1,
            )),
        ),
        BlocProvider(
          create: (context) => sl<NotificationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationReadBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NotificationOthBloc, NotificationOthState>(
            listener: (context, state) {
              if (state is NotificationOthLoadingState) {
                context.read<NotificationCubit>().updateLoadingTrue();
              }
              if (state is NotificationOthSuccessState) {
                context.read<NotificationCubit>().updateNotification(
                      page: state.metaData?.page ?? 1,
                      notifs: state.notificationAdjust?.notifications ?? [],
                      unreadNotif:
                          state.notificationAdjust?.unreadNotifications ?? 0,
                      metaData: state.metaData,
                    );
              }
              if (state is NotificationOthFailureState) {
                context.read<NotificationCubit>().updateErrorTrue();
              }
            },
          ),
          BlocListener<NotificationReadBloc, NotificationReadState>(
            listener: (context, state) {
              if (state is NotificationReadLoadingState) {
                EasyLoading.show();
              }
              if (state is NotificationReadSuccessState) {
                if (state.notificationEntity != null) {
                  _onNotifClicked(state.notificationEntity, context);
                } else {
                  context.read<NotificationCubit>().makeReadAll();
                }
                context.read<HelperDataCubit>().updateUserData(null);
                EasyLoading.dismiss();
              }
              if (state is NotificationReadFailureState) {
                EasyLoading.dismiss();
                if (state.appFailure is ServerFailure) {
                  context.goNamed(
                    AppRoutes.serverError,
                    extra: {
                      "eliteCubit": context.read<EliteCubit>(),
                      "parentScreenName": AppRoutes.notification,
                    },
                  );
                  return;
                }
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
            },
          ),
        ],
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
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<NotificationOthBloc, NotificationOthState>(
          builder: (context, state) {
            if (state is NotificationOthFailureState) {
              if (state.appFailure is ServerFailure) {
                return Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  appBar: AppBar(
                    backgroundColor: clrBlack101,
                    title: const Text("Error"),
                    centerTitle: true,
                    leading: MainBackButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.beranda);
                      },
                    ),
                  ),
                  body: const ServerErrorScreen(),
                );
              }
            }
            return Scaffold(
              backgroundColor: isElite ? clrBackgroundBlack : null,
              appBar: AppBar(
                title: Text(
                  t.lblNotification,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                ),
                centerTitle: true,
                backgroundColor: clrBackgroundBlack,
                leading: MainBackButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.beranda);
                  },
                ),
              ),
              body: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _notificationWidget(
                        notifications: state.notifications,
                        metaData: state.meta,
                        isLoading: state.isLoading,
                        isError: state.isError,
                        isElite: isElite,
                        context: context,
                      ),
                      if (state.unreadNotif > 0)
                        Positioned(
                          bottom: 32,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MainButton(
                                label: 'Tandai Semua Dibaca',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: clrBackgroundBlack,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                onPressed: () {
                                  context
                                      .read<NotificationReadBloc>()
                                      .add(const NotificationReadAllNowEvent());
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _notificationWidget({
    required List<NotificationEntity> notifications,
    required MetaDataApi? metaData,
    required bool isLoading,
    required bool isError,
    required bool isElite,
    required BuildContext context,
  }) {
    if (notifications.isEmpty) {
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(imgPeopleRedeemWrong),
          ),
          const SizedBox(height: 32),
          Text(
            'tidak ada notifikasi',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : null,
            ),
          ),
        ],
      );
    }
    final bool isLastPage = metaData?.page == metaData?.totalPage;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationCubit>().resetNotification();
        context.read<NotificationOthBloc>().add(NotificationOthGetEvent(
              page: 1,
            ));
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: notifications.length + (isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (isLastPage == false &&
              (index == notifications.length - 2) &&
              isLoading == false) {
            context
                .read<NotificationOthBloc>()
                .add(NotificationOthGetEvent(page: (metaData?.page ?? 0) + 1));
          }
          if (index == notifications.length) {
            if (isError) {
              return Center(
                child: _errorDialog(context),
              );
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return NotificationWidget(
            title: notifications[index].title ?? '-',
            subTitle: notifications[index].body,
            date: (notifications[index].createdAt ?? '').toDateStr(),
            textColor: isElite ? clrWhite : clrBackgroundBlack,
            iconUrl: notifications[index].imageUrl,
            bgColor: notifications[index].isRead == 1
                ? null
                : clrYellow.withOpacity(0.1),
            onNotifPressed: () {
              if (notifications[index].isRead == 1) {
                _onNotifClicked(notifications[index], context);
                return;
              }
              context
                  .read<NotificationReadBloc>()
                  .add(NotificationReadNowEvent(notifications[index]));
            },
          );
        },
      ),
    );
  }

  Widget _errorDialog(BuildContext context, {String? message}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ?? 'An error occurred when fetching the data.',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          const Icon(Icons.refresh)
        ],
      ),
    );
  }
}

void _onNotifClicked(
  NotificationEntity? notificationEntity,
  BuildContext context,
) {
  String routeName = '';
  Map<String, dynamic> extra = {};
  context.read<NotificationCubit>().makeRead(notificationEntity);
  if ((notificationEntity?.transactionCode ?? '').isNotEmpty) {
    routeName = AppRoutes.paymentWaiting;
    extra = {
      'eliteCubit': context.read<EliteCubit>(),
      'transactionCode': notificationEntity?.transactionCode,
      'transactionDetailType': TransactionDetailType.general,
      'backScreen': AppRoutes.notification,
    };
  }
  if ((notificationEntity?.promoId ?? 0) != 0) {
    routeName = AppRoutes.promoDetail;
    extra = {
      'eliteCubit': context.read<EliteCubit>(),
      'promoId': notificationEntity?.promoId,
      'backScreen': AppRoutes.notification,
    };
  }
  if ((notificationEntity?.articleId ?? 0) != 0) {
    routeName = AppRoutes.articleDetail;
    extra = {
      'eliteCubit': context.read<EliteCubit>(),
      'articleId': notificationEntity?.articleId,
      'backScreen': AppRoutes.notification,
    };
  }
  //
  if (routeName.isNotEmpty) {
    context.goNamed(
      routeName,
      extra: extra,
    );
  }
}
