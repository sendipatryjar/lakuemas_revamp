import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';

class MainDatePicker extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final String? hintText;
  final bool isRequired;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?)? onChanged;
  final bool? isElite;
  final bool enabled;
  final bool isError;
  final String? errorText;

  const MainDatePicker({
    super.key,
    this.title,
    this.titleColor,
    this.hintText,
    this.isRequired = false,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.isElite = false,
    this.enabled = true,
    this.isError = false,
    this.errorText,
  });

  @override
  State<MainDatePicker> createState() => _MainDatePickerState();
}

class _MainDatePickerState extends State<MainDatePicker> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: RichText(
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              text: TextSpan(
                  text: widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.titleColor ?? clrWhite,
                  ),
                  children: [
                    if (widget.isRequired)
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
        GestureDetector(
          onTap: widget.enabled
              ? () async {
                  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: widget.initialDate ?? DateTime(2000),
                    firstDate: widget.firstDate ?? DateTime(1900),
                    lastDate: widget.lastDate ?? DateTime.now(),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.id,
                    looping: true,
                  );
                  if (datePicked == null) return;
                  setState(() {
                    selectedDate = datePicked;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(selectedDate);
                  }
                }
              : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: clrGreyE5e.withOpacity(0.25),
              border: Border.all(
                color: widget.isError
                    ? clrRed.withOpacity(0.5)
                    : clrNeutralGrey999.withOpacity(0.16),
              ),
              borderRadius: BorderRadius.circular(15),
              gradient: widget.isError
                  ? LinearGradient(
                      colors: [
                        clrRed,
                        clrRed.withOpacity(0.9),
                        clrRed.withOpacity(0.4),
                        // clrRed.withOpacity(0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : (widget.hintText ?? ''),
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    color: widget.isError
                        ? clrRed
                        : ((selectedDate != null ||
                                ((widget.hintText ?? '').contains('/') &&
                                    (widget.hintText ?? '').length == 10))
                            ? widget.isElite!
                                ? clrWhite.withOpacity(0.75)
                                : clrBackgroundBlack.withOpacity(0.75)
                            : clrNeutralGrey999.withOpacity(0.5)),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.calendar_month,
                  color: widget.isElite!
                      ? clrWhite.withOpacity(0.75)
                      : clrBackgroundBlack.withOpacity(0.75),
                ),
              ],
            ),
          ),
        ),
        if (widget.isError && widget.errorText != null) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  widget.errorText!,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: clrRed,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              )
            ],
          )
        ]
      ],
    );
  }
}
