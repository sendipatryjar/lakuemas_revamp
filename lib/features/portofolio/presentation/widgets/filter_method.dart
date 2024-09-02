import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';

class FilterMethod extends StatelessWidget {
  final bool isElite;
  final String? title;
  final int? methodId;
  final int? selectedMethodId;
  final Function(int?)? onChanged;
  const FilterMethod({
    super.key,
    required this.isElite,
    this.title,
    this.methodId,
    this.selectedMethodId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title ?? '-',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isElite ? clrWhite : clrBackgroundBlack,
        ),
      ),
      trailing: methodId != null
          ? Radio<int?>(
              value: methodId,
              groupValue: selectedMethodId,
              onChanged: onChanged,
              fillColor: MaterialStateColor.resolveWith((states) =>
                  (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75)),
            )
          : null,
    );
  }
}
