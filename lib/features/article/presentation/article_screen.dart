import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/models/data_with_meta.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_carousel.dart';
import '../domain/entities/article_entity.dart';
import 'blocs/articles/articles_bloc.dart';
import 'cubits/article_helper/article_helper_cubit.dart';
import 'widgets/article_widget.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ArticlesBloc>()
            ..add(const ArticlesGetEvent(
              limit: 10,
              page: 1,
              topThreeNewArticle: [],
            )),
        ),
        BlocProvider(
          create: (context) => sl<ArticleHelperCubit>(),
        ),
      ],
      child: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          if (state is ArticlesLoadingState) {
            context.read<ArticleHelperCubit>().updateLoadingTrue();
          }
          if (state is ArticlesSuccessState) {
            context.read<ArticleHelperCubit>().updateArticles(
                  page: state.metaData?.page ?? 1,
                  topThreeArticles: state.topThreeArticles,
                  articles: state.otherArticles,
                  metaData: state.metaData,
                );
          }
          if (state is ArticlesFailureState) {
            context.read<ArticleHelperCubit>().updateErrorTrue();
          }
        },
        child: BlocBuilder<ArticleHelperCubit, ArticleHelperState>(
          builder: (context, state) {
            return _Content(t: t);
          },
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<ArticlesBloc, ArticlesState>(
          builder: (context, state) {
            if (state is ArticlesFailureState) {
              if (state.appFailure is ServerFailure) {
                return Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  appBar: AppBar(
                    backgroundColor: clrBlack101,
                    title: Text(
                      "Error",
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                    ),
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
              backgroundColor: isElite ? clrBlack101 : null,
              appBar: AppBar(
                backgroundColor: clrBlack101,
                centerTitle: true,
                elevation: 0,
                title: Text(
                  widget.t.lblArticle,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
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
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final currOffset = notification.metrics.pixels;
                  final maxOffset = notification.metrics.maxScrollExtent;
                  final articleHelperCbtState =
                      context.read<ArticleHelperCubit>().state;
                  final bool isLastPage = articleHelperCbtState.meta?.page ==
                      articleHelperCbtState.meta?.totalPage;
                  if ((isLastPage == false) &&
                      (notification.metrics.axis == Axis.vertical) &&
                      (currOffset >= (maxOffset - 200)) &&
                      (articleHelperCbtState.isLoading == false)) {
                    context.read<ArticleHelperCubit>().updateLoadingTrue();
                    context.read<ArticlesBloc>().add(
                          ArticlesGetEvent(
                            limit: 10,
                            page: (articleHelperCbtState.meta?.page ?? 0) + 1,
                            topThreeNewArticle: context
                                .read<ArticleHelperCubit>()
                                .state
                                .topThreeArticles,
                          ),
                        );
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      _topThreeNewArticle(pageController, isElite),
                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.t.lblNewArticles,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
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
                        child:
                            BlocBuilder<ArticleHelperCubit, ArticleHelperState>(
                          buildWhen: (previous, current) =>
                              previous.articles != current.articles ||
                              previous.isError != current.isError ||
                              previous.isLoading != current.isLoading ||
                              previous.meta != current.meta,
                          builder: (context, state) {
                            return _articles(
                              articles: state.articles,
                              metaData: state.meta,
                              isLoading: state.isLoading,
                              isError: state.isError,
                              isElite: isElite,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _upcomingFeatures(context: context, isEliteMode: isElite),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _articles({
    required List<ArticleEntity> articles,
    required MetaDataApi? metaData,
    required bool isLoading,
    required bool isError,
    required bool isElite,
  }) {
    if (articles.isEmpty) {
      return _loadingWidget(isElite);
    }
    final bool isLastPage = metaData?.page == metaData?.totalPage;
    return ListView.builder(
      itemCount: articles.length + (isLastPage ? 0 : 1),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == articles.length) {
          if (isError) {
            return Center(
              child: _errorDialog(),
            );
          }
          return _loadingWidget(isElite);
        }
        return GestureDetector(
          onTap: () {
            context.goNamed(AppRoutes.articleDetail, extra: {
              'eliteCubit': context.read<EliteCubit>(),
              'articleEntity': articles[index],
            });
          },
          child: ArticleWidget(
            title: articles[index].title ?? '-',
            imageUrl: articles[index].image,
            dateTime: (articles[index].createdAt ?? '').toDateStr(),
            isElite: isElite,
          ),
        );
      },
    );
  }

  Widget _loadingWidget(bool isElite) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              color: clrYellow,
              backgroundColor: clrYellow.withOpacity(0.15),
              // strokeWidth: 6,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${widget.t.lblLoading} ${widget.t.lblNews}',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: (isElite ? clrWhite : clrBackgroundBlack)
                    .withOpacity(0.75)),
          ),
        ],
      ),
    );
  }

  Widget _topThreeNewArticle(PageController controller, bool isElite) {
    double cardHeight = 200;
    return LayoutBuilder(builder: (_, ctr) {
      if (ctr.maxWidth > 627) {
        cardHeight = 280;
      }
      if (ctr.maxWidth > 1240) {
        cardHeight = 360;
      }
      return BlocBuilder<ArticleHelperCubit, ArticleHelperState>(
        buildWhen: (previous, current) =>
            previous.topThreeArticles != current.topThreeArticles,
        builder: (context, state) {
          if (state.articles.isEmpty) {
            return SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: MainCarousel(
                controller: controller,
                isArrow: false,
                isDots: true,
                isDotsInStack: false,
                contents: List.generate(
                    3,
                    (index) => Shimmer.fromColors(
                          baseColor: clrGreyShimmerBase,
                          highlightColor: clrGreyShimmerHighlight,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: clrWhite,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        )),
              ),
            );
          }
          return SizedBox(
            height: cardHeight,
            width: double.infinity,
            child: MainCarousel(
              controller: controller,
              isDots: true,
              isArrow: false,
              isDotsInStack: false,
              isElite: isElite,
              contents: state.topThreeArticles
                  .map((e) => GestureDetector(
                        onTap: () {
                          context.goNamed(AppRoutes.articleDetail, extra: {
                            'eliteCubit': context.read<EliteCubit>(),
                            'articleEntity': e,
                          });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: clrWhite,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  e.image ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(child: Text('no image')),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    clr000000.withOpacity(0.1),
                                    clr000000.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                e.title ?? '-',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: clrWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      );
    });
  }

  Widget _errorDialog({String? message}) {
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

  Widget _upcomingFeatures(
      {required BuildContext context, bool isEliteMode = false}) {
    final t = AppLocalizations.of(context)!;
    final controller = PageController(viewportFraction: 1, keepPage: true);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              t.lblUpcomingFeatures,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEliteMode ? clrWhiteFef : clrDarkBlue,
              ),
            ),
          ),
          const SizedBox(height: 17),
          SizedBox(
            height: 128,
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
  }
}
