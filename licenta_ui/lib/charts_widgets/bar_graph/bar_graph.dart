import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:licenta_ui/charts_widgets/bar_graph/individual_bar.dart';
import 'bar_data.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;

  final String chartTitle;

  const BarGraph(
      {super.key, required this.weeklySummary, required this.chartTitle});

  BarData initializeWeeklySummary(int currentDayOfWeek) {
    switch (currentDayOfWeek) {
      case 1: //mon
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek + 5],
          monAmount: weeklySummary[currentDayOfWeek - 1],
          tueAmount: weeklySummary[currentDayOfWeek + 0],
          wedAmount: weeklySummary[currentDayOfWeek + 1],
          thurAmount: weeklySummary[currentDayOfWeek + 2],
          friAmount: weeklySummary[currentDayOfWeek + 3],
          satAmount: weeklySummary[currentDayOfWeek + 4],
        );
      case 2: //tue
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek + 3],
          monAmount: weeklySummary[currentDayOfWeek + 4],
          tueAmount: weeklySummary[currentDayOfWeek - 2],
          wedAmount: weeklySummary[currentDayOfWeek - 1],
          thurAmount: weeklySummary[currentDayOfWeek + 0],
          friAmount: weeklySummary[currentDayOfWeek + 1],
          satAmount: weeklySummary[currentDayOfWeek + 2],
        );
      case 3: //wed
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek + 1],
          monAmount: weeklySummary[currentDayOfWeek + 2],
          tueAmount: weeklySummary[currentDayOfWeek + 3],
          wedAmount: weeklySummary[currentDayOfWeek - 3],
          thurAmount: weeklySummary[currentDayOfWeek - 2],
          friAmount: weeklySummary[currentDayOfWeek - 1],
          satAmount: weeklySummary[currentDayOfWeek + 0],
        );
      case 4: //thur
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek - 1],
          monAmount: weeklySummary[currentDayOfWeek + 0],
          tueAmount: weeklySummary[currentDayOfWeek + 1],
          wedAmount: weeklySummary[currentDayOfWeek + 2],
          thurAmount: weeklySummary[currentDayOfWeek - 4],
          friAmount: weeklySummary[currentDayOfWeek - 3],
          satAmount: weeklySummary[currentDayOfWeek - 2],
        );
      case 5: //fri
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek - 3],
          monAmount: weeklySummary[currentDayOfWeek - 2],
          tueAmount: weeklySummary[currentDayOfWeek - 1],
          wedAmount: weeklySummary[currentDayOfWeek + 0],
          thurAmount: weeklySummary[currentDayOfWeek + 1],
          friAmount: weeklySummary[currentDayOfWeek - 5],
          satAmount: weeklySummary[currentDayOfWeek - 4],
        );
      case 6: //sat
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek - 5],
          monAmount: weeklySummary[currentDayOfWeek - 4],
          tueAmount: weeklySummary[currentDayOfWeek - 3],
          wedAmount: weeklySummary[currentDayOfWeek - 2],
          thurAmount: weeklySummary[currentDayOfWeek - 1],
          friAmount: weeklySummary[currentDayOfWeek + 0],
          satAmount: weeklySummary[currentDayOfWeek - 6],
        );
      case 7: //sun
        return BarData(
          sunAmount: weeklySummary[currentDayOfWeek - 7],
          monAmount: weeklySummary[currentDayOfWeek - 6],
          tueAmount: weeklySummary[currentDayOfWeek - 5],
          wedAmount: weeklySummary[currentDayOfWeek - 4],
          thurAmount: weeklySummary[currentDayOfWeek - 3],
          friAmount: weeklySummary[currentDayOfWeek - 2],
          satAmount: weeklySummary[currentDayOfWeek - 1],
        );
      default:
        return BarData(
            sunAmount: 0,
            monAmount: 0,
            tueAmount: 0,
            wedAmount: 0,
            thurAmount: 0,
            friAmount: 0,
            satAmount: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int currentDayOfWeek = today.weekday;
    List<Color> barColors = List.generate(7, (index) {
      return index == currentDayOfWeek ? Colors.red : Colors.teal;
    });

    double maxYValue = 100;
    if (chartTitle.contains('temperature')) {
      maxYValue = 50;
    }
    BarData barData = initializeWeeklySummary(currentDayOfWeek);

    barData.initializeBarData();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            chartTitle,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            maxY: maxYValue,
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: false,
              )),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 50),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 30),
              ),
            ),
            barGroups: barData.barData.asMap().entries.map((entry) {
              int index = entry.key;
              IndividualBar data = entry.value;
              return BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: barColors[index],
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: 200, color: Colors.teal[50]),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.teal,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('SU', style: style);
      break;
    case 1:
      text = const Text('MO', style: style);
      break;
    case 2:
      text = const Text('TU', style: style);
      break;
    case 3:
      text = const Text('WE', style: style);
      break;
    case 4:
      text = const Text('TH', style: style);
      break;
    case 5:
      text = const Text('FR', style: style);
      break;
    case 6:
      text = const Text('SA', style: style);
      break;
    default:
      text = const Text(
        '',
        style: style,
      );
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
