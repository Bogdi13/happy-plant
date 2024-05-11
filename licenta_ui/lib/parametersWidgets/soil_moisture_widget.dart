import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SoilMoistureWidget extends StatelessWidget {
  final double soilMoisturePercent;

  const SoilMoistureWidget({
    super.key,
    required this.soilMoisturePercent,
  });

  @override
  Widget build(BuildContext context) {
    String soilMoisturePercentFormatted =
        (soilMoisturePercent * 100).toStringAsFixed(2);
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 50,
      radius: 150,
      lineWidth: 10,
      percent: soilMoisturePercent,
      progressColor: Color.fromARGB(255, 235, 120, 13),
      backgroundColor: Color.fromARGB(255, 251, 238, 224),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "$soilMoisturePercentFormatted %",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      footer: Text(
        'Soil Moisture',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
