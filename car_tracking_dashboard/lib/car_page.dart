import 'package:flutter/material.dart';
import 'package:car_tracking_dashboard/car_model.dart';
import 'package:car_tracking_dashboard/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CarPage extends StatefulWidget {
  final int carDocumentID;

  const CarPage({Key? key, required this.carDocumentID}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  List dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: carDetails(),
    );
  }

  Widget appBar({required CarModel carModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Car Identification: ",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
                Text(
                  carModel.carId,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            dataListCard(carModel: carModel)
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          "Last Update: ${carModel.lastUpdate.toDate()}",
          style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ],
    );
  }

  Widget textHeaderMini({required String title, required String value}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.pink),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget dataListCard({required CarModel carModel}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textHeaderMini(
                title: "Location: ",
                value:
                    "${carModel.location.latitude}, ${carModel.location.longitude}"),
            const SizedBox(
              width: 20.0,
            ),
            textHeaderMini(title: "Pressure: ", value: "${carModel.pressure}"),
          ],
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textHeaderMini(
                title: "Temperature: ", value: "${carModel.temperature}"),
            const SizedBox(
              width: 20.0,
            ),
            textHeaderMini(
                title: "Acceleration: ",
                value:
                    "${carModel.acceleration[0]}, ${carModel.acceleration[1]}, ${carModel.acceleration[2]}"),
          ],
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textHeaderMini(title: "Humidity: ", value: "${carModel.humidity}"),
            const SizedBox(
              width: 20.0,
            ),
            textHeaderMini(
                title: "Rotation: ",
                value:
                    "${carModel.rotation[0]}, ${carModel.rotation[1]}, ${carModel.rotation[2]}"),
          ],
        ),
      ],
    );
  }

  Widget map(CarModel carModel) {
    return Column(
      children: [
        Text(
          "Location: ${carModel.location.latitude}, ${carModel.location.longitude}",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          height: 500.0,
          width: 600.0,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(
                  carModel.location.latitude, carModel.location.longitude),
              zoom: 18.0,
              maxZoom: 18.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(carModel.location.latitude,
                        carModel.location.longitude),
                    // builder: (ctx) => const Icon(
                    //   Icons.location_on,
                    //   color: Colors.pink,
                    //   size: 20,
                    // ),
                    builder: (ctx) => Image.asset(
                      "assets/images/car.png",
                      width: 30.0,
                      height: 30.0,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget carDetails() {
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
          CarModel carModel = CarModel.fromDocument(
              snapshot.data!.docs[widget.carDocumentID],
              snapshot.data!.docs[widget.carDocumentID].id);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  appBar(carModel: carModel),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/f1.png",
                            width: 420.0,
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Gauges().pressure(carModel.pressure),
                              Gauges().temperature(carModel.temperature),
                              const SizedBox(
                                width: 30.0,
                              ),
                              Gauges().humidity(carModel.humidity),
                            ],
                          ),
                        ],
                      ),
                      map(carModel),
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
