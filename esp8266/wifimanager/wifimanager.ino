#include <FS.h>
#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>         // https://github.com/tzapu/WiFiManager
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>

//#include <SPIFFS.h>
#include <ArduinoJson.h>

//-- Sensor libraries --------------------
#include "DHT.h"
#include <BH1750.h>
#include <Wire.h>

#define JSON_CONFIG_FILE "/bud_config.json"

char parameter_uri_string[256] = "";
char parameter_auth_string[1024] = "";
 
bool shouldSaveConfig = false;

//---SENSOR CONFIGURATION----------------------

#define LED D0

#define DHTPIN D1  
#define LUX_SDA D2
#define LUX_SCL D3

#define DHTTYPE DHT11 

DHT dht(DHTPIN, DHTTYPE);
BH1750 lightMeter;
//---------------------------------------------

//---BUTTON CONFIGURATION----------------------
#define TRIGGER_PIN D4
unsigned long times, now;
//---------------------------------------------

WiFiManager wm;


void saveConfigFile() {
  Serial.println("Saving configuration...");

  Serial.println("saving config");
  StaticJsonDocument<2048> json;
  json["parameter_uri_string"] = parameter_uri_string;
  json["parameter_auth_string"] = parameter_auth_string;

  //Open config file
  File configFile = SPIFFS.open(JSON_CONFIG_FILE, "w");
  if(!configFile) {
    Serial.println("Error occurred opening config file for writing.");
  }
  
  serializeJsonPretty(json, Serial);
  if(serializeJson(json, configFile) == 0) {
    Serial.println(F("Failed to write to file."));
  }
  configFile.close();
}

void saveConfigCallback() {
  Serial.println("Should save config");
  shouldSaveConfig = true;
}

bool loadConfigFile() {
  Serial.println("Mounting File System...");

  if (SPIFFS.begin()) {
    Serial.println("mounted file system");
    if (SPIFFS.exists(JSON_CONFIG_FILE)) {
       Serial.println("Reading Config File...");
      File configFile = SPIFFS.open(JSON_CONFIG_FILE, "r");
      if(configFile) {
        Serial.println("Opened Config File...");
        StaticJsonDocument<2048> json;
        DeserializationError error = deserializeJson(json, configFile);
        serializeJson(json, Serial);
        if(!error){
          Serial.println("Parsing JSON...");
          strcpy(parameter_uri_string, json["parameter_uri_string"]);
          //strcpy(parameter_auth_string, json["parameter_auth_string"]);
          return true;
        }
        else {
          Serial.println("Failed to load JSON config.");
        }
      }
    }
  } else  {
    // Error mounting file system
    Serial.println("Failed to mount FS");
  }

  return false;
}



void setup() {



  //initialize sensors
  DHT dht(DHTPIN, DHTTYPE);
  Wire.begin(LUX_SDA, LUX_SCL);
  pinMode(LED, OUTPUT);
  pinMode(TRIGGER_PIN, INPUT); // button pin
  lightMeter.begin(); 

  delay(200);
  bool forceConfig = false; //change to true when testing to force configuration every time it is runned

  bool spiffsSetup = loadConfigFile();
  if(!spiffsSetup) {
    Serial.println("Forcing config mode as there is no saved config");
    forceConfig = true;
  }
  
  WiFi.mode(WIFI_STA);
  Serial.begin(115200);
  delay(10);

  //wm.resetSettings(); //finished product should have this line commentated.
  
  wm.setSaveConfigCallback(saveConfigCallback);
  
  WiFiManagerParameter parameter_uri("box_api", "Enter the API URI to start sending data",parameter_uri_string , 256);
  WiFiManagerParameter parameter_auth("box_auth", "Enter the your id Token",parameter_auth_string , 1024);
  wm.addParameter(&parameter_uri);
  wm.addParameter(&parameter_auth);
  
  
 
  bool res;

  res = wm.autoConnect("Bud System");

  if(!res) {
    Serial.println("Failed to connect");
  } else {
    Serial.println("Connected!");
    //WiFi.begin(wm.getWiFiSSID(), wm.getWiFiPass());
    Serial.print("Parameter Original Entry:");
    Serial.println(parameter_uri.getValue());
    Serial.print("Parameter token Original Entry:");
    //Serial.println(parameter_auth.getValue());
    
    strncpy(parameter_uri_string,parameter_uri.getValue(), sizeof(parameter_uri_string));
    strncpy(parameter_auth_string,parameter_auth.getValue(), sizeof(parameter_auth_string));
    Serial.print("Parameter Entry:");
    Serial.println(parameter_uri_string);
    Serial.print("Parameter token Original Entry:");
    Serial.println(parameter_auth_string);
    Serial.println("DONE");
    
    if(shouldSaveConfig){
      saveConfigFile();
    }
    
  }

  
}


