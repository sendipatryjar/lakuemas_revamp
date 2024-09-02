import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/checkbox/main_checkbox.dart';
import '../cubits/laku_save_terms_condition/laku_save_terms_condition_cubit.dart';

class LakuSaveCheckbox extends StatefulWidget {
  final bool isElite;
  final ScrollController scrollController;
  const LakuSaveCheckbox({
    super.key,
    this.isElite = false,
    required this.scrollController,
  });

  @override
  State<LakuSaveCheckbox> createState() => _LakuSaveCheckboxState();
}

class _LakuSaveCheckboxState extends State<LakuSaveCheckbox> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >=
          widget.scrollController.position.maxScrollExtent) {
        if (mounted) {
          setState(() {
            isActive = true;
          });
          context
              .read<LakuSaveTermsConditionCubit>()
              .updateTermsConditions(isActive);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MainCheckbox(
      isCanTap: true,
      value: isActive,
      uncheckColor: clrGreyE5e,
      onChange: (value) {
        context
            .read<LakuSaveTermsConditionCubit>()
            .updateTermsConditions(value);
      },
      rightWidget: RichText(
        textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
        text: TextSpan(
          text:
              '${t.lblAgreeTo} ${t.lblTermsAndCondition} ${t.lblLakuemasService}',
          style: TextStyle(
            fontSize: 12,
            height: 1.6,
            fontWeight: FontWeight.w500,
            color: widget.isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
      ),
    );
  }
}
