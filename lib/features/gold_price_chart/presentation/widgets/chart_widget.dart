import 'package:flutter/material.dart';
import '../../../../cores/extensions/date_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../cores/constants/app_color.dart';
import '../../domain/entities/chart_entity.dart';
import '../cubits/filter_tab/filter_tab_cubit.dart';

class ChartWidget extends StatelessWidget {
  final bool isElite;
  final List<ChartEntity> chartData;
  final bool isPurchase;
  final EnFilteredTab? enFilteredTab;
  final Function(ChartTouchInteractionArgs)? onChartTap;
  final Function(ChartTouchInteractionArgs)? onChartTapMove;
  final Function(ChartTouchInteractionArgs)? onChartTapDone;
  final Function(dynamic, dynamic)? onTrackballPositionChanging;
  final Function(ChartSeriesController)? onRendererCreated;
  const ChartWidget({
    super.key,
    required this.isElite,
    required this.chartData,
    this.isPurchase = true,
    required this.enFilteredTab,
    this.onChartTap,
    this.onChartTapMove,
    this.onChartTapDone,
    this.onTrackballPositionChanging,
    this.onRendererCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      onTrackballPositionChanging: onTrackballPositionChanging != null
          ? (trackballArgs) {
              onTrackballPositionChanging!(
                trackballArgs.chartPointInfo.chartDataPoint?.x,
                trackballArgs.chartPointInfo.chartDataPoint?.y,
              );
            }
          : null,
      onChartTouchInteractionDown: onChartTap,
      onChartTouchInteractionMove: onChartTapMove,
      onChartTouchInteractionUp: onChartTapDone,
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        enableDoubleTapZooming: true,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
        markerSettings: TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible,
          color: clrWhite,
          height: 8,
          width: 8,
        ),
      ),
      // tooltipBehavior: TooltipBehavior(
      //   enable: true,
      //   activationMode: ActivationMode.singleTap,
      //   duration: 2000,
      // ),
      primaryXAxis: CategoryAxis(
        labelRotation: 30,
        labelPlacement: LabelPlacement.onTicks,
        labelStyle: TextStyle(
          fontSize: 10,
          color: isElite ? clrWhite : clrBackgroundBlack,
        ),
        axisBorderType: AxisBorderType.withoutTopAndBottom,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [3, 3],
          color: clrNeutralGrey999.withOpacity(0.32),
        ),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value} k',
        borderColor: clrYellow,
        axisLine: const AxisLine(width: 0),
        tickPosition: TickPosition.outside,
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isElite ? clrWhite : clrBackgroundBlack,
        ),
        // maximumLabels: 6,
        desiredIntervals: 6,
      ),
      plotAreaBorderColor: Colors.transparent,
      selectionType: SelectionType.point,
      selectionGesture: ActivationMode.singleTap,
      series: <SplineAreaSeries<ChartEntity, String>>[
        SplineAreaSeries<ChartEntity, String>(
          dataSource: chartData,
          borderWidth: 2,
          borderColor: clrYellow,
          enableTooltip: true,
          splineType: SplineType.cardinal,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              clrYellow.withOpacity(0.3),
              clrYellow.withOpacity(0.1),
            ],
          ),
          borderDrawMode: BorderDrawMode.top,
          xValueMapper: (ChartEntity data, _) =>
              _xValue(enFilteredTab, data.activeDate),
          yValueMapper: (ChartEntity data, _) => _yValue(
              (isPurchase ? data.sellingPrice : data.purchaseePrice)
                  .toString()),
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   height: 4,
          //   width: 4,
          // ),
          onRendererCreated: onRendererCreated,
          cardinalSplineTension: 0.1,
        )
      ],
    );
  }

  String _xValue(EnFilteredTab? enFilteredTab, String? activeDate) {
    switch (enFilteredTab) {
      case EnFilteredTab.sevenDays:
        return activeDate?.toDateDayMonth() ?? '-';
      case EnFilteredTab.oneMonth:
        return activeDate?.toDateDayMonth() ?? '-';
      case EnFilteredTab.thirdMonth:
        return activeDate?.toDateDayMonth() ?? '-';
      case EnFilteredTab.sixMonth:
        return activeDate?.toDateDayMonth() ?? '-';
      default:
        return '-';
    }
  }

  double _yValue(String? value) {
    if (value == null) return 0;
    if (value.length < 3) {
      return double.parse(value);
    }
    var cutter = value.length - 3;
    if (value.contains(".")) {
      cutter =
          value.length - (3 + (value.split(".").lastOrNull ?? "").length + 1);
    }
    var val = value.substring(0, cutter);
    return double.parse(val);
  }
}
