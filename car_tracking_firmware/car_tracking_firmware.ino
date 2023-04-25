#include "Arduino.h"
#include "SFE_BMP180.h"
#include "DHT.h"
#include "MPU6050.h"
#include "Wire.h"
#include "I2Cdev.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <ArduinoJson.h>

#define DHT_PIN_DATA 0
#define GPS_PIN_TX 13
#define GPS_PIN_RX 12

int16_t mpu6050Ax, mpu6050Ay, mpu6050Az;
int16_t mpu6050Gx, mpu6050Gy, mpu6050Gz;

SFE_BMP180 bmp180;
DHT dht(DHT_PIN_DATA);
MPU6050 mpu6050;
SoftwareSerial ss(GPS_PIN_TX, GPS_PIN_RX);
TinyGPSPlus gps;

const char *ssid = "DileepaMobilink";
const char *password = "rt341gnmlj";

String apiserver = "https://test-cars.onrender.com/create";

const int timeout = 10000;
char menuOption = 0;

unsigned long lastTime = 0;

float latitude, longitude;
String lat_str, lng_str;
int date, month, year, hour, minute, second, pm;
String time_str, date_str;


void setup() {
  Serial.begin(9600);
  while (!Serial) {}
  Serial.println("start");

  bmp180.begin();
  dht.begin();
  Wire.begin();
  mpu6050.initialize();
  menuOption = menu();

  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());

  Serial.println("Timer set to 5 seconds (timerDelay variable).");
}

