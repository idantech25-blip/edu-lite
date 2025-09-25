import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'animated_stat.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardBackground = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Reports",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Grading Stats",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  AnimatedStat(label: "My Classes", endValue: 5, textColor: textColor, backgroundColor: cardBackground),
                  AnimatedStat(label: "Total IT Trainees", endValue: 32, textColor: textColor, backgroundColor: cardBackground),
                  AnimatedStat(label: "Papers To Grade", endValue: 18, textColor: textColor, backgroundColor: cardBackground),
                  AnimatedStat(label: "Graded This Semester", endValue: 103, textColor: textColor, backgroundColor: cardBackground),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "Semester Grading Trend",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 250,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 12,
                    minY: 0,
                    maxY: 15,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text(
                            '${value.toInt() + 1}',
                            style: TextStyle(color: textColor),
                          ),
                          interval: 1,
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 2),
                          FlSpot(1, 3),
                          FlSpot(2, 4),
                          FlSpot(3, 5),
                          FlSpot(4, 6),
                          FlSpot(5, 5),
                          FlSpot(6, 7),
                          FlSpot(7, 6),
                          FlSpot(8, 8),
                          FlSpot(9, 9),
                          FlSpot(10, 10),
                          FlSpot(11, 11),
                          FlSpot(12, 13),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.teal,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.teal.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
