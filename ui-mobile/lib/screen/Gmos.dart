import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GMosRepair extends StatefulWidget {
  GMosRepair({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _GMosRepairState createState() => _GMosRepairState();
}

class _GMosRepairState extends State<GMosRepair> {
  late List<ChartSampleData> _chartData;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
      title: ChartTitle(text: 'GMOS Repair Q Depth'),
      // legend: Legend(isVisible: true),
      trackballBehavior: _trackballBehavior,
      series: <CandleSeries>[
        CandleSeries<ChartSampleData, DateTime>(
            dataSource: _chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close)
      ],
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.MMM(),
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        minimum: 80,
        maximum: 120,
        interval: 10,
        // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
      ),
    )));
  }

  List<ChartSampleData> getChartData() {
    return <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2016, 01, 4),
          open: 110.00,
          high: 110.19,
          low: 95.36,
          close: 97.13),
      ChartSampleData(
          x: DateTime(2016, 01, 6),
          open: 98.41,
          high: 101.46,
          low: 93.42,
          close: 101.42),
      ChartSampleData(
          x: DateTime(2016, 01, 8),
          open: 101.52,
          high: 101.53,
          low: 92.39,
          close: 97.34),
      ChartSampleData(
          x: DateTime(2016, 01, 10),
          open: 96.47,
          high: 97.33,
          low: 93.69,
          close: 94.02),
      ChartSampleData(
          x: DateTime(2016, 01, 12),
          open: 93.13,
          high: 96.35,
          low: 92.59,
          close: 93.99),
      ChartSampleData(
          x: DateTime(2016, 01, 14),
          open: 91.02,
          high: 94.89,
          low: 90.61,
          close: 92.04),
      ChartSampleData(
          x: DateTime(2016, 01, 16),
          open: 96.31,
          high: 98.0237,
          low: 98.0237,
          close: 96.31),
      ChartSampleData(
          x: DateTime(2016, 01, 18),
          open: 99.86,
          high: 106.75,
          low: 99.65,
          close: 106.01),
      ChartSampleData(
          x: DateTime(2016, 01, 20),
          open: 102.39,
          high: 102.83,
          low: 100.15,
          close: 102.26),
      ChartSampleData(
          x: DateTime(2016, 01, 22),
          open: 101.91,
          high: 106.5,
          low: 101.78,
          close: 105.92),
      ChartSampleData(
          x: DateTime(2016, 01, 24),
          open: 105.93,
          high: 107.65,
          low: 104.89,
          close: 105.67),
      ChartSampleData(
          x: DateTime(2016, 01, 26),
          open: 106,
          high: 110.42,
          low: 104.88,
          close: 109.99),
      ChartSampleData(
          x: DateTime(2016, 01, 28),
          open: 110.42,
          high: 112.19,
          low: 108.121,
          close: 108.66),
      ChartSampleData(
          x: DateTime(2016, 01, 30),
          open: 108.97,
          high: 112.39,
          low: 108.66,
          close: 109.85),
      ChartSampleData(
          x: DateTime(2016, 02, 01),
          open: 108.89,
          high: 108.95,
          low: 104.62,
          close: 105.68),
      ChartSampleData(
          x: DateTime(2016, 02, 03),
          open: 105,
          high: 105.65,
          low: 92.51,
          close: 93.74),
      ChartSampleData(
          x: DateTime(2016, 02, 05),
          open: 93.965,
          high: 95.9,
          low: 91.85,
          close: 92.72),
      ChartSampleData(
          x: DateTime(2016, 02, 07),
          open: 93,
          high: 93.77,
          low: 89.47,
          close: 90.52),
      ChartSampleData(
          x: DateTime(2016, 02, 09),
          open: 92.39,
          high: 95.43,
          low: 91.65,
          close: 95.22),
      ChartSampleData(
          x: DateTime(2016, 02, 11),
          open: 95.87,
          high: 100.73,
          low: 95.67,
          close: 100.35),
      ChartSampleData(
          x: DateTime(2016, 02, 13),
          open: 99.6,
          high: 100.4,
          low: 96.63,
          close: 97.92),
      ChartSampleData(
          x: DateTime(2016, 02, 14),
          open: 97.99,
          high: 101.89,
          low: 97.55,
          close: 98.83),
      ChartSampleData(
          x: DateTime(2016, 02, 15),
          open: 98.69,
          high: 99.12,
          low: 95.3,
          close: 95.33),
      ChartSampleData(
          x: DateTime(2016, 02, 16),
          open: 96,
          high: 96.89,
          low: 92.65,
          close: 93.4),
      ChartSampleData(
          x: DateTime(2016, 02, 17),
          open: 93,
          high: 96.465,
          low: 91.5,
          close: 95.89),
      ChartSampleData(
          x: DateTime(2016, 02, 18),
          open: 95.39,
          high: 96.89,
          low: 94.37,
          close: 96.68),
      ChartSampleData(
          x: DateTime(2016, 02, 19),
          open: 96.75,
          high: 99.3,
          low: 96.73,
          close: 98.78),
      ChartSampleData(
          x: DateTime(2016, 02, 20),
          open: 98.7,
          high: 101,
          low: 98.31,
          close: 98.66),
      ChartSampleData(
          x: DateTime(2016, 02, 21),
          open: 98.25,
          high: 104.55,
          low: 96.42,
          close: 104.21),
      ChartSampleData(
          x: DateTime(2016, 02, 22),
          open: 104.41,
          high: 107.65,
          low: 104,
          close: 107.48),
      ChartSampleData(
          x: DateTime(2016, 02, 23),
          open: 107.52,
          high: 108.94,
          low: 107.16,
          close: 108.18),
      ChartSampleData(
          x: DateTime(2016, 02, 24),
          open: 108.14,
          high: 110.23,
          low: 108.08,
          close: 109.36),
      ChartSampleData(
          x: DateTime(2016, 02, 25),
          open: 108.86,
          high: 109.32,
          low: 106.31,
          close: 106.94),
      ChartSampleData(
          x: DateTime(2016, 02, 26),
          open: 106.62,
          high: 108,
          low: 105.5,
          close: 107.73),
      ChartSampleData(
          x: DateTime(2016, 02, 27),
          open: 107.9,
          high: 108.76,
          low: 103.13,
          close: 103.13),
      ChartSampleData(
          x: DateTime(2016, 03, 01),
          open: 102.65,
          high: 116.13,
          low: 102.53,
          close: 114.92),
      ChartSampleData(
          x: DateTime(2016, 03, 03),
          open: 115.19,
          high: 116.18,
          low: 111.55,
          close: 112.71),
      ChartSampleData(
          x: DateTime(2016, 03, 05),
          open: 111.64,
          high: 114.64,
          low: 111.55,
          close: 113.05),
    ];
  }
}

class ChartSampleData {
  ChartSampleData({
    this.x,
    this.open,
    this.close,
    this.low,
    this.high,
  });

  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
}
