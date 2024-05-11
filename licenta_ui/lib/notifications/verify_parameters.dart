import 'package:flutter/cupertino.dart';
import 'package:licenta_ui/models/ideal_parameters_object.dart';
import 'package:licenta_ui/models/real_parameters_object.dart';
import 'package:licenta_ui/notifications/notifications.dart';

void verifyTemperature(
    double temperatureValue,
    double lastTemperatureValue,
    double lowestTemperature,
    double highestTemperature,
    String plantSpecies,
    String lastPlantSpecies) {
  if ((temperatureValue - lastTemperatureValue).abs() < 1 &&
      lastPlantSpecies == plantSpecies) {
    return;
  }
  // if (temperatureValue.toInt() == lastTemperatureValue.toInt() &&
  //     lastPlantSpecies == plantSpecies) {
  //   return;
  // }
  if (temperatureValue > highestTemperature) {
    highTemperatureNotification();
  }
  if (temperatureValue < lowestTemperature) {
    lowTemperatureNotification();
  }
}

void verifySoilMoisture(
    double soilMoistureValue,
    double lastSoilMoistureValue,
    double lowestSoilMoisture,
    double highestSoilMoisture,
    String plantSpecies,
    String lastPlantSpecies) {
  if ((soilMoistureValue - lastSoilMoistureValue).abs() < 1 &&
      lastPlantSpecies == plantSpecies) {
    return;
  }
  // debugPrint(soilMoistureValue.toInt().toString());
  // if (soilMoistureValue.toInt() == lastSoilMoistureValue.toInt() &&
  //     lastPlantSpecies == plantSpecies) {
  //   return;
  // }
  if (soilMoistureValue < lowestSoilMoisture) {
    lowSoilMoistureNotification();
  }
  if (soilMoistureValue > highestSoilMoisture) {
    highSoilMoistureNotification();
  }
}

void verifyLightLevel(double lightLevelValue, double lastLightLevelValue,
    double highestLightLevel, String plantSpecies, String lastPlantSpecies) {
  if ((lightLevelValue - lastLightLevelValue).abs() < 1 &&
      lastPlantSpecies == plantSpecies) {
    return;
  }
  // if (lightLevelValue.toInt() == lastLightLevelValue.toInt() &&
  //     lastPlantSpecies == plantSpecies) {
  //   return;
  // }
  if (lightLevelValue > highestLightLevel) {
    highLightLevelNotification();
  }
}

void verifyRealParameters(
    RealParametersObject realParametersObject,
    RealParametersObject lastRealParametersObject,
    IdealParametersObject idealParametersObject,
    String lastPlantSpecies) {
  verifyTemperature(
      realParametersObject.realTemperature,
      lastRealParametersObject.realTemperature,
      idealParametersObject.lowestTemperature,
      idealParametersObject.highestTemperature,
      idealParametersObject.species,
      lastPlantSpecies);
  verifySoilMoisture(
      realParametersObject.realSoilMoisture,
      lastRealParametersObject.realSoilMoisture,
      idealParametersObject.lowestSoilMoisture,
      idealParametersObject.highestSoilMoisture,
      idealParametersObject.species,
      lastPlantSpecies);
  verifyLightLevel(
      realParametersObject.realLightLevel,
      lastRealParametersObject.realLightLevel,
      idealParametersObject.highestLightLevel,
      idealParametersObject.species,
      lastPlantSpecies);
}
