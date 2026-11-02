import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A tiny line chart with no axes, used inside price rows.
class Sparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  const Sparkline({super.key, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const SizedBox(width: 72, height: 36);
    return SizedBox(
      width: 72,
      height: 36,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < data.length; i++)
                  FlSpot(i.toDouble(), data[i]),
              ],
              isCurved: true,
              color: color,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
