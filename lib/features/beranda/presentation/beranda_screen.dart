import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/kyc_status.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/bottom_sheet_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/banner_promo_widget.dart';
import '../../../cores/widgets/dragable_fab_widget.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_carousel.dart';
import '../../../cores/widgets/main_grid_view.dart';
import '../../_core/user/domain/entities/user_data_entity.dart';
import '../../profile/presentation/blocs/profile/profile_bloc.dart';
import '../../profile/presentation/widgets/profile_widget.dart';
import '../domain/entities/promo_entity.dart';
import 'blocs/balance/balance_bloc.dart';
import 'blocs/beranda_articles/beranda_articles_bloc.dart';
import 'blocs/beranda_menus/beranda_menus_bloc.dart';
import 'blocs/beranda_promo/beranda_promo_bloc.dart';
import 'blocs/price_setting/price_setting_bloc.dart';
import 'cubits/fab_cubit/fab_cubit.dart';
import 'widgets/account_balance_widget.dart';
import 'widgets/home_gold_balance_card.dart';
import 'widgets/news_info_card.dart';

void _refresh(BuildContext context) {
  context.read<BerandaBalancesBloc>().add(BerandaBalancesGetEvent(
        helperDataCubit: context.read<HelperDataCubit>(),
      ));
  context.read<ProfileBloc>().add(ProfileGetDataEvent(
        eliteCubit: context.read<EliteCubit>(),
        helperDataCubit: context.read<HelperDataCubit>(),
      ));
  context.read<PriceSettingBloc>().add(PriceSettingGetEvent(
        helperDataCubit: context.read<HelperDataCubit>(),
        isNeedRefresh: true,
      ));
  context.read<BerandaArticlesBloc>().add(BerandaArticlesGetEvent(
        helperDataCubit: context.read<HelperDataCubit>(),
      ));
}

class BerandaScreen extends StatelessWidget {
  BerandaScreen({super.key});

