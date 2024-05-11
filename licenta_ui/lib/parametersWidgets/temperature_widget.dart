import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TemperatureWidget extends StatelessWidget {
  final double temperatureValue;

  const TemperatureWidget({
    super.key,
    required this.temperatureValue,
  });

  @override
  Widget build(BuildContext context) {
    String temperatureValueFormatted =
        (temperatureValue * 100).toStringAsFixed(2);
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 50,
      radius: 150,
      lineWidth: 10,
      percent: temperatureValue,
      progressColor: Color.fromARGB(255, 116, 235, 138),
      backgroundColor: Color.fromARGB(255, 217, 238, 227),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        "$temperatureValueFormatted °C",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      footer: Text(
        'Temperature',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
