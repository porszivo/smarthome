import 'package:flutter/material.dart';

class Device {
  Device({
    required this.id,
    required this.name,
    required this.deviceType,
    this.status,
    required this.beschreibung,
    this.icon,
  });
  String id;
  String name;
  dynamic status;
  String beschreibung;
  DeviceType deviceType;
  IconData? icon;
}

enum DeviceType { thermometer, switchControl, statusDevice }
