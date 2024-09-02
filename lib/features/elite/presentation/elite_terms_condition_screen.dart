import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../data/models/elite_register_req.dart';
import '../domain/entities/elite_register_entity.dart';
import 'blocs/elite_blocs.dart';

class EliteTermsConditionScreen extends StatelessWidget {
  final EliteRegisterEntity? eliteRegisterEntity;
  final bool isValidated;
  final EliteRegisterReq? eliteRegisterReq;
  final String? backScreen;

  const EliteTermsConditionScreen({
    super.key,
    this.eliteRegisterEntity,
    this.isValidated = false,
    this.eliteRegisterReq,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetTermsConditionsBloc>()
            ..add(
              const GetTermsConditionsEvents(),
            ),
        ),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return Scaffold(
            backgroundColor: isElite ? clrBlack080 : null,
            appBar: AppBar(
              backgroundColor: clrBlack080,
              centerTitle: true,
              elevation: 0,
              title: Text(
                t.lblTermsConditions,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
              leading: MainBackButton(
                color: clrYellow,
                onPressed: () {
                  eliteRegisterEntity == null
                      ? context.goNamed(
                          AppRoutes.elite,
                          extra: {'isElite': isElite.toString()},
                        )
                      : context.pop();
                },
              ),
            ),
            body: BlocConsumer<GetTermsConditionsBloc, GetTermsConditionsState>(
              listener: (context, state) {
                if (state is GetTermsConditionsLoadingState) {
                  EasyLoading.show();
                }
                if (state is GetTermsConditionsSuccessState) {
                  EasyLoading.dismiss();
                }
                if (state is GetTermsConditionsFailureState) {
                  EasyLoading.showError(
                    errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                    dismissOnTap: true,
                  );
                  // Future.delayed(const Duration(seconds: 2)).then((value) {
                  //   context.goNamed(AppRoutes.elite);
                  // });
                }
              },
              builder: (context, state) {
                if (state is GetTermsConditionsSuccessState) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Html(
                        data: state.data,
                        style: {
                          "body": Style(
                            color: isElite ? clrWhite : clrBackgroundBlack,
                            backgroundColor:
                                isElite ? clrBlack080 : Colors.transparent,
                            textAlign: TextAlign.left,
                            fontSize: FontSize(14),
                            fontFamily: "Poppins",
                          ),
                          "p": Style(
                            color: isElite ? clrWhite : clrBackgroundBlack,
                            textAlign: TextAlign.left,
                            fontSize: FontSize(14),
                            fontFamily: "Poppins",
                          ),
                          "span": Style(
                            color: isElite ? clrWhite : clrBackgroundBlack,
                            textAlign: TextAlign.left,
                            fontSize: FontSize(14),
                            fontFamily: "Poppins",
                          ),
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
