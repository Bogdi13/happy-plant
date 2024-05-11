#include <dht.h>

dht DHT;

const int dht11Pin = 7;                 // Set digital pin 7 for air moisture and temperature sensor
const double ldrPin = A0;               // Set analog pin 0 for LDR (for light sensor)
const int soilSensorPin =  A1;          // Set analog pin 1 for soil moisture sensor
const int dry = 550;                    // Set value of the sensor for the most dry soil
const int wet = 200;                    // Set value of the sensor for the most wet soil

double mapSoilValue(double x, double in_min, double in_max, double out_min, double out_max) {
  double mapped_value = (x - in_max) * (out_min - out_max) / (in_min - in_max) + out_max;
  return mapped_value;
}

// conversion to double for light level
double mapLightLevelValue(double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void setup() {
  Serial.begin(9600);                   // Set the serial begin
  pinMode(dht11Pin, INPUT);             // Set the pin to input for air moisture and temperature
  pinMode(ldrPin, INPUT);               // Set the pin to input for light level
  pinMode(soilSensorPin, INPUT);        // Set the pin to input for soil moisture
}

void loop() {
  // Read data from sensors
  DHT.read11(dht11Pin);                                                             // Read the values of air temperature and moisture from sensor
  int ldrStatus = analogRead(ldrPin);                                               // Read the LDR value
  double percentageLightLevel = mapLightLevelValue(ldrStatus, 0, 1000, 0, 100);     // Convert LDR value to percentage
  int soilSensorValue = analogRead(soilSensorPin);                                  // Read the soil sensor value
  double percentageSoilHumidity = mapSoilValue(soilSensorValue, wet, dry, 100, 0);  // Convert soil sensor value to percentage

  // Print data from sensors splited by comma
  Serial.print(DHT.temperature);                // Print the air temperature value (Celsius)
  Serial.print(",");
  Serial.print(percentageLightLevel);           // Print the light level (Percentage)
  Serial.print(",");
  Serial.print(DHT.humidity);                   // Print the air moisture value (Percentage)
  Serial.print(",");
  Serial.println(percentageSoilHumidity);       // Print the soil moisture value (Percentage)
  delay(1000);                                  // Detect the values every 5 sec
}