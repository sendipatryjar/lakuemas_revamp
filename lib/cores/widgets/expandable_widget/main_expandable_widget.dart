import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cores/constants/app_color.dart';
import '../../utils/text_utils.dart';
import 'cubit/main_expandable_cubit.dart';

class MainExpandableWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final EdgeInsets? titlePadding;
  final Color? titleBackgroundColor;
  final BorderRadiusGeometry? titleBorderRadius;
  final BoxBorder? titleBorder;
  final Color? iconColor;
  final List<Widget> children;
  final EdgeInsets? childrenPadding;
  const MainExpandableWidget({
    super.key,
    required this.title,
    this.titlePadding,
    this.titleBackgroundColor,
    this.titleBorderRadius,
    this.titleBorder,
    this.titleColor,
    this.iconColor,
    this.children = const <Widget>[],
    this.childrenPadding =
        const EdgeInsets.only(left: 20, right: 20, bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainExpandableCubit(),
      child: _Content(
        title: title,
        titleColor: titleColor,
        titlePadding: titlePadding,
        titleBackgroundColor: titleBackgroundColor,
        titleBorderRadius: titleBorderRadius,
        titleBorder: titleBorder,
        iconColor: iconColor,
        childrenPadding: childrenPadding,
        children: children,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.title,
    required this.titleColor,
    required this.titlePadding,
    required this.titleBackgroundColor,
    required this.titleBorderRadius,
    required this.titleBorder,
    required this.iconColor,
    required this.children,
    required this.childrenPadding,
  });

  final String title;
  final Color? titleColor;
  final EdgeInsets? titlePadding;
  final Color? titleBackgroundColor;
  final BorderRadiusGeometry? titleBorderRadius;
  final BoxBorder? titleBorder;
  final Color? iconColor;
  final List<Widget> children;
  final EdgeInsets? childrenPadding;

  @override
  Widget build(BuildContext context) {
    double padding = 0;
    return LayoutBuilder(builder: (_, ctr) {
      if (ctr.maxWidth > 627) {
        padding = 4;
      }
      if (ctr.maxWidth > 1240) {
        padding = 8;
      }
      return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: titleBackgroundColor,
          borderRadius: titleBorderRadius,
          border: titleBorder ??
              Border(
                bottom: BorderSide(
                  color: clrBackgroundBlack.withOpacity(0.08),
                ),
              ),
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? clrBackgroundBlack,
                ),
              ),
            ),
            trailing: AnimatedRotation(
              turns: context.watch<MainExpandableCubit>().state.isExpanded
                  ? .5
                  : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: iconColor ?? clrBackgroundBlack,
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            tilePadding: titlePadding,
            childrenPadding: childrenPadding,
            children: children,
            onExpansionChanged: (value) =>
                context.read<MainExpandableCubit>().changeExpanded(value),
          ),
        ),
      );
    });
  }
}
