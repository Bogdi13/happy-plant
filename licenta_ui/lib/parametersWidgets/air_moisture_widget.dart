import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AirMoistureWidget extends StatelessWidget {
  final double airMoisturePercent;

  const AirMoistureWidget({
    super.key,
    required this.airMoisturePercent,
  });

  @override
  Widget build(BuildContext context) {
    String airMoisturePercentFormatted =
        (airMoisturePercent * 100).toStringAsFixed(2);
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 50,
      radius: 150,
      lineWidth: 10,
      percent: airMoisturePercent,
      progressColor: Color.fromARGB(255, 135, 189, 216),
      backgroundColor: Color.fromARGB(255, 224, 234, 237),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "$airMoisturePercentFormatted %",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      footer: Text(
        'Air Moisture',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