void loop() {

  if (menuOption == '1') {

    double bmp180Alt = bmp180.altitude();
    double bmp180Pressure = bmp180.getPressure();
    double bmp180TempC = bmp180.getTemperatureC();
    Serial.print(F("Altitude: "));
    Serial.print(bmp180Alt, 1);
    Serial.print(F(" [m]"));
    Serial.print(F("\tpressure: "));
    Serial.print(bmp180Pressure, 1);
    Serial.print(F(" [hPa]"));
    Serial.print(F("\tTemperature: "));
    Serial.print(bmp180TempC, 1);
    Serial.println(F(" [°C]"));
  } else if (menuOption == '2') {

    float dhtHumidity = dht.readHumidity();

    float dhtTempC = dht.readTempC();
    Serial.print(F("Humidity: "));
    Serial.print(dhtHumidity);
    Serial.print(F(" [%]\t"));
    Serial.print(F("Temp: "));
    Serial.print(dhtTempC);
    Serial.println(F(" [C]"));
  } else if (menuOption == '3') {
    while (ss.available() > 0)
      if (gps.encode(ss.read())) {
        if (gps.location.isValid()) {
          latitude = gps.location.lat();
          lat_str = String(latitude, 6);
          longitude = gps.location.lng();
          lng_str = String(longitude, 6);
        }
        if (gps.date.isValid()) {
          date_str = "";
          date = gps.date.day();
          month = gps.date.month();
          year = gps.date.year();
          if (date < 10)
            date_str = '0';
          date_str += String(date);
          date_str += " / ";

          if (month < 10)
            date_str += '0';
          date_str += String(month);
          date_str += " / ";
          if (year < 10)
            date_str += '0';
          date_str += String(year);
        }
        if (gps.time.isValid()) {
          time_str = "";
          hour = gps.time.hour();
          minute = gps.time.minute();
          second = gps.time.second();
          minute = (minute + 30);
          if (minute > 59) {
            minute = minute - 60;
            hour = hour + 1;
          }
          hour = (hour + 5);
          if (hour > 23)
            hour = hour - 24;
          if (hour >= 12)
            pm = 1;
          else
            pm = 0;
          hour = hour % 12;
          if (hour < 10)
            time_str = '0';
          time_str += String(hour);
          time_str += " : ";
          if (minute < 10)
            time_str += '0';
          time_str += String(minute);
          time_str += " : ";
          if (second < 10)
            time_str += '0';
          time_str += String(second);
          if (pm == 1)
            time_str += " PM ";
          else
            time_str += " AM ";
        }
      }
    Serial.print(lat_str);
    Serial.print("\t");
    Serial.print(lng_str);
    Serial.print("\t");
  } else if (menuOption == '4') {

    mpu6050.getMotion6(&mpu6050Ax, &mpu6050Ay, &mpu6050Az, &mpu6050Gx, &mpu6050Gy, &mpu6050Gz);
    double mpu6050Temp = ((double)mpu6050.getTemperature() + 12412.0) / 340.0;
    Serial.print("a/g-\t");
    Serial.print(mpu6050Ax);
    Serial.print("\t");
    Serial.print(mpu6050Ay);
    Serial.print("\t");
    Serial.print(mpu6050Az);
    Serial.print("\t");
    Serial.print(mpu6050Gx);
    Serial.print("\t");
    Serial.print(mpu6050Gy);
    Serial.print("\t");
    Serial.print(mpu6050Gz);
    Serial.print("\t");
    Serial.print(F("Temp- "));
    Serial.println(mpu6050Temp);
    delay(100);
  }

  if (millis() - time0 > timeout) {
    menuOption = menu();
  }

  double bmp180Pressure = bmp180.getPressure();
  float dhtHumidity = dht.readHumidity();
  float dhtTempC = dht.readTempC();
  int16_t mpu6050Ax, mpu6050Ay, mpu6050Az;
  int16_t mpu6050Gx, mpu6050Gy, mpu6050Gz;
  float latitude, longitude;

  WiFiClient client;
  if (!client.connect(apiserver.c_str(), 80)) {
    Serial.println("Connection failed");
    return;
  }

  StaticJsonDocument<256> doc;
  doc["id"] = "3A434VUH33";
  doc["acceleration"] = { 0.14, -0.72, 7.32 };
  doc["humidity"] = 74.84;
  doc["location"] = { 6.9178, 79.8758 };
  doc["pressure"] = 86513;
  doc["rotation"] = { 0.25, -0.28, 1.83 };
  doc["temperature"] = 23.84;

  String data;
  serializeJson(doc, data);

  client.println("POST /create HTTP/1.1");
  client.println("Host: " + apiserver);
  client.println("Content-Type: application/json");
  client.print("Content-Length: ");
  client.println(data.length());
  client.println();
  client.println(data);

  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("Response:");
      break;
    }
  }
  while (client.available()) {
    String line = client.readStringUntil('\n');
    Serial.println(line);
  }
  Serial.println("POST request sent");
  client.stop();

  delay(10000);
}

char menu() {

  Serial.println(F("\nWhich component would you like to test?"));
  Serial.println(F("(1) BMP180 - Barometric Pressure, Temperature, Altitude Sensor"));
  Serial.println(F("(2) DHT22/11 Humidity and Temperature Sensor"));
  Serial.println(F("(3) Ublox NEO-6M GPS Module"));
  Serial.println(F("(4) SparkFun MPU-6050 - Accelerometer and Gyro"));
  Serial.println(F("(menu) send anything else or press on board reset button\n"));
  while (!Serial.available())
    ;

  while (Serial.available()) {
    char c = Serial.read();
    if (isAlphaNumeric(c)) {

      if (c == '1')
        Serial.println(F("Now Testing BMP180 - Barometric Pressure, Temperature, Altitude Sensor"));
      else if (c == '2')
        Serial.println(F("Now Testing DHT22/11 Humidity and Temperature Sensor"));
      else if (c == '3')
        Serial.println(F("Now Testing Ublox NEO-6M GPS Module"));
      else if (c == '4')
        Serial.println(F("Now Testing SparkFun MPU-6050 - Accelerometer and Gyro"));
      else {
        Serial.println(F("illegal input!"));
        return 0;
      }
      time0 = millis();
      return c;
    }
  }
}