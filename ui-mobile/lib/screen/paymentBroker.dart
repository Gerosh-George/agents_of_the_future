import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PaymentBroker extends StatefulWidget {
  PaymentBroker({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PaymentBrokerState createState() => _PaymentBrokerState();
}

class _PaymentBrokerState extends State<PaymentBroker> {
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
      title: ChartTitle(text: 'Payment Broker Q depth'),
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
        minimum: 190,
        maximum: 320,
        interval: 20,
        // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
      ),
    )));
  }

  List<ChartSampleData> getChartData() {
    return <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2016, 01, 4),
          open: 195.00,
          high: 193.19,
          low: 199.36,
          close: 210.13),
      ChartSampleData(
          x: DateTime(2016, 01, 6),
          open: 197.41,
          high: 194.46,
          low: 210.42,
          close: 215.42),
      ChartSampleData(
          x: DateTime(2016, 01, 8),
          open: 220.52,
          high: 227.53,
          low: 235.39,
          close: 232.34),
      ChartSampleData(
          x: DateTime(2016, 01, 10),
          open: 235.47,
          high: 245.33,
          low: 260.69,
          close: 242.02),
      ChartSampleData(
          x: DateTime(2016, 01, 12),
          open: 240.13,
          high: 265.35,
          low: 230.59,
          close: 242.99),
      ChartSampleData(
          x: DateTime(2016, 01, 14),
          open: 245.02,
          high: 255.89,
          low: 260.61,
          close: 254.04),
      ChartSampleData(
          x: DateTime(2016, 01, 16),
          open: 250.31,
          high: 266.0237,
          low: 272.0237,
          close: 264.31),
      ChartSampleData(
          x: DateTime(2016, 01, 18),
          open: 260.86,
          high: 270.75,
          low: 254.65,
          close: 260.01),
      ChartSampleData(
          x: DateTime(2016, 01, 20),
          open: 266.39,
          high: 270.83,
          low: 248.15,
          close: 265.26),
      ChartSampleData(
          x: DateTime(2016, 01, 22),
          open: 275.91,
          high: 266.5,
          low: 289.78,
          close: 266.92),
      ChartSampleData(
          x: DateTime(2016, 01, 24),
          open: 285.93,
          high: 299.65,
          low: 310.89,
          close: 315.67),
      ChartSampleData(
          x: DateTime(2016, 01, 26),
          open: 290,
          high: 295.42,
          low: 310.88,
          close: 299.99),
      ChartSampleData(
          x: DateTime(2016, 01, 28),
          open: 299.42,
          high: 310.19,
          low: 288.121,
          close: 289.66),
      ChartSampleData(
          x: DateTime(2016, 01, 30),
          open: 285.97,
          high: 289.39,
          low: 287.66,
          close: 279.85),
      ChartSampleData(
          x: DateTime(2016, 02, 01),
          open: 270.89,
          high: 281.95,
          low: 266.62,
          close: 272.68),
      ChartSampleData(
          x: DateTime(2016, 02, 03),
          open: 270,
          high: 268.65,
          low: 265.51,
          close: 271.74),
      ChartSampleData(
          x: DateTime(2016, 02, 05),
          open: 266.965,
          high: 255.9,
          low: 281.85,
          close: 250.72),
      ChartSampleData(
          x: DateTime(2016, 02, 07),
          open: 250,
          high: 265.77,
          low: 255.47,
          close: 257.52),
      ChartSampleData(
          x: DateTime(2016, 02, 09),
          open: 254.39,
          high: 265.43,
          low: 240.65,
          close: 257.22),
      ChartSampleData(
          x: DateTime(2016, 02, 11),
          open: 261.87,
          high: 277.73,
          low: 289.67,
          close: 272.35),
      ChartSampleData(
          x: DateTime(2016, 02, 13),
          open: 272.6,
          high: 268.4,
          low: 284.63,
          close: 284.92),
      ChartSampleData(
          x: DateTime(2016, 02, 14),
          open: 284.99,
          high: 294.89,
          low: 289.55,
          close: 298.83),
      ChartSampleData(
          x: DateTime(2016, 02, 15),
          open: 285.69,
          high: 289.12,
          low: 278.3,
          close: 299.33),
      ChartSampleData(
          x: DateTime(2016, 02, 16),
          open: 300,
          high: 310.89,
          low: 309.65,
          close: 306.4),
      ChartSampleData(
          x: DateTime(2016, 02, 17),
          open: 299,
          high: 310.465,
          low: 305.5,
          close: 299.89),
      ChartSampleData(
          x: DateTime(2016, 02, 18),
          open: 301.39,
          high: 310.89,
          low: 321.37,
          close: 300.68),
      ChartSampleData(
          x: DateTime(2016, 02, 19),
          open: 299.75,
          high: 310.3,
          low: 290.73,
          close: 301.78),
      ChartSampleData(
          x: DateTime(2016, 02, 20),
          open: 300.7,
          high: 289,
          low: 299.31,
          close: 297.66),
      ChartSampleData(
          x: DateTime(2016, 02, 21),
          open: 299.25,
          high: 320.55,
          low: 301.42,
          close: 291.21),
      ChartSampleData(
          x: DateTime(2016, 02, 22),
          open: 299.41,
          high: 302.65,
          low: 290,
          close: 298.48),
      ChartSampleData(
          x: DateTime(2016, 02, 23),
          open: 287.52,
          high: 282.94,
          low: 275.16,
          close: 274.18),
      ChartSampleData(
          x: DateTime(2016, 02, 24),
          open: 275.14,
          high: 281.23,
          low: 275.08,
          close: 264.36),
      ChartSampleData(
          x: DateTime(2016, 02, 25),
          open: 265.86,
          high: 250.32,
          low: 240.31,
          close: 240.94),
      ChartSampleData(
          x: DateTime(2016, 02, 26),
          open: 255.62,
          high: 258,
          low: 260.5,
          close: 260.73),
      ChartSampleData(
          x: DateTime(2016, 02, 27),
          open: 260.9,
          high: 271.76,
          low: 260.13,
          close: 267.13),
      ChartSampleData(
          x: DateTime(2016, 03, 01),
          open: 265.65,
          high: 271.13,
          low: 264.53,
          close: 268.92),
      ChartSampleData(
          x: DateTime(2016, 03, 03),
          open: 258.19,
          high: 271.18,
          low: 266.55,
          close: 269.71),
      ChartSampleData(
          x: DateTime(2016, 03, 05),
          open: 280.64,
          high: 291.64,
          low: 281.55,
          close: 288.05),
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
