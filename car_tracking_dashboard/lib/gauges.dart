import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Gauges {
  Widget pressure(double pressure) {
    return Column(
      children: [
        Text(
          "Pressure: $pressure Pa",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
        SizedBox(
          height: 200,
          child: SfRadialGauge(
            // title: const GaugeTitle(
            //   text: 'Pressure',
            //   textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            // ),
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 150000,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0, endValue: 50000, color: Colors.green),
                  GaugeRange(
                      startValue: 50000,
                      endValue: 100000,
                      color: Colors.orange),
                  GaugeRange(
                      startValue: 100000, endValue: 150000, color: Colors.red),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: pressure,
                    enableAnimation: true,
                    needleEndWidth: 0.8,
                  )
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      pressure.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget temperature(double temperature) {
    return Column(
      children: [
        Text(
          "Temperature: $temperature ℃",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 200,
          child: SfLinearGauge(
            orientation: LinearGaugeOrientation.vertical,
            barPointers: [
              LinearBarPointer(
                enableAnimation: true,
                value: temperature,
                // Changed the thickness to make the curve visible
                thickness: 10,
                //Updated the edge style as curve at end position
                edgeStyle: LinearEdgeStyle.endCurve,
                color: Colors.yellow,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget humidity(double humidity) {
    return Column(
      children: [
        Text(
          "Humidity: $humidity %",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 200,
          child: SfLinearGauge(
            orientation: LinearGaugeOrientation.vertical,
            barPointers: [
              LinearBarPointer(
                enableAnimation: true,
                value: humidity,
                // Changed the thickness to make the curve visible
                thickness: 10,
                //Updated the edge style as curve at end position
                edgeStyle: LinearEdgeStyle.endCurve,
                color: Colors.teal,
              )
            ],
          ),
        ),
      ],
    );
  }
}
