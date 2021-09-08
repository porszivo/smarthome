import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/data/device_list.dart';
import 'package:smarthome/models/device.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ThermometerDetail extends StatelessWidget {
  ThermometerDetail({Key? key, required this.device}) : super(key: key);

  final Device device;
  final List<charts.Series<TimeValue, int>> seriesList = [
    charts.Series<TimeValue, int>(
      id: 'Temp Value',
      data: [
        TimeValue(1, 22),
        TimeValue(2, 25),
        TimeValue(3, 19),
        TimeValue(4, 19),
        TimeValue(5, 17),
        TimeValue(6, 22),
        TimeValue(7, 25)
      ],
      domainFn: (TimeValue time, _) => time.time,
      measureFn: (TimeValue time, _) => time.value,
      measureLowerBoundFn: (TimeValue time, _) => time.value,
    )
  ];

  MaterialColor getColor(double temp) {
    if (temp < 21) {
      return Colors.blue;
    } else if (temp < 25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceList>(builder: (context, deviceList, child) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Text('Aktuelle Temperatur: ${device.beschreibung}'),
              padding: const EdgeInsets.all(15),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(
                      device.icon,
                      size: 50,
                      color: getColor(device.status),
                    ),
                    Text(device.status.toString()),
                    Slider(
                      activeColor: getColor(device.status),
                      value: device.status,
                      min: 15,
                      max: 27,
                      divisions: (27 - 15) * 2,
                      label: device.status.toString(),
                      onChanged: (val) => deviceList.changeValue(device, val),
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: charts.LineChart(seriesList, animate: true),
              ),
            ),
            Expanded(
              child: Container(
                child: Text('hi'),
              ),
            )
          ],
        ),
      );
    });
  }
}

class TimeValue {
  final int time;
  final int value;

  TimeValue(this.time, this.value);
}
