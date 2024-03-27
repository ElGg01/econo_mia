import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartTransaction extends StatefulWidget {
  const ChartTransaction({
    super.key,
    required this.text,
    required this.data,
  });

  final String text;
  final List<ChartData> data;

  @override
  State<ChartTransaction> createState() => _ChartTransactionState();
}

class _ChartTransactionState extends State<ChartTransaction> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: const Legend(
        isVisible: false,
      ),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          height: '100%',
          width: '100%',
          widget: Container(
            child: PhysicalModel(
              shape: BoxShape.circle,
              elevation: 10,
              shadowColor: Colors.black,
              color: Theme.of(context).colorScheme.background,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
        CircularChartAnnotation(
          widget: Container(),
        ),
      ],
      series: <CircularSeries>[
        // Renders doughnut chart
        DoughnutSeries<ChartData, String>(
          dataSource: widget.data,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
