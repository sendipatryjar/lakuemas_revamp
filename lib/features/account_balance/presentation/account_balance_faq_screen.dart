import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/expandable_widget/main_expandable_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/faq/faq_bloc.dart';

class AccountBalanceFaqScreen extends StatelessWidget {
  const AccountBalanceFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
          sl<AccountBalanceFaqBloc>()..add(AccountBalanceFaqGetEvent()),
      child: _Content(t: t),
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
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblAccountBalance,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
                  child: Text(
                    t.lblFrequentlyAsked,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
                BlocBuilder<AccountBalanceFaqBloc, AccountBalanceFaqState>(
                  builder: (context, state) {
                    if (state is AccountBalanceFaqLoadingState) {
                      return const SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is AccountBalanceFaqSuccessState) {
                      return ListView.builder(
                        itemCount: state.accountBalanceFaqs.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MainExpandableWidget(
                            title:
                                state.accountBalanceFaqs[index].question ?? '-',
                            titleColor: isElite ? clrWhite : clrBackgroundBlack,
                            iconColor: isElite ? clrWhite : clrBackgroundBlack,
                            children: [
                              Text(
                                state.accountBalanceFaqs[index].answer ?? '-',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  color:
                                      (isElite ? clrWhite : clrBackgroundBlack)
                                          .withOpacity(0.75),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