  final GlobalKey _parentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState) {
          int ktpStatus =
              state.userDataEntity?.kycEntity?.objectKyc?['ktp']?.status ?? 0;
          int selfieStatus =
              state.userDataEntity?.kycEntity?.objectKyc?['selfie']?.status ??
                  0;
          int npwpStatus =
              state.userDataEntity?.kycEntity?.objectKyc?['npwp']?.status ?? 0;
          int bankAccountStatus = state.userDataEntity?.kycEntity
                  ?.objectKyc?['account_number']?.status ??
              0;
          bool isNeedVerificationKtp = (ktpStatus == KycStatus.unverified) ||
              ktpStatus == KycStatus.rejected;
          bool isNeedVerificationSelfie =
              (selfieStatus == KycStatus.unverified) ||
                  selfieStatus == KycStatus.rejected;
          bool isNeedVerificationNpwp = (npwpStatus == KycStatus.unverified) ||
              npwpStatus == KycStatus.rejected;
          bool isNeedVerificationBank =
              (bankAccountStatus == KycStatus.unverified) ||
                  bankAccountStatus == KycStatus.rejected;
          if (isNeedVerificationKtp ||
              isNeedVerificationSelfie ||
              isNeedVerificationNpwp ||
              isNeedVerificationBank) {
            if (context.read<HelperDataCubit>().state.isShowPopupVerification) {
              DialogUtils.confirm(
                context: context,
                firstDesc: 'Verifikasi akun kamu belum lengkap nih!',
                secondDesc:
                    'Ayo lengkapi verifikasi akun kamu untuk mengakses seluruh fitur aplikasi',
                btnText: 'Verifikasi Sekarang',
                btnConfirm: () {
                  context.goNamed(
                    AppRoutes.accountVerification,
                    extra: {
                      'isElite': context.read<EliteCubit>().state.toString(),
                    },
                  );
                },
                btnTextLater: 'Nanti Saja',
                btnLater: () => context.pop(),
              );
              context
                  .read<HelperDataCubit>()
                  .updateShowPopupVerification(false);
            }
          }
        }
      },
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          var profileBloc = context.watch<ProfileBloc>();
          var profileState = profileBloc.state;
          if (profileState is ProfileFailureState) {
            if (profileState.appFailure is ServerFailure) {
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
                body: ServerErrorScreen(
                  onTryAgainPressed: () {
                    _refresh(context);
                  },
                ),
              );
            }
          }
          var balanceBloc = context.watch<BerandaBalancesBloc>();
          var balanceState = balanceBloc.state;
          if (balanceState is BerandaBalancesFailureState) {
            if (balanceState.appFailure is ServerFailure) {
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
                body: ServerErrorScreen(
                  onTryAgainPressed: () {
                    _refresh(context);
                  },
                ),
              );
            }
          }
          return RefreshIndicator(
            color: clrYellow,
            onRefresh: () async {
              context.read<HelperDataCubit>().updateUserData(null);
              context.read<HelperDataCubit>().updateBalances([]);
              context.read<HelperDataCubit>().updatePriceSettingsBuyGold(null);
              context.read<HelperDataCubit>().updatePriceSettingsSellGold(null);
              context.read<HelperDataCubit>().updateArticle([]);
              context.read<HelperDataCubit>().resetPaymentMethods();
              _refresh(context);
            },
            child: Scaffold(
              backgroundColor: isElite ? clrBackgroundBlack : null,
              body: Stack(
                key: _parentKey,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _topBanner(isEliteMode: isElite),
                        _accountInformation(isEliteMode: isElite),
                        const SizedBox(height: 24),
                        _menus(context: context, isEliteMode: isElite),
                        const Divider(
                          height: 41,
                          indent: 20,
                          endIndent: 20,
                        ),
                        _newsAndInfo(context: context, isEliteMode: isElite),
                        const SizedBox(height: 24),
                        _upcomingFeatures(
                          context: context,
                          isEliteMode: isElite,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  BlocBuilder<FabCubit, FabState>(
                    builder: (context, state) {
                      if (state.isGachaPonShowed == true) {
                        return DraggableFabWidget(
                          parentKey: _parentKey,
                          initialOffset: Offset(
                            MediaQuery.of(context).size.width - 80,
                            MediaQuery.of(context).size.height - 200,
                          ),
                          child: _fab(
                            backgroundAsset: icEclipseBlack,
                            boxAsset: icBoxGachaPon,
                            content: const Text('GATCHA PON',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w800,
                                )),
                            onTap: () {
                              context.goNamed(AppRoutes.gachaPon);
                            },
                            onTapClose: () =>
                                context.read<FabCubit>().closeFabGacha(),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  // Align(
                  //   alignment: Alignment.bottomLeft,
                  //   child: _fabGiftBox(
                  //     backgroundAsset: icEclipseYellow,
                  //     boxAsset: icGiftBoxBlack,
                  //     content: const Column(
                  //       children: [
                  //         Text('Kamu Punya',
                  //             style: TextStyle(
                  //               fontSize: 6,
                  //               fontWeight: FontWeight.w700,
                  //             )),
                  //         Text('1 Laku Gift',
                  //             style: TextStyle(
                  //               fontSize: 8,
                  //               fontWeight: FontWeight.w800,
                  //             )),
                  //       ],
                  //     ),
                  //     onTap: () {},
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _fab({
    String? backgroundAsset,
    String? boxAsset,
    Widget? content,
    VoidCallback? onTap,
    VoidCallback? onTapClose,
  }) {
    return Container(
      height: 84,
      width: 80,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 56,
              width: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundAsset ?? icEclipseYellow),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(
                boxAsset ?? icGiftBoxBlack,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 24,
              width: 60,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: clrYellow,
              ),
              alignment: Alignment.center,
              child: content,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTapClose,
              child: Icon(
                Icons.close,
                color: clrNeutralGrey999,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBanner({bool isEliteMode = false}) {
    double height = 192;
    return LayoutBuilder(builder: (context, ctr) {
      if (ctr.maxWidth > 627) {
        height = 222;
      }
      if (ctr.maxWidth > 1240) {
        height = 252;
      }
      return BlocBuilder<BerandaPromoBloc, BerandaPromoState>(
        builder: (context, state) {
          List<PromoEntity> contents = [];
          if (state is BerandaPromosSuccessState) {
            contents = state.promoEntities;
          }
          return BannerPromoWidget(
            isEliteMode: isEliteMode,
            height: height,
            isAutoScroll: false,
            autoScrollDelayInSec: 10,
            contents: contents
                .map((e) => GestureDetector(
                      onTap: () {
                        context.goNamed(
                          AppRoutes.promoDetail,
                          extra: {
                            'eliteCubit': context.read<EliteCubit>(),
                            'promoEntity': e,
                            'berandaPromoBloc':
                                context.read<BerandaPromoBloc>(),
                          },
                        );
                      },
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Image.network(
                          e.imageUrl ?? '',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              '\n\nNo Image',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                color:
                                    isEliteMode ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      );
    });
  }

  Widget _accountInformation({bool isEliteMode = false}) {
    double cardHeight = 420;
    double bgBlackHeight = 390;
    double homeGoldBalanceCard = 254;
    double accBalanceTop = cardHeight - 64;
    return LayoutBuilder(builder: (context, ctr) {
      if (ctr.maxWidth > 627) {
        cardHeight = 458;
        bgBlackHeight = 428;
        homeGoldBalanceCard = 284;
        accBalanceTop = cardHeight - 68;
      }
      if (ctr.maxWidth > 1240) {
        cardHeight = 496;
        bgBlackHeight = 466;
        homeGoldBalanceCard = 300;
        accBalanceTop = cardHeight - 80;
      }
      return SizedBox(
        height: cardHeight,
        child: Stack(
          children: [
            Container(
              height: bgBlackHeight,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        isEliteMode ? imgBackgroundGold : imgBackgroundBlack),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProfileWidget(
                    isAtHome: true,
                    isElite: isEliteMode,
                  ),
                  const SizedBox(height: 20),
                  HomeGoldBalanceCard(
                      isElite: isEliteMode, height: homeGoldBalanceCard),
                ],
              ),
            ),
            Positioned.fill(
              top: accBalanceTop,
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AccountBalanceWidget(isElite: isEliteMode),
              ),
            ),
          ],
        ),
      );
    });
  }

  Padding _menus({required BuildContext context, bool isEliteMode = false}) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BlocBuilder<BerandaMenusBloc, BerandaMenusState>(
        builder: (context, state) {
          if (state is BerandaMenusLoadingState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  4,
                  (index) => Shimmer.fromColors(
                        baseColor: clrGreyShimmerBase,
                        highlightColor: clrGreyShimmerHighlight,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: clrWhite,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )),
            );
          }
          if (state is BerandaMenusSuccessState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.menuSecondary
                  .map(
                    (e) => _icon(
                      context: context,
                      icon: _assetIconSecondary(e.id ?? 0),
                      label: e.id == 0 ? t.lblOthers : e.name,
                      labelColor: isEliteMode ? clrGreyF2f : clrBackgroundBlack,
                      onTap: () {
                        if (e.isActive == 1) {
                          menuOnTap(
                            context,
                            e.id ?? 0,
                            isEliteMode,
                            context
                                .read<HelperDataCubit>()
                                .state
                                .userDataEntity,
                          );
                        } else {
                          EasyLoading.showToast(
                            'your account cant access this menu',
                            toastPosition: EasyLoadingToastPosition.bottom,
                            maskType: EasyLoadingMaskType.black,
                            dismissOnTap: true,
                          );
                        }
                      },
                    ),
                  )
                  .toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _icon(
      {required BuildContext context,
      required String icon,
      String? label,
      Color? labelColor,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            height: 52,
            width: 52,
          ),
          if (label != null) const SizedBox(height: 6),
          if (label != null)
            Text(
              label,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            )
        ],
      ),
    );
  }

  String _assetIconSecondary(int id) {
    switch (id) {
      case 0:
        return icGoldOthers;
      case 1:
        return icGoldBuyReguler;
      case 2:
        return icGoldSellReguler;
      case 3:
        return icGoldRedeemReguler;
      case 4:
        return icGoldPhysicalPull;
      case 5:
        return icGoldSaveReguler;
      case 6:
        return icGoldTrade;
      case 7:
        return icGoldTransfer;
      case 8:
        return icGoldCoupon;
      default:
        return icGoldOthers;
    }
  }

  Widget _newsAndInfo(
      {required BuildContext context, bool isEliteMode = false}) {
    final t = AppLocalizations.of(context)!;
    final controller = PageController(viewportFraction: 1, keepPage: true);
    double cardHeight = 262;
    return LayoutBuilder(builder: (context, ctr) {
      if (ctr.maxWidth > 627) {
        cardHeight = 350;
      }
      if (ctr.maxWidth > 1240) {
        cardHeight = 438;
      }
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${t.lblNews} & Info',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isEliteMode ? clrWhiteFef : clrDarkBlue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(AppRoutes.article, extra: {
                        'isElite': isEliteMode.toString(),
                      });
                    },
                    child: Text(
                      t.lblSeeAll(t.lblArticle),
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: isEliteMode
                            ? clrYellow
                            : clrBackgroundBlack.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: cardHeight,
              child: BlocBuilder<BerandaArticlesBloc, BerandaArticlesState>(
                builder: (context, state) {
                  if (state is BerandaArticlesLoadingState) {
                    return MainCarousel(
                      controller: controller,
                      isArrow: false,
                      isDots: false,
                      contents: List.generate(
                          3,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Shimmer.fromColors(
                                  baseColor: clrGreyShimmerBase,
                                  highlightColor: clrGreyShimmerHighlight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: clrWhite,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              )),
                    );
                  }
                  if (state is BerandaArticlesSuccessState) {
                    return MainCarousel(
                      controller: controller,
                      isArrow: false,
                      isDots: false,
                      contents: state.articles
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                context.goNamed(
                                  AppRoutes.articleDetail,
                                  extra: {
                                    'isElite': isEliteMode.toString(),
                                    'eliteCubit': context.read<EliteCubit>(),
                                    'articleEntity': e,
                                    'backScreen': AppRoutes.beranda,
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: NewsInfoCard(
                                  imageUrl: e.image,
                                  title: e.title ?? '-',
                                  titleColor: isEliteMode
                                      ? clrWhiteFef
                                      : clrBackgroundBlack,
                                  subTitle: e.smText,
                                  subTitleColor: isEliteMode
                                      ? clrNeutralGrey999
                                      : clrBlack3e3,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _upcomingFeatures(
      {required BuildContext context, bool isEliteMode = false}) {
    final t = AppLocalizations.of(context)!;
    final controller = PageController(viewportFraction: 1, keepPage: true);
    double cardHeight = 128;
    return LayoutBuilder(builder: (context, ctr) {
      if (ctr.maxWidth > 627) {
        cardHeight = 184;
      }
      if (ctr.maxWidth > 1240) {
        cardHeight = 240;
      }
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.lblUpcomingFeatures,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEliteMode ? clrWhiteFef : clrDarkBlue,
                ),
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: cardHeight,
              child: MainCarousel(
                controller: controller,
                isDotsInStack: false,
                contents: [
                  Image.asset(imgLuckyDice),
                  Image.asset(imgLuckyDice),
                  Image.asset(imgLuckyDice),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

void menuOnTap(BuildContext context, int id, bool isElite,
    UserDataEntity? userDataEntity) {
  final AppLocalizations t = AppLocalizations.of(context)!;

  var kycStatusKtp = userDataEntity?.kycEntity?.objectKyc?['ktp']?.status == 1;
  var kycStatusNpwp =
      userDataEntity?.kycEntity?.objectKyc?['npwp']?.status == 1;

  switch (id) {
    case 0: // others menu
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              color: isElite ? clrBlack080 : clrWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.lblLakuemasFeatures,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                const SizedBox(height: 18),
                BlocBuilder<HelperDataCubit, HelperDataState>(
                  builder: (_, state) {
                    return MainGridView(
                      allData: state.berandaMenus,
                      maxColumn: (_) => 4,
                      vertMargin: 32,
                      child: (value, ctr) {
                        return _icon(
                          context: context,
                          icon: _assetIconOthers(value.id ?? 0),
                          label: value.id == 0 ? t.lblOthers : value.name,
                          labelColor: isElite ? clrWhite : clrBackgroundBlack,
                          onTap: () => menuOnTap(
                            context,
                            (value.id ?? 0),
                            isElite,
                            state.userDataEntity,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
      break;
    case 1:
      context.goNamed(
        AppRoutes.buyGold,
        extra: {
          'isElite': isElite.toString(),
          'backScreenBuyGold': AppRoutes.beranda
        },
      );
      break;
    case 2:
      context.goNamed(
        AppRoutes.sellGold,
        extra: {'isElite': isElite.toString()},
      );
      break;
    case 3:
      context.goNamed(
        AppRoutes.redeem,
        extra: {
          'isElite': isElite.toString(),
          'priceSettingBloc': context.read<PriceSettingBloc>()
        },
      );
      break;
    case 4:
      context.goNamed(
        AppRoutes.physicalTrade,
        extra: {'isElite': isElite.toString()},
      );
      break;
    case 5:
      if (kycStatusKtp && kycStatusNpwp) {
        context.goNamed(
          AppRoutes.lakuSave,
          extra: {
            'isElite': isElite.toString(),
            'berandaBalancesBloc': context.read<BerandaBalancesBloc>()
          },
        );
      } else {
        BottomSheetUtils.verification(
          context: context,
          words: wordingKyc(kycStatusKtp, kycStatusNpwp),
        );
      }
      break;
    case 6:
      context.goNamed(
        AppRoutes.lakuTrade,
        extra: {'isElite': isElite.toString()},
      );
      break;
    case 7:
      context.goNamed(
        AppRoutes.transfer,
        extra: {
          'isElite': isElite.toString(),
          'berandaBalancesBloc': context.read<BerandaBalancesBloc>()
        },
      );
      break;
    case 8:
      context.goNamed(AppRoutes.couponRedeem, extra: {
        'isElite': isElite.toString(),
        'paymentCubit': null,
        'backScreen': AppRoutes.beranda,
      });
      break;
    case 9:
      context.goNamed(
        AppRoutes.physicalTrade,
        extra: {'isElite': isElite.toString()},
      );
      break;
    default:
  }
}

Widget _icon(
    {required BuildContext context,
    required String icon,
    String? label,
    Color? labelColor,
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Image.asset(
          icon,
          height: 52,
          width: 52,
        ),
        if (label != null) const SizedBox(height: 6),
        if (label != null)
          Text(
            label,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          )
      ],
    ),
  );
}

String _assetIconOthers(int id) {
  switch (id) {
    case 0:
      return icGoldOthers;
    case 1:
      return icGoldBuy;
    case 2:
      return icGoldSell;
    case 3:
      return icGoldRedeem;
    case 4:
      return icGoldPhysicalPull;
    case 5:
      return icGoldSave;
    case 6:
      return icGoldTrade;
    case 7:
      return icGoldTransfer;
    case 8:
      return icGoldCoupon;
    default:
      return icGoldOthers;
  }
}

String wordingKyc(bool statusKycKtp, bool statusKycNpwp) {
  if (statusKycKtp == false && statusKycNpwp == false) {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan NPWP untuk dapat akses menu Laku Simpan';
  } else if (statusKycKtp == false) {
    return 'Ayo lakukan verifikasi KTP dan Foto Selfi untuk dapat akses menu Laku Simpan';
  } else if (statusKycNpwp == false) {
    return 'Ayo lakukan verifikasi NPWP untuk dapat akses menu Laku Simpan';
  } else {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan NPWP untuk dapat akses menu Laku Simpan';
  }
}
