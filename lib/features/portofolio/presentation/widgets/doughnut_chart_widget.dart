import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class DoughnutChartWidget extends StatelessWidget {
  final List<PortofolioChartData> listData;
  final String? goldAsset;
  final bool isElite;
  final double? radiusInPercent;
  const DoughnutChartWidget({
    super.key,
    this.listData = const [],
    this.goldAsset,
    this.isElite = false,
    this.radiusInPercent,
  });

  @override
  Widget build(BuildContext context) {
    return _buildElevationDoughnutChart(context,
        radiusInPercent: radiusInPercent);
  }

  SfCircularChart _buildElevationDoughnutChart(
    BuildContext context, {
    double? radiusInPercent,
  }) {
    return SfCircularChart(
      /// It used to set the annotation on circular chart.
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Asset Emas',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: (isElite ? clrWhite : clrBackgroundBlack)
                      .withOpacity(0.75),
                ),
              ),
              Text(
                '${goldAsset ?? '-'} gr',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ],
          ),
        ),
      ],
      // title: ChartTitle(
      //   text: 'Progress of a task',
      //   textStyle: const TextStyle(fontSize: 20),
      // ),
      series: _getElevationDoughnutSeries(
          listData: listData, radiusInPercent: radiusInPercent),
    );
  }

  /// Returns the doughnut series which need to be center elevation.
  List<DoughnutSeries<PortofolioChartData, String>>
      _getElevationDoughnutSeries({
    double? radiusInPercent,
    List<PortofolioChartData> listData = const [],
  }) {
    return <DoughnutSeries<PortofolioChartData, String>>[
      DoughnutSeries<PortofolioChartData, String>(
          dataSource: listData.isEmpty
              ? <PortofolioChartData>[
                  PortofolioChartData(
                    x: 'A',
                    y: 60,
                    pointColor: clrYellow,
                  ),
                  PortofolioChartData(
                    x: 'B',
                    y: 10,
                    pointColor: clrPurple,
                  ),
                  PortofolioChartData(
                    x: 'C',
                    y: 30,
                    pointColor: clrNeutralGrey999.withOpacity(0.16),
                  ),
                ]
              : listData,
          animationDuration: 0,
          explode: true,
          explodeAll: true,
          explodeOffset: '3%',
          innerRadius: '70%',
          radius: radiusInPercent != null ? "$radiusInPercent%" : null,
          xValueMapper: (PortofolioChartData data, _) => data.x as String,
          yValueMapper: (PortofolioChartData data, _) => data.y,
          pointColorMapper: (PortofolioChartData data, _) => data.pointColor)
    ];
  }
}

class PortofolioChartData {
  final String? x;
  final double? y;
  final Color? pointColor;

  PortofolioChartData({this.x, this.y, this.pointColor});
}
