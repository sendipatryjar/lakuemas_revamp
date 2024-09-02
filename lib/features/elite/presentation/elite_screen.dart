import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/banner_promo_widget.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/price_entity.dart';
import '../data/models/elite_register_req.dart';
import '../domain/entities/faq_entity.dart';
import 'blocs/elite_blocs.dart';

class EliteScreen extends StatelessWidget {
  final EliteRegisterReq? eliteRegisterReq;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  const EliteScreen({
    super.key,
    this.eliteRegisterReq,
    this.isFromGrafik = false,
    this.priceEntity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetFaqBloc>()
            ..add(
              GetFaqEvents(
                helperDataEliteCubit: context.read<HelperDataEliteCubit>(),
              ),
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
          create: (context) => sl<EliteStartRegisterBloc>()
            ..add(
              EliteStartRegisterEvents(),
            ),
        ),
        BlocProvider(
          create: (context) => sl<EliteStartRegisterBloc>(),
        ),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _bannerElite(
                    isFromGrafik: isFromGrafik,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _marketingOption(),
                        _btnTermsCondition(context, isElite: isElite),
                        _accordionFaq(context),
                        _mainButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bannerElite({
    bool isFromGrafik = false,
  }) {
    return BlocBuilder<GetMarketingOptionBloc, GetMarketingOptionState>(
      builder: (context, state) {
        if (state is GetMarketingOptionLoadingState) {
          return Shimmer.fromColors(
            baseColor: clrGreyShimmerBase,
            highlightColor: clrGreyShimmerHighlight,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(color: clrWhite),
            ),
          );
        }
        if (state is GetMarketingSuccessState) {
          return BannerPromoWidget(
            isEliteMode: true,
            isAutoScroll: true,
            autoScrollDelayInSec: 10,
            isFromGrafik: isFromGrafik,
            contents: List.generate(
              state.getMarketingOptionEntity.marketingOptionImageEntity!.length,
              (index) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(state.getMarketingOptionEntity
                            .marketingOptionImageEntity?[index].image ??
                        ''),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        }
        if (state is GetMarketingFailureState) {
          return BannerPromoWidget(
            isEliteMode: true,
            isAutoScroll: true,
            autoScrollDelayInSec: 10,
            contents: List.generate(
              3,
              (index) => Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgBackgroundGold),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _marketingOption() {
    return BlocConsumer<GetMarketingOptionBloc, GetMarketingOptionState>(
      listener: (context, state) {
        if (state is GetMarketingOptionLoadingState) {
          EasyLoading.show();
        }
        if (state is GetMarketingSuccessState) {
          EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        if (state is GetMarketingSuccessState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                state.getMarketingOptionEntity.name ?? '',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: clrDarkBlue,
                ),
              ),
              const SizedBox(height: 16),
              Html(
                data: state.getMarketingOptionEntity.description,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    // fontSize: FontSize(12),
                    // lineHeight: const LineHeight(2.5),
                    color: clrBackgroundBlack.withOpacity(0.75),
                  )
                },
                // tagsList: Html.tags..remove("br"),
                doNotRenderTheseTags: const {'br'},
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  InkWell _btnTermsCondition(BuildContext context, {bool isElite = false}) {
    final t = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => context.goNamed(
        AppRoutes.eliteTermsCondition,
        extra: {
          'isElite': 'false',
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 16, bottom: 32),
        decoration: BoxDecoration(
          color: clrYellow.withOpacity(0.16),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Image.asset(icWarningOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                t.lblCheckTermsConditions,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: clrBackgroundBlack,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: clrBackgroundBlack.withOpacity(0.32),
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _accordionFaq(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblFaq,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: clrDarkBlue,
          ),
        ),
        const SizedBox(height: 10),
        BlocConsumer<GetFaqBloc, GetFaqState>(
          listener: (context, state) {
            if (state is GetFaqLoadingState) {
              EasyLoading.show();
            }
            if (state is GetFaqSuccessState) {
              EasyLoading.dismiss();
            }
          },
          builder: (context, state) {
            List<FaqEntity> items = [];

            if (state is GetFaqSuccessState) {
              items = state.data;

              return ExpansionPanelList.radio(
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                children: items.map<ExpansionPanelRadio>((FaqEntity faq) {
                  return ExpansionPanelRadio(
                    canTapOnHeader: true,
                    backgroundColor: Colors.transparent,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        child: Text(
                          faq.question ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: clrBackgroundBlack,
                          ),
                        ),
                      );
                    },
                    body: Text(
                      faq.answer ?? '',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrGrey666,
                      ),
                    ),
                    value: faq.question ?? '',
                  );
                }).toList(),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _mainButton(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocConsumer<EliteStartRegisterBloc, EliteStartRegisterState>(
      listener: (context, state) {
        if (state is EliteStartRegisterLoadingState) {
          EasyLoading.show();
        }
        if (state is EliteStartRegisterSuccessState) {
          EasyLoading.dismiss();
          DialogUtils.confirm(
            context: context,
            barrierDismissible: true,
            isShowIcon: false,
            firstDesc: t.lblDoYouHaveReferal,
            btnText: t.lblHaveReferal,
            btnTextLater: t.lblNotHaveReferal,
            btnConfirm: () {
              context.goNamed(AppRoutes.eliteReferal);
              context.pop();
            },
            btnLater: () {
              context.goNamed(
                AppRoutes.eliteSubscriptionMethod,
                extra: {
                  'eliteRegisterReq': EliteRegisterReq(referalCode: ''),
                  'eliteCubit': context.read<EliteCubit>(),
                },
              );
            },
          );
        }
        if (state is EliteStartRegisterFailureState) {
          EasyLoading.showError(
            errorMessage(state.appFailure) ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
          // Future.delayed(const Duration(seconds: 2)).then((value) {
          //   context.goNamed(AppRoutes.elite, extra: {'isElite' : });
          // });
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 20, bottom: 60),
          width: double.infinity,
          child: MainButton(
            label: t.lblSubcribeToElite,
            onPressed: () {
              context
                  .read<EliteStartRegisterBloc>()
                  .add(EliteStartRegisterEvents());
            },
          ),
        );
      },
    );
  }
}
