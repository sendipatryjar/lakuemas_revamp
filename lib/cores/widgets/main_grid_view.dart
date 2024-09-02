import 'package:flutter/material.dart';

class MainGridView<T> extends StatelessWidget {
  final List<T> allData;
  final int Function(BoxConstraints?) maxColumn;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget Function(T, BoxConstraints?) child;
  final double horzMargin;
  final double? vertMargin;
  final bool isExpanded;
  const MainGridView({
    super.key,
    required this.allData,
    required this.maxColumn,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.child,
    this.horzMargin = 0,
    this.vertMargin,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry rowPadding(
        int itemIndex, int startIndex, int endIndex, int maxColumn) {
      if (endIndex - startIndex == maxColumn) {
        if (itemIndex < endIndex) {
          return EdgeInsets.only(right: horzMargin);
        }
        return EdgeInsets.zero;
      }

      return EdgeInsets.only(right: horzMargin);
    }

    return LayoutBuilder(builder: (ctx, ctr) {
      int maxPage = allData.length ~/ maxColumn(ctr);
      int remaining = allData.length % maxColumn(ctr);
      if (remaining > 0) maxPage = maxPage + 1;
      return Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(maxPage, (page) {
          bool isLastIndex = (page + 1) == maxPage;
          int startIndex = ((page + 1) * maxColumn(ctr)) - maxColumn(ctr);
          int endIndex = isLastIndex && remaining > 0
              ? startIndex + remaining
              : startIndex + maxColumn(ctr);

          if (isExpanded) {
            return Container(
              padding: (page + 1) == maxPage
                  ? EdgeInsets.zero
                  : EdgeInsets.only(bottom: vertMargin ?? horzMargin),
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: allData
                    .getRange(startIndex, endIndex)
                    .map((e) => Container(
                          padding: rowPadding(allData.indexOf(e) + 1,
                              startIndex, endIndex, maxColumn(ctr)),
                          width: ctr.maxWidth / maxColumn(ctr),
                          child: child(e, ctr),
                        ))
                    .toList(),
              ),
            );
          }

          return Container(
            padding: (page + 1) == maxPage
                ? EdgeInsets.zero
                : EdgeInsets.only(bottom: vertMargin ?? horzMargin),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: allData.getRange(startIndex, endIndex).map((e) {
                var padding = rowPadding(allData.indexOf(e) + 1, startIndex,
                    endIndex, maxColumn(ctr));
                return Container(
                  padding: padding,
                  child: child(e, ctr),
                );
              }).toList(),
            ),
          );
        }),
      );
    });
  }
}
