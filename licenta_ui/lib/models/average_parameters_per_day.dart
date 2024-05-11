import 'dart:convert';

class AverageParametersPerDay {
  final double averageTemperature;
  final double averageLightLevel;
  final double averageAirMoisture;
  final double averageSoilMoisture;

  AverageParametersPerDay({
    this.averageTemperature = 0.0,
    this.averageLightLevel = 0.0,
    this.averageAirMoisture = 0.0,
    this.averageSoilMoisture = 0.0,
  });

  @override
  String toString() {
    return 'averageTemperature: $averageTemperature   averageLightLevel: $averageLightLevel   averageAirMoisture: $averageAirMoisture   averageSoilMoisture: $averageSoilMoisture';
  }

  factory AverageParametersPerDay.fromJson(Map<String, dynamic> json) {
    return AverageParametersPerDay(
        averageTemperature: json["average_temperature"],
        averageLightLevel: json["average_light_level"],
        averageAirMoisture: json["average_air_moisture"],
        averageSoilMoisture: json["average_soil_moisture"]);
  }

  Map<String, dynamic> toJson() => {
        "averageTemperature": averageTemperature,
        "averageLightLevel": averageLightLevel,
        "averageAirMoisture": averageAirMoisture,
        "averageSoilMoisture": averageSoilMoisture
      };
}

List<AverageParametersPerDay> averageParametersPerDayFromJson(String str) =>
    List<AverageParametersPerDay>.from(
        json.decode(str).map((x) => AverageParametersPerDay.fromJson(x)));

String averageParametersPerDayToJson(List<AverageParametersPerDay> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
