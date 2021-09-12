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
          id: device['id'],
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

  void updateStatus(Device device) {
    device.status = !device.status;
    notifyListeners();
  }

  void updateThermometerValue(Device device, double value) {
    device.status = value;
    notifyListeners();
  }

  void saveNewThermometerValue(Device device) async {
    var url = Uri.parse('$smartHomeApi/${device.id}');
    await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'targetTemp': device.status.toString()}));
  }
}
