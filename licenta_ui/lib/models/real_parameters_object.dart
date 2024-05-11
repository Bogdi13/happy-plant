import 'dart:convert';

class RealParametersObject {
  final int id;
  final double realTemperature;
  final double realLightLevel;
  final double realAirMoisture;
  final double realSoilMoisture;

  RealParametersObject({
    this.id = 0,
    this.realTemperature = 0.0,
    this.realLightLevel = 0.0,
    this.realAirMoisture = 0.0,
    this.realSoilMoisture = 0.0,
  });

  @override
  String toString() {
    return 'id: $id   realTemperature: $realTemperature   realLightLevel: $realLightLevel   realAirMoisture: $realAirMoisture   realSoilMoisture: $realSoilMoisture';
  }

  factory RealParametersObject.fromJson(Map<String, dynamic> json) {
    return RealParametersObject(
        id: json["id"],
        realTemperature: json["real_temperature"],
        realLightLevel: json["real_light_level"],
        realAirMoisture: json["real_air_moisture"],
        realSoilMoisture: json["real_soil_moisture"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "realTemperature": realTemperature,
        "realLightLevel": realLightLevel,
        "realAirMoisture": realAirMoisture,
        "realSoilMoisture": realSoilMoisture
      };
}

List<RealParametersObject> realParametersObjectFromJson(String str) =>
    List<RealParametersObject>.from(
        json.decode(str).map((x) => RealParametersObject.fromJson(x)));

String realParametersObjectToJson(List<RealParametersObject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
