import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/master_data/master_data_lakusave_bloc.dart';
import '../cubits/lakusave/lakusave_cubit.dart';

class LakusaveExpandableWidget extends StatefulWidget {
  final bool isElite;
  const LakusaveExpandableWidget({super.key, this.isElite = false});

  @override
  State<LakusaveExpandableWidget> createState() =>
      _LakusaveExpandableWidgetState();
}

class _LakusaveExpandableWidgetState extends State<LakusaveExpandableWidget> {
  late ExpansionTileController controller;

  @override
  void initState() {
    super.initState();

    controller = ExpansionTileController();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: clrWhite.withOpacity(0.5),
          colorScheme: ColorScheme.light(
            primary: clrWhite.withOpacity(0.5),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          controller: controller,
          title: context.watch<LakusaveCubit>().state.selectedExtendedEntity !=
                  null
              ? _titleWhenSelected(context)
              : Text(
                  '${t.lblSelect} ${t.lblExtendStatus}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: clrNeutralGrey999.withOpacity(0.5),
                  ),
                ),
          tilePadding: const EdgeInsets.only(
            top: 4,
            bottom: 4,
            right: 16,
            left: 16,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: ((context.read<MasterDataLakusaveBloc>().state
                          as MasterDataLakusaveSuccessState)
                      .goldDepositEntity
                      ?.extendss ??
                  [])
              .skip(1)
              .map((e) => GestureDetector(
                    onTap: () {
                      context.read<LakusaveCubit>().changeExtended(e);
                      controller.collapse();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          e.name ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                widget.isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.description ?? '-',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color:
                                widget.isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: clrNeutralGrey999.withOpacity(0.16),
                          height: 1,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _titleWhenSelected(BuildContext context,
      [bool isTransparent = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watch<LakusaveCubit>().state.selectedExtendedEntity?.name ??
              '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isTransparent
                ? Colors.transparent
                : (widget.isElite ? clrWhite : clrBackgroundBlack),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context
                  .watch<LakusaveCubit>()
                  .state
                  .selectedExtendedEntity
                  ?.description ??
              '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isTransparent
                ? Colors.transparent
                : (widget.isElite ? clrWhite : clrBackgroundBlack),
          ),
        )
      ],
    );
  }
}
