import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/physical_pull/domain/entities/store_entity.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_dropdown_search.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../_core/user/domain/entities/user_data_entity.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';
import '../../profile/domain/entities/city_entity.dart';
import '../../profile/domain/entities/province_entity.dart';
import '../../profile/presentation/blocs/city/city_bloc.dart';
import '../../profile/presentation/blocs/city/home/home_city_bloc.dart';
import '../../profile/presentation/blocs/profile/profile_bloc.dart';
import '../../profile/presentation/blocs/province/home/home_province_bloc.dart';
import '../../profile/presentation/blocs/province/province_bloc.dart';
import '../data/models/physical_pull_checkout_req.dart';
import 'blocs/stores/stores_bloc.dart';
import 'cubits/physical_pull_withdrawal_method/physical_pull_withdrawal_method_cubit.dart';
import 'cubits/send_to_my_address/send_to_my_address_cubit.dart';
import 'cubits/take_shop_data/take_shop_data_cubit.dart';

class WithdrawalMethodScreen extends StatelessWidget {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final CheckoutEntity? chargeEntity;

  const WithdrawalMethodScreen({
    super.key,
    this.physicalPullCheckoutReq,
    this.chargeEntity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(ProfileGetDataEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<HomeProvinceBloc>()..add(const ProvinceGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<PhysicalPullWithdrawalMethodCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PaymentCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SendToMyAddressCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TakeShopDataCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCityBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<StoresBloc>(),
        ),
      ],
      child: _Content(
        physicalPullCheckoutReq: physicalPullCheckoutReq,
        chargeEntity: chargeEntity,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final CheckoutEntity? chargeEntity;

  const _Content({
    Key? key,
    this.physicalPullCheckoutReq,
    this.chargeEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBackgroundBlack : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblWithdrawalMethod,
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
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<TakeShopDataCubit, TakeShopDataState>(
              builder: (context, state) {
                return MainButton(
                  label: t.lblSave,
                  onPressed: (state.storeId == null ||
                          state.deliveryMethod == null)
                      ? null
                      : () {
                          context.goNamed(
                            AppRoutes.physicalPullPayment,
                            extra: {
                              'paymentCubit': context.read<PaymentCubit>(),
                              'physicalPullCheckoutReq':
                                  physicalPullCheckoutReq?.copyWith(
                                storeId: state.storeId,
                                courierPriceId: state.courierPriceId,
                                destinationAddress: state.destinationAddress,
                                deliveryMethod: state.deliveryMethod,
                              ),
                              'checkout': chargeEntity,
                            },
                          );
                        },
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BlocBuilder<PhysicalPullWithdrawalMethodCubit, int?>(
                    builder: (context, state) {
                      return _withdrawalMethod(
                        itemLength: 2,
                        title: (index) => withdrawalMethodTitle(t, index),
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        radioBtn: (index) => radioBtn(
                          index,
                          state,
                          (value) {
                            context
                                .read<PhysicalPullWithdrawalMethodCubit>()
                                .changeOption(index);
                          },
                          isElite: isElite,
                        ),
                        onTap: (index) => context
                            .read<PhysicalPullWithdrawalMethodCubit>()
                            .changeOption(index),
                        state: state,
                        optionalWidgetTakeShop: (index) => (state == index)
                            ? _takeShop(
                                context,
                                isElite: isElite,
                              )
                            : const SizedBox(),
                        optionalWidgetSendToMyHome: (index) => (state == index)
                            ? _sendToMyAddress(context, isElite: isElite)
                            : const SizedBox(),
                        isElite: isElite,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String withdrawalMethodTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return 'Ambil Toko';
      case 1:
        return 'Kirim ke Rumah Saya';
      default:
        return '-';
    }
  }

  Widget _withdrawalMethod({
    int itemLength = 0,
    bool isElite = false,
    void Function(int)? onTap,
    final Widget Function(int)? radioBtn,
    final String Function(int)? title,
    final TextStyle? titleStyle,
    final bool isUseRightArrow = false,
    final Widget Function(int)? rightWidget,
    final Widget Function(int)? optionalWidgetSendToMyHome,
    final Widget Function(int)? optionalWidgetTakeShop,
    int? state,
  }) {
    return Column(
      children: [
        Column(
          children: List.generate(
            itemLength,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: clrNeutralGrey999.withOpacity(0.16),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title != null ? title(index) : '-',
                                style: titleStyle,
                              ),
                            ),
                            if (rightWidget != null) rightWidget(index),
                          ],
                        ),
                      ],
                    ),
                    trailing: isUseRightArrow
                        ? Icon(
                            Icons.keyboard_arrow_right,
                            color: clrWhite.withOpacity(0.32),
                          )
                        : (radioBtn != null
                            ? radioBtn(index)
                            : const SizedBox()),
                    onTap: onTap != null
                        ? () {
                            onTap(index);
                          }
                        : null,
                  ),
                  state == 0
                      ? optionalWidgetTakeShop!(index)
                      : state == 1
                          ? optionalWidgetSendToMyHome!(index)
                          : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _takeShop(
    BuildContext context, {
    bool isElite = false,
  }) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: clrNeutralGrey999.withOpacity(0.16),
            margin: const EdgeInsets.only(bottom: 24),
          ),
          BlocBuilder<HomeProvinceBloc, ProvinceState>(
            builder: (context, state) {
              List<ProvinceEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is ProvinceLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is ProvinceSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }
              return MainDropDownSearch<ProvinceEntity>(
                title: t.lblProvince,
                titleColor: isElite ? clrWhite : clrBackgroundBlack,
                hintText: '${t.lblSelect} ${t.lblProvince}',
                items: items,
                itemAsString: (value) => value.name ?? '',
                onChanged: (value) {
                  context.read<TakeShopDataCubit>().changeProvince(value);
                  context
                      .read<HomeCityBloc>()
                      .add(CityGetEvent(provinceId: value?.id));
                },
                state: dsState,
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeCityBloc, CityState>(
            builder: (context, state) {
              List<CityEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is CityInitialState) {
                dsState = MainDropdownSearchState.disabled;
              }
              if (state is CityLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is CitySuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }
              return MainDropDownSearch<CityEntity>(
                title: t.lblCity,
                titleColor: isElite ? clrWhite : clrBackgroundBlack,
                hintText: '${t.lblSelect} ${t.lblCity}',
                items: items,
                itemAsString: (value) => value.city ?? '',
                onChanged: (value) {
                  context.read<TakeShopDataCubit>().changeCity(value);
                  context
                      .read<StoresBloc>()
                      .add(StoresGetEvent(cityId: value?.id));
                },
                state: dsState,
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<StoresBloc, StoresState>(
            builder: (context, state) {
              List<StoreEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is StoresLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is StoresSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }
              return MainDropDownSearch(
                title: 'Toko',
                titleColor: isElite ? clrWhite : clrBackgroundBlack,
                hintText: '${t.lblSelect} Toko',
                items: items,
                itemAsString: (value) => value.name ?? '',
                onChanged: (value) {
                  context.read<TakeShopDataCubit>().getDataEvent(
                        value?.id,
                        0,
                        value?.name,
                        'store_pickup',
                      );
                },
                state: dsState,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sendToMyAddress(
    BuildContext context, {
    UserDataEntity? userDataEntity,
    bool isElite = false,
  }) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Shimmer.fromColors(
              baseColor: clrGreyShimmerBase,
              highlightColor: clrGreyShimmerHighlight,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: List.generate(
                        2,
                        (index) => Container(
                          height: 130,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: clrWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ProfileSuccessState) {
          userDataEntity = state.userDataEntity;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
                const SizedBox(height: 14),
                BlocBuilder<SendToMyAddressCubit, int?>(
                  builder: (context, state) {
                    return Column(
                      children: List.generate(
                        (userDataEntity?.userDataAddressEntity ?? []).isEmpty
                            ? 0
                            : 2,
                        (index) => GestureDetector(
                          onTap: () {
                            context
                                .read<SendToMyAddressCubit>()
                                .changeOption(index);
                            index == 0
                                ? context
                                    .read<TakeShopDataCubit>()
                                    .getDataEvent(
                                      0,
                                      1,
                                      userDataEntity?.userDataAddressEntity?[0]
                                              .address ??
                                          '-',
                                      'courier',
                                    )
                                : context
                                    .read<TakeShopDataCubit>()
                                    .getDataEvent(
                                      0,
                                      1,
                                      userDataEntity?.userDataAddressEntity?[1]
                                              .address ??
                                          '-',
                                      'courier',
                                    );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: state == index
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        clrGreen00B.withOpacity(0.16),
                                        clrGreen00B.withOpacity(0.03),
                                      ],
                                    )
                                  : null,
                              color: state == index
                                  ? null
                                  : isElite
                                      ? clrGreyE5e.withOpacity(0.12)
                                      : clrGreyE5e.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: state == index
                                    ? clrGreen00B.withOpacity(0.20)
                                    : clrNeutralGrey999.withOpacity(0.16),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _titleSendToMyHome(context, index),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        userDataEntity
                                                ?.userDataAddressEntity?[index]
                                                .address ??
                                            '-',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                radioSendToMyAddressBtn(
                                  index,
                                  state,
                                  (value) {
                                    context
                                        .read<SendToMyAddressCubit>()
                                        .changeOption(index);
                                  },
                                  isElite: isElite,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return Center(
          child: Text(t.lblSomethingWrong),
        );
      },
    );
  }

  String _titleSendToMyHome(BuildContext context, int index) {
    final t = AppLocalizations.of(context)!;

    switch (index) {
      case 0:
        return t.lblHomeAddress;
      case 1:
        return t.lblMailingAddress;
      default:
        return '-';
    }
  }

  Widget radioBtn(
    int index,
    int? groupValue,
    void Function(int?)? onChanged, {
    bool isElite = false,
  }) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return (isElite)
              ? clrWhite.withOpacity(0.75)
              : clrBackgroundBlack.withOpacity(0.75);
        },
      ),
    );
  }

  Widget radioSendToMyAddressBtn(
      int index, int? groupValue, void Function(int?)? onChanged,
      {bool isElite = false}) {
    return Radio(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return (isElite)
              ? clrWhite.withOpacity(0.75)
              : clrBackgroundBlack.withOpacity(0.75);
        },
      ),
    );
  }
}
