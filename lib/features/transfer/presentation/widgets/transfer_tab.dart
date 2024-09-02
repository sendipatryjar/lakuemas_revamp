import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/checkbox/main_checkbox.dart';
import '../../../../cores/widgets/main_text_field.dart';
import '../cubits/transfer/transfer_cubit.dart';
import '../cubits/transfer_validation/transfer_validation_cubit.dart';
import 'trf_expandable_widget.dart';

class TransferTab extends StatefulWidget {
  final bool isElite;
  final TextEditingController noRekeningTec;
  const TransferTab(
      {super.key, this.isElite = false, required this.noRekeningTec});

  @override
  State<TransferTab> createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // final TextEditingController noRekeningTec = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: BlocBuilder<TransferCubit, TransferState>(
                buildWhen: (previous, current) =>
                    previous.enTransfer != current.enTransfer,
                builder: (context, state) {
                  return _tab(
                    title: t.lblNewAccount,
                    isSelected: state.enTransfer == EnTransfer.newAccount,
                    onTap: () {
                      // add value to transfer validate
                      context
                          .read<TransferValidationCubit>()
                          .valueTab(EnTransfer.newAccount);

                      context
                          .read<TransferCubit>()
                          .changeTab(EnTransfer.newAccount);
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: BlocBuilder<TransferCubit, TransferState>(
                buildWhen: (previous, current) =>
                    previous.enTransfer != current.enTransfer,
                builder: (context, state) {
                  return _tab(
                    title: t.lblFavoriteAccount,
                    isSelected: state.enTransfer == EnTransfer.favAccount,
                    onTap: () {
                      // add value to transfer validate
                      context
                          .read<TransferValidationCubit>()
                          .valueTab(EnTransfer.favAccount);

                      context
                          .read<TransferCubit>()
                          .changeTab(EnTransfer.favAccount);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        BlocBuilder<TransferCubit, TransferState>(
          buildWhen: (previous, current) =>
              (previous.enTransfer != current.enTransfer) ||
              (previous.favorites != current.favorites),
          builder: (context, state) {
            if (state.enTransfer == EnTransfer.newAccount) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  BlocBuilder<TransferValidationCubit, TransferValidationState>(
                    builder: (context, state) {
                      return MainTextField(
                        controller: widget.noRekeningTec,
                        hintText: t.lblNewNumberAccount,
                        textInputType: TextInputType.number,
                        onChange: (p0) => context
                            .read<TransferValidationCubit>()
                            .resetValidateRekening(),
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        isDarkMode: widget.isElite,
                        isError: state.isNoRekeningError ?? false,
                        errorText: state.noRekeningErrorMessages,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<TransferCubit, TransferState>(
                    buildWhen: (previous, current) =>
                        previous.isFavorite != current.isFavorite,
                    builder: (context, state) {
                      return MainCheckbox(
                        uncheckColor:
                            (widget.isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                        value: state.isFavorite,
                        onChange: (value) {
                          context.read<TransferCubit>().toggleFavorite(value);
                        },
                        rightWidget: Text(
                          t.lblAddToFavorite,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                (widget.isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            if (state.enTransfer == EnTransfer.favAccount) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  TrfExpandableWidget(isElite: widget.isElite),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _tab({
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.16),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? clrBackgroundBlack
                : (widget.isElite ? clrWhite : clrBackgroundBlack)
                    .withOpacity(0.75),
          ),
        ),
      ),
    );
  }
}
