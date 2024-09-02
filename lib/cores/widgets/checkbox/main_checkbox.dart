import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_color.dart';
import '../../depedencies_injection/depedency_injection.dart';
import '../../utils/app_utils.dart';
import 'cubit/main_checkbox_cubit.dart';

class MainCheckbox extends StatelessWidget {
  final bool? initialValue;
  final Function(bool)? onChange;
  final Widget? rightWidget;
  final Color? uncheckColor;
  final bool? value;
  final bool isCanTap;
  const MainCheckbox({
    super.key,
    this.initialValue,
    this.onChange,
    this.rightWidget,
    this.uncheckColor,
    this.value,
    this.isCanTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MainCheckboxCubit>()..initValue(initialValue ?? false),
      child: _Content(
        onChange: onChange,
        rightWidget: rightWidget,
        uncheckColor: uncheckColor,
        value: value,
        isCanTap: isCanTap,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.onChange,
    required this.rightWidget,
    this.uncheckColor,
    this.value,
    this.isCanTap = true,
  }) : super(key: key);

  final Function(bool p1)? onChange;
  final Widget? rightWidget;
  final Color? uncheckColor;
  final bool? value;
  final bool isCanTap;

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      context.read<MainCheckboxCubit>().initValue(value!);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: isCanTap
                ? () {
                    context.read<MainCheckboxCubit>().toggle();
                  }
                : null,
            child: BlocConsumer<MainCheckboxCubit, bool>(
              listener: (context, state) {
                appPrint('main checkbox state changed to $state');
                if (onChange != null) onChange!(state);
              },
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: state ? clrYellow : (uncheckColor ?? clrWhite),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: state
                        ? Icon(
                            Icons.check,
                            size: 12.0,
                            color: clrBackgroundBlack,
                          )
                        : const SizedBox(
                            width: 12,
                            height: 12,
                          ),
                  ),
                );
              },
            ),
          ),
          if (rightWidget != null)
            const SizedBox(
              width: 10,
            ),
          if (rightWidget != null) Expanded(child: rightWidget!),
        ],
      ),
    );
  }
}
