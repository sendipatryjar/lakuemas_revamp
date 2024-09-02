import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';
import 'dropdown_button2/dropdown_button2.dart';

class MainDropDown<T> extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final bool isRequired;
  final String? hintText;
  final List<T> items;
  final T? value;
  final String Function(T) itemName;
  final Function(dynamic)? onChange;
  final bool isElite;
  final String? errorMessage;
  final String? Function(T?)? validator;
  final bool enabled;
  const MainDropDown({
    Key? key,
    this.title,
    this.titleColor,
    this.isRequired = false,
    this.hintText,
    this.items = const [],
    this.value,
    required this.itemName,
    this.onChange,
    this.isElite = false,
    this.errorMessage,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: RichText(
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              text: TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? clrBackgroundBlack.withOpacity(0.75),
                  ),
                  children: [
                    if (isRequired)
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: clrYellow,
                        ),
                      ),
                  ]),
            ),
          ),
        DropdownButtonFormField2(
          isExpanded: true,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: clrNeutralGrey999.withOpacity(0.16),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: clrNeutralGrey999.withOpacity(0.16),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: (errorMessage ?? '').isNotEmpty
                    ? clrRed.withOpacity(0.5)
                    : clrNeutralGrey999.withOpacity(0.16),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: (errorMessage ?? '').isNotEmpty
                ? clrRed.withOpacity(0.25)
                : clrGreyE5e.withOpacity(0.25),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: clrNeutralGrey999.withOpacity(
                  0.5,
                )),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: isElite
                  ? clrWhite.withOpacity(0.5)
                  : clrBackgroundBlack.withOpacity(0.5),
            ),
            openMenuIcon: Icon(
              Icons.keyboard_arrow_up_outlined,
              color: isElite
                  ? clrWhite.withOpacity(0.5)
                  : clrBackgroundBlack.withOpacity(0.5),
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isElite ? clrBlack080.withOpacity(0.9) : null,
              boxShadow: [
                BoxShadow(
                  color: clrNeutralGrey999.withOpacity(0.16),
                  spreadRadius: 3,
                  blurRadius: 3,
                )
              ],
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
          items: items
              .map((e) => DropdownItem(value: e, child: Text(itemName(e))))
              .toList(),
          onChanged: enabled ? onChange : null,
          value: value,
        ),
        if ((errorMessage ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              left: 4,
              right: 4,
            ),
            child: Text(
              errorMessage!,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: clrRed,
              ),
            ),
          )
      ],
    );
  }
}
