import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';
import 'dropdown/dropdown_search.dart';

enum MainDropdownSearchState { loading, disabled, active }

class MainDropDownSearch<T> extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final bool isRequired;
  final String? hintText;
  final Future<List<T>> Function(String)? asyncItems;
  final List<T> items;
  final T? selectedItem;
  final String Function(T)? itemAsString;
  final Function(T?)? onChanged;
  final MainDropdownSearchState state;
  final bool? isElite;
  final String? errorMessage;
  final TextEditingController? searchController;

  const MainDropDownSearch({
    super.key,
    this.title,
    this.titleColor,
    this.isRequired = false,
    this.hintText,
    this.asyncItems,
    this.items = const [],
    this.selectedItem,
    this.itemAsString,
    this.onChanged,
    this.state = MainDropdownSearchState.active,
    this.isElite = false,
    this.errorMessage,
    this.searchController,
  });

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
        state == MainDropdownSearchState.loading
            ? Shimmer.fromColors(
                baseColor: clrGreyShimmerBase,
                highlightColor: clrGreyShimmerHighlight,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: clrWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            // : state == MainDropdownSearchState.disabled
            //     ? Container(
            //         height: 64,
            //         width: double.infinity,
            //         decoration: BoxDecoration(
            //           color: clr000000.withOpacity(0.1),
            //           border: Border.all(
            //             color: clrNeutralGrey999.withOpacity(0.16),
            //           ),
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //       )
            : DropdownSearch<T>(
                enabled: state == MainDropdownSearchState.active,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps:
                      TextFieldProps(controller: searchController),
                ),
                items: items,
                asyncItems: asyncItems,
                itemAsString: itemAsString,
                selectedItem: selectedItem,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    // labelText: 'labelText',
                    // labelStyle: TextStyle(
                    //   // fontSize: 14.0,
                    //   fontWeight: FontWeight.w500,
                    //   color: clrBackgroundBlack,
                    // ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: clrNeutralGrey999.withOpacity(0.16), width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: clrNeutralGrey999.withOpacity(0.16), width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: clrNeutralGrey999.withOpacity(0.16), width: 1),
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
                      ),
                    ),
                  ),
                  baseStyle: TextStyle(
                    color: isElite!
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                onChanged: onChanged,
              ),
        if (errorMessage != null)
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
