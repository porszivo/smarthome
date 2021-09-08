import 'package:flutter/material.dart';

class Device {
  Device({
    required this.name,
    required this.deviceType,
    this.status,
    required this.beschreibung,
    this.icon,
  });
  String name;
  dynamic status;
  String beschreibung;
  DeviceType deviceType;
  IconData? icon;
}

enum DeviceType { thermometer, switchControl, statusDevice }
