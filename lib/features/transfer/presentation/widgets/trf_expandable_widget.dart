import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/widgets/main_text_field.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../cubits/transfer/transfer_cubit.dart';
import '../cubits/transfer_validation/transfer_validation_cubit.dart';

class TrfExpandableWidget extends StatelessWidget {
  final bool isElite;

  const TrfExpandableWidget({
    Key? key,
    required this.isElite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: clrNeutralGrey999.withOpacity(0.08),
        border: Border.all(color: clrNeutralGrey999.withOpacity(0.16)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          return Column(
            children: [
              Visibility(
                visible: state.selectedFavorite == null,
                replacement: _fieldFilled(
                  context: context,
                  name: state.selectedFavorite?.accountName,
                  noRek: state.selectedFavorite?.accountNumber,
                ),
                child: MainTextField(
                  isDarkMode: isElite,
                  hintText: 'Cari ${t.lblFavoriteAccount}',
                  onChange: (val) {
                    context
                        .read<TransferValidationCubit>()
                        .resetValidateRekening();
                    context.read<TransferCubit>().searchFavorites(val);
                  },
                  isError: context
                          .watch<TransferValidationCubit>()
                          .state
                          .isNoRekeningError ??
                      true,
                  suffixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: clrNeutralGrey999.withOpacity(0.5),
                  ),
                ),
              ),
              Visibility(
                visible: state.selectedFavorite == null,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    maxHeight: 200,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.favoritesSearch.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context
                              .read<TransferCubit>()
                              .selectFavorite(state.favoritesSearch[index]);
                        },
                        title: Text(
                          state.favoritesSearch[index].accountName ?? '-',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        subtitle: Text(
                          state.favoritesSearch[index].accountNumber ?? '-',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container _fieldFilled(
      {required BuildContext context, String? name, String? noRek}) {
    return Container(
      height: 58,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: (isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                Text(
                  noRek ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<TransferCubit>().selectFavorite(null);
            },
            child: Icon(
              Icons.close,
              size: 20,
              color: clrNeutralGrey999.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}
