import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/expandable_widget/main_expandable_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import 'blocs/support_faq/support_faq_bloc.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final TextEditingController searchTec = TextEditingController();
    return BlocProvider(
      create: (context) =>
          sl<SupportFaqBloc>()..add(const SupportFaqGetEvent(null)),
      child: _Content(key: key, t: t, searchTec: searchTec),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
    required this.t,
    required this.searchTec,
  });

  final AppLocalizations t;
  final TextEditingController searchTec;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              'FAQ',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(AppRoutes.support);
              },
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 32,
                ),
                decoration: BoxDecoration(
                  color: clrBlack101,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            t.lblHelpCenter,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: clrWhite,
                            ),
                          ),
                        ),
                        Image.asset(imgPeopleFaq),
                      ],
                    ),
                    MainTextField(
                      isDarkMode: true,
                      controller: searchTec,
                      hintText: t.lblSearchQuestion,
                      prefixIcon: Icon(
                        Icons.search,
                        color: clrWhiteFef.withOpacity(0.32),
                      ),
                      borderRadius: 30,
                      onFieldSubmitted: (value) {
                        context
                            .read<SupportFaqBloc>()
                            .add(SupportFaqGetEvent(value));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<SupportFaqBloc, SupportFaqState>(
                  builder: (context, state) {
                    if (state is SupportFaqLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is SupportFaqSuccessState) {
                      if (state.data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            Center(
                              child: Image.asset(imgPeopleRedeemWrong),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Mohon maaf, kata kunci yang kamu masukkan tidak tersedia. Silahkan masukkan kata kunci lain',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
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
                      return ListView.builder(
                        itemCount: state.data.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Text(
                                  (state.data[index].title ?? '-')
                                      .replaceAll('<b>', '')
                                      .replaceAll('</b>', ''),
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isElite ? clrWhite : clrBackgroundBlack,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (state.data[index].items ?? [])
                                    .map(
                                      (e) => MainExpandableWidget(
                                        title: e.question ?? '-',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        children: [
                                          Text(
                                            e.answer ?? '-',
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              color: (isElite
                                                      ? clrWhite
                                                      : clrBackgroundBlack)
                                                  .withOpacity(0.75),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  t.lblIsYourQuestionAnswered,
                                                  textScaler: TextScaler.linear(
                                                      TextUtils.textScaleFactor(
                                                          context)),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isElite
                                                        ? clrWhite
                                                        : clrBackgroundBlack,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                MainButton(
                                                  label:
                                                      '${t.lblNo}, ${t.lblAskViaChat}',
                                                  labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: (isElite
                                                            ? clrBackgroundBlack
                                                            : clrBackgroundBlack)
                                                        .withOpacity(0.75),
                                                  ),
                                                  borderRadius: 30,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  onPressed: () {
                                                    context.goNamed(
                                                      AppRoutes.chatUsFaq,
                                                      extra: {
                                                        'eliteCubit': context
                                                            .read<EliteCubit>(),
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
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
        );
      },
    );
  }
}
