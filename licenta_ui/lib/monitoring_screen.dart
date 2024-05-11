import 'package:licenta_ui/parametersWidgets/air_moisture_widget.dart';
import 'package:licenta_ui/parametersWidgets/light_level_widget.dart';
import 'package:licenta_ui/parametersWidgets/soil_moisture_widget.dart';
import 'package:licenta_ui/parametersWidgets/temperature_widget.dart';
import 'package:licenta_ui/models/real_parameters_object.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MonitoringPage extends StatefulWidget {
  final RealParametersObject realParametersObject;

  const MonitoringPage({
    Key? key,
    required this.realParametersObject,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: TemperatureAirMoistureWidget(
                          realParametersObject: widget.realParametersObject)),
                  Expanded(
                    child: LightLevelSoilMoistureWidget(
                        realParametersObject: widget.realParametersObject),
                  ),
                ],
              ),
              SizedBox(height: 50),
              // ElevatedButton.icon(
              //   onPressed: getRealParameters,
              //   label: Text('Refresh'),
              //   icon: Icon(Icons.refresh),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class LightLevelSoilMoistureWidget extends StatelessWidget {
  const LightLevelSoilMoistureWidget({
    super.key,
    required this.realParametersObject,
  });

  final RealParametersObject realParametersObject;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LightLevelWidget(
            lightLevelPercent: realParametersObject.realLightLevel / 100),
        SizedBox(height: 70),
        SoilMoistureWidget(
            soilMoisturePercent: realParametersObject.realSoilMoisture / 100),
      ],
    );
  }
}

class TemperatureAirMoistureWidget extends StatelessWidget {
  const TemperatureAirMoistureWidget({
    super.key,
    required this.realParametersObject,
  });

  final RealParametersObject realParametersObject;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TemperatureWidget(
          temperatureValue: realParametersObject.realTemperature / 100,
        ),
        SizedBox(height: 70),
        AirMoistureWidget(
            airMoisturePercent: realParametersObject.realAirMoisture / 100),
      ],
    );
  }
}
