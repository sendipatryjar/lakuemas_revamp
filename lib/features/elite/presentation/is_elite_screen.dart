import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../features/elite/data/models/elite_models.dart';
import '../../../features/elite/presentation/blocs/elite_me/elite_me_bloc.dart';
import '../../../features/elite/presentation/blocs/get_offers/get_offers_bloc.dart';
import '../../../features/elite/presentation/blocs/get_social_media_config/get_social_media_config_bloc.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/elite_start_register/elite_start_register_bloc.dart';
import 'blocs/get_marketing_option/get_marketing_option_bloc.dart';
import 'widgets/is_elite_home_section_widget.dart';
import 'widgets/is_elite_offers_section_widget.dart';
import 'widgets/is_elite_referral_section_widget.dart';

class IsEliteScreen extends StatelessWidget {
  final bool isFromHome;
  final bool isFromReferral;
  final bool isFromOffers;
  const IsEliteScreen({
    super.key,
    this.isFromHome = false,
    this.isFromReferral = false,
    this.isFromOffers = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EliteStartRegisterBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<EliteMeBloc>()
            ..add(
              EliteMeGetEvent(
                  helperDataEliteCubit: context.read<HelperDataEliteCubit>()),
            ),
        ),
        BlocProvider(
          create: (context) => sl<GetMarketingOptionBloc>()
            ..add(
              GetMarketingOptionEvents(
                  helperDataEliteCubit: context.read<HelperDataEliteCubit>()),
            ),
        ),
        BlocProvider(
          create: (context) => sl<GetOffersBloc>()
            ..add(
              GetOffersLoadEvent(
                  helperDataEliteCubit: context.read<HelperDataEliteCubit>()),
            ),
        ),
        BlocProvider(
          create: (context) => sl<GetSocialMediaConfigBloc>()
            ..add(
              GetSocialMediaConfigLoadEvent(
                  helperDataEliteCubit: context.read<HelperDataEliteCubit>()),
            ),
        ),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return BlocBuilder<EliteMeBloc, EliteMeState>(
            builder: (context, state) {
              if (state is EliteMeFailureState) {
                if (state.appFailure is ServerFailure) {
                  return Scaffold(
                    backgroundColor: isElite ? clrBlack080 : null,
                    appBar: AppBar(
                      backgroundColor: clrBlack101,
                      title: Text(
                        "Error",
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                      ),
                      centerTitle: true,
                      leading: MainBackButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.beranda);
                        },
                      ),
                    ),
                    body: ServerErrorScreen(
                      onTryAgainPressed: () {
                        context.read<EliteMeBloc>().add(
                              EliteMeGetEvent(
                                  helperDataEliteCubit:
                                      context.read<HelperDataEliteCubit>()),
                            );
                      },
                    ),
                  );
                }
              }
              return BlocBuilder<GetOffersBloc, GetOffersState>(
                builder: (context, state) {
                  if (state is GetOffersFailureState) {
                    if (state.appFailure is ServerFailure) {
                      return Scaffold(
                        backgroundColor: isElite ? clrBlack080 : null,
                        appBar: AppBar(
                          backgroundColor: clrBlack101,
                          title: Text(
                            "Error",
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                          ),
                          centerTitle: true,
                          leading: MainBackButton(
                            onPressed: () {
                              context.goNamed(AppRoutes.beranda);
                            },
                          ),
                        ),
                        body: ServerErrorScreen(
                          onTryAgainPressed: () {
                            context.read<GetOffersBloc>().add(
                                  GetOffersLoadEvent(
                                      helperDataEliteCubit:
                                          context.read<HelperDataEliteCubit>()),
                                );
                          },
                        ),
                      );
                    }
                  }
                  return DefaultTabController(
                    initialIndex: isFromHome
                        ? 0
                        : isFromReferral
                            ? 1
                            : isFromOffers
                                ? 2
                                : 0,
                    length: 3,
                    child: Scaffold(
                      backgroundColor: clrBackgroundBlack,
                      appBar: AppBar(
                        backgroundColor: clrBackgroundBlack,
                        centerTitle: true,
                        title: Text(
                          t.lblLakuemasElite,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: MainBackButton(
                          onPressed: () {
                            context.goNamed(AppRoutes.beranda);
                          },
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              context.goNamed(
                                AppRoutes.eliteHistory,
                                extra: {
                                  'backScreen': AppRoutes.elite,
                                  'eliteCubit': context.read<EliteCubit>(),
                                },
                              );
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(icHistory),
                                  // fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: clrBlack101,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _eliteDuration(t, context),
                                _tabBar(context),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                IsEliteHomeSectionWidget(
                                  isElite: isElite,
                                ),
                                const IsEliteReferralSectionWidget(),
                                const IsEliteOffersSectionWidget(),
                                // const OfferSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _eliteDuration(AppLocalizations t, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                icEliteColorfull,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblActiveUntil,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 8,
                      color: clrWhiteFef,
                    ),
                  ),
                  BlocBuilder<EliteMeBloc, EliteMeState>(
                    builder: (context, state) {
                      String validUntil = '-';
                      if (state is EliteMeLoadingState) {
                        validUntil;
                      }
                      if (state is EliteMeSuccessState) {
                        validUntil =
                            state.eliteMeEntity.validUntil.toDateLongMonthStr();
                      }
                      return Text(
                        validUntil,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: clrWhiteFef,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<EliteMeBloc, EliteMeState>(
                    builder: (context, state) {
                      Duration? diff;
                      if (state is EliteMeSuccessState) {
                        var validUntil =
                            state.eliteMeEntity.validUntil.toDateTime();
                        var dateNow = DateTime.now();
                        diff = validUntil?.difference(dateNow);
                      }
                      if (diff?.inDays == null || (diff?.inDays ?? 10) > 7) {
                        return const SizedBox();
                      }
                      return Text(
                        'Berakhir dalam ${diff?.inDays} hari',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: clrRed,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              context
                  .read<EliteStartRegisterBloc>()
                  .add(EliteStartRegisterEvents());
              context.goNamed(
                AppRoutes.eliteSubscriptionMethod,
                extra: {
                  'eliteRegisterReq': EliteRegisterReq(),
                  'eliteCubit': context.read<EliteCubit>(),
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: clrNeutralGrey999.withOpacity(0.32),
              ),
              child: Text(
                t.lblAddActivePeriod,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: clrWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return TabBar(
      indicatorWeight: 3,
      indicatorColor: clrYellow,
      labelColor: clrWhite,
      unselectedLabelColor: clrWhite.withOpacity(0.50),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(text: t.lblHome),
        Tab(text: t.lblReferral),
        Tab(text: t.lblOffers),
      ],
    );
  }
}
