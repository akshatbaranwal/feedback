import 'package:fl_chart/fl_chart.dart';

import '../import.dart';

class Graph extends StatelessWidget {
  final FacultyRating data;
  Graph(this.data);

  BarChartRodData rod(double val) {
    return BarChartRodData(
      colors: [
        Colors.blueGrey.shade400,
        Colors.blueGrey.shade500,
        Colors.blueGrey.shade600,
      ],
      y: double.parse(val.toStringAsFixed(1)),
      width: 20,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 10,
        right: 20,
        left: 10,
      ),
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          minY: 0,
          maxY: 100,
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              margin: 10,
              showTitles: true,
              interval: 10,
            ),
            bottomTitles: SideTitles(
              rotateAngle: -10,
              showTitles: true,
              margin: 10,
              getTitles: (id) => [
                'Lecture',
                'Demo',
                'Slide',
                'Syllabus',
                'Lab',
                'Interaction',
              ][id.toInt()],
            ),
          ),
          gridData: FlGridData(
            checkToShowHorizontalLine: (value) => value % 10 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              strokeWidth: value / 250,
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [rod(data.lecture)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [rod(data.demo)],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [rod(data.slide)],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [rod(data.syllabus)],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [rod(data.lab)],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [rod(data.interaction)],
            ),
          ],
        ),
      ),
    );
  }
}
