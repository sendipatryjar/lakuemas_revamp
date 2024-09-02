import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_date_picker.dart';
import '../../../cores/widgets/main_dropdown_search.dart';

class PickupStoreScreen extends StatelessWidget {
  const PickupStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: _appBar(context, t: t),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblSelectStore,
              onPressed: () {
                context.goNamed(AppRoutes.ptWithdrawalMethod);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 2,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
                color: isElite ? clrGreyE5e.withOpacity(0.12) : clrGreyE5e.withOpacity(0.25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${t.lblSelect} ${t.lblPickupStore}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  Text(
                    'Harap masukan lokasi kamu untuk mengecek keterjangkauan layanan',
                    style: TextStyle(
                      fontSize: 12,
                      color: isElite ? clrWhite.withOpacity(0.75) : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 40,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                  MainDropDownSearch(
                    isElite: isElite,
                    title: t.lblProvince,
                    titleColor: isElite ? clrWhite.withOpacity(0.75) : clrBackgroundBlack.withOpacity(0.75),
                    hintText: '${t.lblSelect} ${t.lblProvince}',
                    items: const ['items'],
                    itemAsString: (value) => value,
                    onChanged: (value) {
                      // context.read<TakeShopDataCubit>().changeProvince(value);
                      // context
                      //     .read<HomeCityBloc>()
                      //     .add(CityGetEvent(provinceId: value?.id));
                    },
                    // state: dsState,
                  ),
                  const SizedBox(height: 20),
                  MainDropDownSearch(
                    isElite: isElite,
                    title: t.lblCity,
                    titleColor: isElite ? clrWhite.withOpacity(0.75) : clrBackgroundBlack.withOpacity(0.75),
                    hintText: '${t.lblSelect} ${t.lblCity}',
                    items: const ['items'],
                    itemAsString: (value) => value,
                    onChanged: (value) {
                      // context.read<TakeShopDataCubit>().changeCity(value);
                      // context
                      //     .read<StoresBloc>()
                      //     .add(StoresGetEvent(cityId: value?.id));
                    },
                    // state: dsState,
                  ),
                  const SizedBox(height: 20),
                  MainDropDownSearch(
                    isElite: isElite,
                    title: 'Toko',
                    titleColor: isElite ? clrWhite.withOpacity(0.75) : clrBackgroundBlack.withOpacity(0.75),
                    hintText: '${t.lblSelect} Toko',
                    items: const ['items'],
                    itemAsString: (value) => value,
                    onChanged: (value) {
                      // context.read<TakeShopDataCubit>().getDataEvent(
                      //       value?.id,
                      //       0,
                      //       value?.name,
                      //       'store_pickup',
                      //     );
                    },
                    // state: dsState,
                  ),
                  const SizedBox(height: 20),
                  MainDatePicker(
                    title: 'Tanggal Pengambilan*',
                    isElite: isElite,
                    titleColor: isElite ? clrWhite.withOpacity(0.75) : clrBackgroundBlack.withOpacity(0.75),
                    hintText:
                        // (dateTimeFormated ?? '').isNotEmpty
                        //     ? dateTimeFormated
                        //     :
                        '${t.lblSelect} Tanggal Pengambilan',
                    onChanged: (value) {
                      // final strDate = value != null
                      //     ? DateFormat('dd-MM-yyyy').format(value)
                      //     : null;
                      // context
                      //     .read<SelfDataUpdateCubit>()
                      //     .changeDob(strDate ?? '');
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Tanggal Pengambilan yang bisa dipilih adalah 2-3 Hari Kerja dari tanggal pengajuan',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(
    BuildContext context, {
    required AppLocalizations t,
  }) {
    return AppBar(
      backgroundColor: clrBlack101,
      centerTitle: true,
      title: Text(
        '${t.lblSelect} ${t.lblPickupStore}',
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
    );
  }
}
