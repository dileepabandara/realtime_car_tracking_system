import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String carId;
  final List acceleration;
  final Timestamp lastUpdate;
  final double humidity;
  final GeoPoint location;
  final double pressure;
  final List rotation;
  final double temperature;

  CarModel({
    required this.carId,
    required this.acceleration,
    required this.lastUpdate,
    required this.humidity,
    required this.location,
    required this.pressure,
    required this.rotation,
    required this.temperature,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carId: json['carId'],
      acceleration: json['acceleration'],
      humidity: json['humidity'],
      lastUpdate: json['lastUpdate'],
      location: json['location'],
      pressure: json['pressure'],
      rotation: json['rotation'],
      temperature: json['temperature'],
    );
  }

  factory CarModel.fromDocument(
      DocumentSnapshot documentSnapshot, String carId) {
    return CarModel(
      carId: carId,
      acceleration: documentSnapshot['acceleration'],
      humidity: documentSnapshot['humidity'],
      lastUpdate: documentSnapshot['lastUpdate'],
      location: documentSnapshot['location'],
      pressure: documentSnapshot['pressure'],
      rotation: documentSnapshot['rotation'],
      temperature: documentSnapshot['temperature'],
    );
  }
}
