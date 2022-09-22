#include "DHT.h"
#include <BH1750.h>
#include <Wire.h>

#define DHTPIN D1  
#define LUX_SDA D2
#define LUX_SCL D3

#define DHTTYPE DHT11 

DHT dht(DHTPIN, DHTTYPE);
BH1750 lightMeter;

void setup(void) {
  
  Serial.begin(9600);
  DHT dht(DHTPIN, DHTTYPE);
  Wire.begin(LUX_SDA, LUX_SCL);
  lightMeter.begin(); 
}

void loop(void) { 
  delay(2000);

  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();

  Serial.print(F("Humidity: "));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.print(F("°C "));
  Serial.println();
  
  float lux = lightMeter.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");

}
