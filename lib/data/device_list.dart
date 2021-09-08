import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:smarthome/models/device.dart';

class DeviceList extends ChangeNotifier {
  final List<Device> _deviceList = [
    Device(
        name: 'Stehlampe',
        status: false,
        beschreibung: 'Warm 1 (2700 K)',
        deviceType: DeviceType.switchControl,
        icon: Icons.lightbulb),
    Device(
        name: 'Terassenlichter',
        status: true,
        beschreibung: '2 Geräte',
        deviceType: DeviceType.switchControl,
        icon: Icons.electrical_services),
    Device(
        name: 'Kinderzimmer',
        status: 21.5,
        deviceType: DeviceType.thermometer,
        beschreibung: '20.0 °C',
        icon: Icons.gradient),
    Device(
        name: 'Wohnzimmer',
        status: 20.5,
        deviceType: DeviceType.thermometer,
        beschreibung: '19.0 °C',
        icon: Icons.gradient),
    Device(
      name: 'Waschmaschine',
      status: true,
      deviceType: DeviceType.switchControl,
      beschreibung: 'Leistung 12,34 W',
      icon: Icons.power_settings_new_outlined,
    ),
    Device(
        name: 'Dachfenster',
        beschreibung: 'offen',
        deviceType: DeviceType.statusDevice,
        icon: Icons.door_back_door),
  ];

  UnmodifiableListView<Device> get deviceList =>
      UnmodifiableListView(_deviceList);

  void updateDevice(Device device) {
    device.status = !device.status;
    notifyListeners();
  }

  void changeValue(Device device, double value) {
    device.status = value;
    notifyListeners();
  }
}
