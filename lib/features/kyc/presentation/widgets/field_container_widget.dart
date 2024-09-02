import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class FieldContainerWidget extends StatelessWidget {
  final String? title;
  final EdgeInsetsGeometry? margin;
  final Widget content;
  final int? status;
  const FieldContainerWidget({
    super.key,
    this.title,
    this.margin,
    this.status,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: clrGreyE5e.withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: clrNeutralGrey999.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((title ?? "").isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: _statusName(status),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _statusColor(status),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const WidgetSpan(
                      child: SizedBox(width: 4),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    WidgetSpan(
                      child: Image.asset(
                        _statusIcon(status),
                        height: 16,
                        width: 16,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                  ]),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Divider(
                thickness: 1,
                color: clrBackgroundBlack.withOpacity(0.08),
              ),
            ),
          ],
          content,
        ],
      ),
    );
  }
}

class KycFieldTitleWidget extends StatelessWidget {
  final String? title;
  final int? status;
  final Widget content;
  const KycFieldTitleWidget(
      {super.key, this.title, this.status, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title ?? '',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: _statusName(status),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _statusColor(status),
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 4),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      _statusIcon(status),
                      height: 16,
                      width: 16,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                ]),
              )
            ],
          ),
          const SizedBox(height: 8),
        ],
        content,
      ],
    );
  }
}

String _statusName(int? status) {
  switch (status) {
    case 0:
      return '';
    case 1:
      return 'Verifikasi Sukses';
    case 2:
      return 'Diproses';
    case 3:
      return 'Verifikasi Gagal';
    default:
      return '';
  }
}

Color _statusColor(int? status) {
  switch (status) {
    case 0:
      return clrBackgroundBlack;
    case 1:
      return clrGreen00A;
    case 2:
      return clrBackgroundBlack;
    case 3:
      return clrRed;
    default:
      return clrBackgroundBlack;
  }
}

String _statusIcon(int? status) {
  switch (status) {
    case 0:
      return '';
    case 1:
      return icCheckCircle;
    case 2:
      return icProcess;
    case 3:
      return icCrossCircle;
    default:
      return '';
  }
}
