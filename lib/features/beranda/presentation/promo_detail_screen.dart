import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/promo_entity.dart';
import 'blocs/beranda_promo/beranda_promo_bloc.dart';
import 'blocs/beranda_promo_detail/beranda_promo_detail_bloc.dart';

class PromoDetailScreen extends StatelessWidget {
  final int? promoId;
  final PromoEntity? promoEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;
  const PromoDetailScreen({
    super.key,
    this.promoId,
    this.promoEntity,
    this.backScreen,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) {
        if (promoId != null) {
          return sl<BerandaPromoDetailBloc>()
            ..add(BerandaPromoDetailGetEvent(promoId));
        }
        return sl<BerandaPromoDetailBloc>();
      },
      child: BlocListener<BerandaPromoDetailBloc, BerandaPromoDetailState>(
        listener: (context, state) {
          if (state is BerandaPromoDetailLoadingState) {
            EasyLoading.show();
          }
          if (state is BerandaPromoDetailSuccessState) {
            EasyLoading.dismiss();
          }
          if (state is BerandaPromoDetailFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          t: t,
          promoId: promoId,
          promoEntity: promoEntity,
          backScreen: backScreen,
          extra: extra ?? {},
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final int? promoId;
  final PromoEntity? promoEntity;
  final String? backScreen;
  final Map<String, dynamic> extra;
  const _Content({
    Key? key,
    required this.t,
    this.promoId,
    this.promoEntity,
    this.backScreen,
    this.extra = const {},
  }) : super(key: key);

  void _onBackPressed(BuildContext context) {
    if (backScreen != null) {
      context.goNamed(
        backScreen ?? AppRoutes.beranda,
        extra: extra,
      );
      return;
    }
    context.goNamed(AppRoutes.beranda);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return PopScope(
          canPop: false,
          onPopInvoked: (val) {
            _onBackPressed(context);
          },
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 2000) {
                _onBackPressed(context);
              }
            },
            child: Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: MainButton(
                  label: "Beli Emas Sekarang",
                  onPressed: () {
                    context.goNamed(
                      AppRoutes.buyGold,
                      extra: {
                        'isElite': isElite.toString(),
                        'backScreenBuyGold': AppRoutes.promoDetail,
                        'extra': extra,
                      },
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 192,
                      child: Stack(
                        children: [
                          BlocBuilder<BerandaPromoDetailBloc,
                              BerandaPromoDetailState>(
                            builder: (context, state) {
                              String? imageUrl;
                              if (state is BerandaPromoDetailSuccessState) {
                                imageUrl = state.promo?.imageUrl;
                              }
                              return Image.network(
                                imageUrl ?? promoEntity?.imageUrl ?? '',
                                height: 192,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        imgBackgroundGold,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SafeArea(
                            child: MainBackButton(
                                color: clrWhite,
                                onPressed: () {
                                  _onBackPressed(context);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<BerandaPromoDetailBloc,
                          BerandaPromoDetailState>(
                        builder: (context, state) {
                          PromoEntity? promoEtt;
                          if (state is BerandaPromoDetailSuccessState) {
                            promoEtt = state.promo;
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 32),
                              Text(
                                promoEtt?.title ?? promoEntity?.title ?? '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isElite ? clrWhite : clrDarkBlue,
                                ),
                              ),
                              const Divider(height: 33),
                              Html(
                                data: HtmlParser.parseHTML(promoEtt?.content ??
                                        promoEntity?.content ??
                                        '')
                                    .text,
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: (isElite
                                            ? clrWhite
                                            : clrBackgroundBlack)
                                        .withOpacity(0.75),
                                    textDecorationColor: (isElite
                                            ? clrWhite
                                            : clrBackgroundBlack)
                                        .withOpacity(0.75),
                                  ),
                                  "span": Style(
                                    color: (isElite
                                            ? clrWhite
                                            : clrBackgroundBlack)
                                        .withOpacity(0.75),
                                  ),
                                  "p": Style(
                                    color: (isElite
                                            ? clrWhite
                                            : clrBackgroundBlack)
                                        .withOpacity(0.75),
                                  ),
                                },
                                onLinkTap: (url, attributes, element) {
                                  AppUtils.openStore(url);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        t.lblOthersPromo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrDarkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<BerandaPromoBloc, BerandaPromoState>(
                        builder: (context, state) {
                          if (state is BerandaPromosSuccessState) {
                            List<PromoEntity> promoEntities = [];
                            promoEntities.addAll(state.promoEntities);
                            promoEntities.removeWhere(
                                (element) => element.id == promoEntity?.id);
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: promoEntities.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.goNamed(
                                      AppRoutes.promoDetail,
                                      extra: {
                                        'eliteCubit':
                                            context.read<EliteCubit>(),
                                        'promoEntity': promoEntities[index],
                                        'berandaPromoBloc':
                                            context.read<BerandaPromoBloc>(),
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: clrYellow,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        promoEntities[index].imageUrl ?? '',
                                        fit: BoxFit.fitWidth,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
                                          child: Text(
                                            'No Image',
                                            style: TextStyle(
                                              color: clrBackgroundBlack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