void loop(){
  
  if(digitalRead(TRIGGER_PIN) == LOW) {

    Serial.println("Reset!");
    Serial.println("turning off in 3 seconds");
    delay(3000);
    wm.resetSettings();
    ESP.restart();
  }

  if(WiFi.status()== WL_CONNECTED){

      float humidity = dht.readHumidity();
      float lux = lightMeter.readLightLevel();
      float temp = dht.readTemperature();

      float previousHumidity = 0;
      float previousLux = 0;
      float previousTemp = 0;
      
      WiFiClient client;
      HTTPClient http;
            
      // Your Domain name with URL path or IP address with path
      http.begin(client, parameter_uri_string);
      
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Authorization", parameter_auth_string);
      Serial.println("MAKING GET REQUEST FOR WATERING PLANT");
      int httpGetResponseCode = http.GET();
      //check if watering property is TRUE, if it is, water the plant for 5 seconds and then update all values with watering set always to false
      if(httpGetResponseCode > 0) {
        Serial.print("HTTP GET Response code: ");
        Serial.println(httpGetResponseCode);
        String payload = http.getString();
        Serial.print("Payload: ");
        Serial.println(payload);
        
        DynamicJsonDocument jsonBud(1024);

        DeserializationError error = deserializeJson(jsonBud, payload);
        if (error) {
          Serial.print(F("deserializeJson() failed: "));
          Serial.println(error.f_str());
          http.end();
          return;
        }
        bool watering = jsonBud["watering"];
        previousHumidity = jsonBud["humidity"];
        previousLux = jsonBud["luminosity"];
        previousTemp = jsonBud["temperature"];
        
        Serial.print("Watering value: ");
        Serial.println(watering);
        if(watering) {
          digitalWrite(LED, HIGH);
          delay(5000);
        } else {
          digitalWrite(LED, LOW);
        }
                
      }
      else {
        Serial.print("Error code: ");
        Serial.println(httpGetResponseCode);
      }

      http.end();
      Serial.println("MAKING PUT REQUEST");//--------------------------------------------------------------------------------------------------
      http.begin(client, parameter_uri_string);
      
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Authorization", parameter_auth_string);
      String body = "{\"ph\":PH,\"humidity\":HUMIDITY,\"luminosity\":LUMINOSITY,\"temperature\":TEMPERATURE,\"watering\":false}";

      body.replace("PH", String(rand() % 7 + 1));
      
      if(isnan(humidity) || humidity < 0) body.replace("HUMIDITY", String(previousHumidity, 2));
      else body.replace("HUMIDITY", String(humidity, 2));

      if(isnan(lux) || lux < 0) body.replace("LUMINOSITY", String(previousLux, 2));
      else body.replace("LUMINOSITY", String(lux, 2));

      if(isnan(temp) || temp < 0) body.replace("TEMPERATURE", String(previousTemp, 2));
      else body.replace("TEMPERATURE", String(temp, 2));      
      
      Serial.print("Body: ");
      Serial.println(body);
      int httpPutResponseCode = http.PUT(body);
     
      Serial.print("HTTP PUT Response code: ");
      Serial.println(httpPutResponseCode);

      // Free resources
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }

    delay(3000);  
}
