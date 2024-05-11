import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LightLevelWidget extends StatelessWidget {
  final double lightLevelPercent;
  const LightLevelWidget({
    super.key,
    required this.lightLevelPercent,
  });

  @override
  Widget build(BuildContext context) {
    String lightLevelPercentFormatted =
        (lightLevelPercent * 100).toStringAsFixed(2);
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 10,
      radius: 150,
      lineWidth: 10,
      percent: lightLevelPercent,
      progressColor: Color.fromARGB(94, 236, 218, 10),
      backgroundColor: Color.fromARGB(255, 244, 244, 220),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "$lightLevelPercentFormatted %",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      footer: Text(
        'Light Level',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
