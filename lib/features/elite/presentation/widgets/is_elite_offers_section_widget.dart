import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/get_offers/get_offers_bloc.dart';
import 'card_offer_widget.dart';

class IsEliteOffersSectionWidget extends StatelessWidget {
  const IsEliteOffersSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HelperDataEliteCubit>().resetListOffer();
        context.read<GetOffersBloc>().add(GetOffersLoadEvent(
            helperDataEliteCubit: context.read<HelperDataEliteCubit>()));
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblOffersAvailable,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: clrWhite,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.goNamed(
                        AppRoutes.listOffer,
                        extra: {'eliteCubit': context.read<EliteCubit>()},
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
                        'Offer Saya',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
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
              const SizedBox(height: 16),
              BlocBuilder<GetOffersBloc, GetOffersState>(
                builder: (context, state) {
                  if (state is GetOffersLoadingState) {
                    return Column(
                      children: List.generate(
                        5,
                        (index) => Shimmer.fromColors(
                          baseColor: clrGreyShimmerBase,
                          highlightColor: clrGreyShimmerHighlight,
                          child: Container(
                            width: double.infinity,
                            height: 190,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: clrWhite,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is GetOffersSuccessState) {
                    return Column(
                      children: List.generate(
                        state.offerEntity.length,
                        (index) => GestureDetector(
                          onTap: () {
                            context.goNamed(
                              AppRoutes.offerDetail,
                              extra: {
                                'eliteCubit': context.read<EliteCubit>(),
                                'backScreen': AppRoutes.elite,
                                'offerID': state.offerEntity[index].id,
                              },
                            );
                          },
                          child: CardOfferWidget(
                            title: state.offerEntity[index].title ?? '-',
                            imageUrl: state.offerEntity[index].image,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
