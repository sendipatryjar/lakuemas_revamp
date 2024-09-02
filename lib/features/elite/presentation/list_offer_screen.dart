import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../features/elite/presentation/blocs/get_my_offers/get_my_offers_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'widgets/card_offer_widget.dart';
import 'widgets/empty_widget.dart';

class ListOfferScreen extends StatelessWidget {
  const ListOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetMyOffersBloc>()
            ..add(
              GetMyOffersLoadEvent(
                  helperDataEliteCubit: context.read<HelperDataEliteCubit>()),
            ),
        )
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return Scaffold(
            backgroundColor: clrBlack080,
            appBar: AppBar(
              backgroundColor: clrBackgroundBlack,
              centerTitle: true,
              title: Text(
                t.lblMyOffer,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: MainBackButton(
                onPressed: () {
                  context.goNamed(
                    AppRoutes.elite,
                    extra: {
                      'isElite': 'true',
                      'isFromOffers': true,
                    },
                  );
                },
              ),
            ),
            body: BlocBuilder<GetMyOffersBloc, GetMyOffersState>(
              builder: (context, state) {
                if (state is GetMyOffersLoadingState) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => Shimmer.fromColors(
                            baseColor: clrGreyShimmerBase,
                            highlightColor: clrGreyShimmerHighlight,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: clrWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (state is GetMyOffersSuccessState) {
                  return state.offerEntity.isNotEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: List.generate(
                                state.offerEntity.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    context.goNamed(
                                      AppRoutes.offerDetail,
                                      extra: {
                                        'eliteCubit':
                                            context.read<EliteCubit>(),
                                        'backScreen': AppRoutes.listOffer,
                                        'offerID': state.offerEntity[index].id,
                                      },
                                    );
                                  },
                                  child: CardOfferWidget(
                                    imageUrl: state.offerEntity[index].image,
                                    title:
                                        state.offerEntity[index].title ?? '-',
                                    claimed:
                                        'Diklaim - ${state.offerEntity[index].redeemDate.toDateLongMonthStr()}',
                                    activeUntil:
                                        'Berlaku sampai dengan ${state.offerEntity[index].validUntil.toDateLongMonthStr()}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : EmptyWidget(
                          imgAsset: imgPeopleEmpty,
                          desc: t.lblEmptyOffer,
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
