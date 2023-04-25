import 'package:car_tracking_dashboard/car_model.dart';
import 'package:car_tracking_dashboard/car_page.dart';
import 'package:car_tracking_dashboard/theme/data_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: carList(),
    );
  }

  Widget appBar({required int totalCars}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          DataValues.appName,
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        const Text(
          DataValues.appDescription,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          "Total Cars: $totalCars",
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget map({required List<CarModel> cars}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      height: 540.0,
      width: 600.0,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(
              cars.first.location.latitude, cars.first.location.longitude),
          zoom: 14.0,
          maxZoom: 18.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          ),
          MarkerLayerOptions(
            markers: cars
                .map((car) => Marker(
                      point:
                          LatLng(car.location.latitude, car.location.longitude),
                      builder: (ctx) => Stack(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                              "assets/images/car.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Text(
                              car.carId.substring(car.carId.length - 2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget carList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cars').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }

        if (!snapshot.hasData) {
          return const Text(
            "Data Unavailable",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          );
        } else {
          final carsDocs = snapshot.data?.docs;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  appBar(totalCars: carsDocs!.length),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      map(
                        cars: carsDocs
                            .map((e) => CarModel.fromDocument(e, e.id))
                            .toList(),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: carsDocs.length,
                          itemBuilder: (context, index) {
                            final carsDoc = carsDocs[index];
                            final carsID = carsDoc.id;
                            return Card(
                              color: Colors.grey[900],
                              child: InkWell(
                                onTap: () {
                                  debugPrint(
                                      'Tapped card with ID $carsID || ${carsDoc.id} || $index}');
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CarPage(
                                      carDocumentID: index,
                                    );
                                  }));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/f1.png",
                                        fit: BoxFit.contain,
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        width: 80.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Car ID",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              carsID,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        width: 80.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Pressure",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              carsDoc['pressure'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        width: 100.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Temperature",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              carsDoc['temperature'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        width: 100.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Location",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${carsDoc['location'].latitude}, ${carsDoc['location'].longitude}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Container(
                                        width: 150.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Acceleration",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              "${carsDoc['acceleration'][0].toString()}, ${carsDoc['acceleration'][1].toString()}, ${carsDoc['acceleration'][2].toString()}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
