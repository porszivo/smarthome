import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/data/device_list.dart';
import 'package:smarthome/models/device.dart';
import 'package:smarthome/screens/device_screen.dart';

class DeviceTile extends StatelessWidget {
  DeviceTile({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (device.deviceType == DeviceType.thermometer)
          Navigator.pushNamed(context, DeviceScreen.routeName,
              arguments: device)
      },
      child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device.name),
              Text(device.beschreibung),
              Expanded(
                child: Align(
                  alignment: const Alignment(0, 1),
                  child: DeviceStatus(device: device),
                ),
              )
            ],
          )),
    );
  }
}

class DeviceStatus extends StatelessWidget {
  DeviceStatus({required this.device});

  final Device device;

  Widget deviceStatus(changeCallback) {
    switch (device.deviceType) {
      case DeviceType.thermometer:
        return Text(
          '${device.status.toString()} °C',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        );
      case DeviceType.switchControl:
        return Switch(
            activeColor: Colors.green,
            value: device.status as bool,
            onChanged: changeCallback);
      default:
        return const Text('');
    }
  }

  Widget deviceIcon() {
    switch (device.deviceType) {
      case DeviceType.thermometer:
        Color color = device.status > 18
            ? (device.status > 21 ? Colors.red : Colors.orange)
            : Colors.blue;
        return Icon(
          device.icon,
          color: color,
          size: 30,
        );
      case DeviceType.switchControl:
        if (device.status as bool) {
          return Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(device.icon, color: Colors.white, size: 30));
        }
        return Container(
            padding: const EdgeInsets.all(5),
            child: Icon(device.icon, color: Colors.grey, size: 30));
      default:
        return Container(
          padding: const EdgeInsets.all(5),
          child: Icon(
            device.icon,
            color: Colors.grey,
            size: 30,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceList>(builder: (context, deviceList, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          deviceIcon(),
          deviceStatus((value) => {deviceList.updateStatus(device)})
        ],
      );
    });
  }
}
