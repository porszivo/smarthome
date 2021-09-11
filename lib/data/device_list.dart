import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/models/device.dart';
import 'package:http/http.dart' as http;

const smartHomeApi = 'http://localhost:3000/devices';

class DeviceList extends ChangeNotifier {
  final List<Device> _deviceList = [];

  UnmodifiableListView<Device> get deviceList =>
      UnmodifiableListView(_deviceList);

  void loadDeviceList() async {
    var url = Uri.parse(smartHomeApi);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var devices = jsonDecode(response.body);
      devices.forEach((device) {
        _deviceList.add(Device(
          name: device['name'],
          deviceType: DeviceType.values.firstWhere((element) =>
              element.toString() == 'DeviceType.' + device['type']),
          beschreibung: device['roomTemp'].toString(),
          status: device['tempTarget'].toDouble(),
          icon: Icons.gradient,
        ));
      });
      notifyListeners();
    }
  }

  void updateDevice(Device device) {
    device.status = !device.status;
    notifyListeners();
  }

  void changeValue(Device device, double value) {
    device.status = value;
    notifyListeners();
  }
}
