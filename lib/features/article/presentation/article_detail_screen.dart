import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_carousel.dart';
import '../domain/entities/article_entity.dart';
import 'blocs/article_detail/article_detail_bloc.dart';
import 'blocs/articles/articles_bloc.dart';
import 'widgets/article_widget.dart';

void _onBackPressed(BuildContext context, String? backScreen, Object? extra) {
  if (backScreen != null) {
    context.goNamed(
      backScreen,
      extra: extra,
    );
    return;
  }
  context.pop();
}

class ArticleDetailScreen extends StatelessWidget {
  final int? articleId;
  final ArticleEntity? articleEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;

  const ArticleDetailScreen({
    super.key,
    this.articleId,
    this.articleEntity,
    this.backScreen,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ArticlesBloc>()
            ..add(const ArticlesGetEvent(
              limit: 4,
              page: 1,
            )),
        ),
        BlocProvider(create: (context) {
          if (articleId != null) {
            return sl<ArticleDetailBloc>()
              ..add(ArticleDetailGetEvent(articleId));
          }
          return sl<ArticleDetailBloc>();
        }),
      ],
      child: BlocListener<ArticleDetailBloc, ArticleDetailState>(
        listener: (context, state) {
          if (state is ArticleDetailLoadingState) {
            EasyLoading.show();
          }
          if (state is ArticleDetailSuccessState) {
            EasyLoading.dismiss();
          }
          if (state is ArticleDetailFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: backScreen != null
            ? PopScope(
              canPop: false,
                onPopInvoked: (val)  {
                  _onBackPressed(context, backScreen, extra);
                },
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx > 2000) {
                      _onBackPressed(context, backScreen, extra);
                    }
                  },
                  child: _Content(
                    t: t,
                    articleId: articleId,
                    articleEntity: articleEntity,
                    backScreen: backScreen,
                    extra: extra,
                  ),
                ),
              )
            : _Content(
                t: t,
                articleId: articleId,
                articleEntity: articleEntity,
                backScreen: backScreen,
                extra: extra,
              ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
    this.articleId,
    this.articleEntity,
    this.backScreen,
    this.extra,
  }) : super(key: key);

  final AppLocalizations t;
  final int? articleId;
  final ArticleEntity? articleEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            elevation: 0,
            title: Text(
              t.lblArticle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                _onBackPressed(context, backScreen, extra);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: BlocBuilder<ArticleDetailBloc, ArticleDetailState>(
                    builder: (context, state) {
                      ArticleEntity? articleEtt;
                      if (state is ArticleDetailSuccessState) {
                        articleEtt = state.article;
                      }
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: clrBlack101.withOpacity(0.38),
                            ),
                            child: ClipRRect(
                              child: Image.network(
                                articleEtt?.image ?? articleEntity?.image ?? '',
                                color: clrBlack101.withOpacity(0.8),
                                colorBlendMode: BlendMode.darken,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  articleEtt?.title ??
                                      articleEntity?.title ??
                                      '-',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: clrWhite,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  (articleEtt?.createdAt ??
                                          articleEntity?.createdAt ??
                                          '')
                                      .toDateStr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: clrWhite,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<ArticleDetailBloc, ArticleDetailState>(
                    builder: (context, state) {
                      ArticleEntity? articleEtt;
                      if (state is ArticleDetailSuccessState) {
                        articleEtt = state.article;
                      }
                      return Html(
                        data:
                            articleEtt?.content ?? articleEntity?.content ?? '',
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(14),
                            color: (isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                            fontFamily: "Poppins",
                          ),
                          "p": Style(
                            fontSize: FontSize(14),
                            textAlign: TextAlign.left,
                            fontFamily: "Poppins",
                          ),
                          "span": Style(
                            fontSize: FontSize(14),
                            textAlign: TextAlign.left,
                            fontFamily: "Poppins",
                          ),
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 33),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.lblNewArticles,
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
                  child: BlocBuilder<ArticlesBloc, ArticlesState>(
                    builder: (context, state) {
                      if (state is ArticlesSuccessState) {
                        List<ArticleEntity> articles = [];
                        articles.addAll(state.allArticles);
                        articles.removeWhere(
                            (element) => element.id == articleEntity?.id);
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: articles
                              .map(
                                (article) => GestureDetector(
                                  onTap: () {
                                    context.goNamed(AppRoutes.articleDetail,
                                        extra: {
                                          'eliteCubit':
                                              context.read<EliteCubit>(),
                                          'articleEntity': article,
                                        });
                                  },
                                  child: ArticleWidget(
                                    title: article.title ?? '-',
                                    imageUrl: article.image,
                                    dateTime: article.createdAt.toDateStr(),
                                    isElite: isElite,
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
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.lblUpcomingFeatures,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrDarkBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 128,
                  child: MainCarousel(
                    controller:
                        PageController(viewportFraction: 1, keepPage: true),
                    isDotsInStack: false,
                    contents: [
                      Image.asset(imgLuckyDice),
                      Image.asset(imgLuckyDice),
                      Image.asset(imgLuckyDice),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
