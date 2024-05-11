class IdealParametersObject {
  final int id;
  final String species;
  final double lowestTemperature;
  final double highestTemperature;
  final double highestLightLevel;
  final double lowestSoilMoisture;
  final double highestSoilMoisture;
  final double lowestAirMoisture;
  final double highestAirMoisture;

  IdealParametersObject({
    this.id = 0,
    this.species = '',
    this.lowestTemperature = 0.0,
    this.highestTemperature = 0.0,
    this.highestLightLevel = 0.0,
    this.lowestSoilMoisture = 0.0,
    this.highestSoilMoisture = 0.0,
    this.lowestAirMoisture = 0.0,
    this.highestAirMoisture = 0.0,
  });

  @override
  String toString() {
    return 'id: $id   species: $species   lowestTemperature: $lowestTemperature   highestLightLevel: $highestLightLevel   lowestSoilMoisture: $lowestSoilMoisture   highestSoilMoisture: $highestSoilMoisture  lowestAirMoisture: $lowestAirMoisture  highestAirMoisture: $highestAirMoisture';
  }

  factory IdealParametersObject.fromJson(Map<String, dynamic> json) {
    return IdealParametersObject(
      id: json["id"],
      species: json["species"],
      lowestTemperature: json["lowest_temperature"],
      highestTemperature: json["highest_temperature"],
      highestLightLevel: json["highest_light_level"],
      lowestSoilMoisture: json["lowest_soil_moisture"],
      highestSoilMoisture: json["highest_soil_moisture"],
      lowestAirMoisture: json["lowest_air_moisture"],
      highestAirMoisture: json["highest_air_moisture"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "species": species,
        "lowestTemperature": lowestTemperature,
        "highestTemperature": highestTemperature,
        "highestLightLevel": highestLightLevel,
        "lowestSoilMoisture": lowestSoilMoisture,
        "highestSoilMoisture": highestSoilMoisture,
        "lowestAirMoisture": lowestAirMoisture,
        "highestAirMoisture": highestAirMoisture,
      };
}
