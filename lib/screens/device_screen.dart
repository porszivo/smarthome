import 'package:flutter/material.dart';
import 'package:smarthome/components/thermometer_detail.dart';
import 'package:smarthome/models/device.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key}) : super(key: key);

  static const routeName = '/device';

  Widget getDetailWidget(device) {
    return ThermometerDetail(device: device);
  }

  @override
  Widget build(BuildContext context) {
    final device = ModalRoute.of(context)!.settings.arguments as Device;

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
      ),
      body: getDetailWidget(device),
    );
  }
}
