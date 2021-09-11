import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/device_tile.dart';
import 'package:smarthome/data/device_list.dart';
import 'package:smarthome/models/device.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    final deviceList = Provider.of<DeviceList>(context, listen: false);
    deviceList.loadDeviceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smarthome'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Zuhause'),
                  trailing: Text('Anwenden')),
            ),
            Expanded(
                child: _buildGrid(Provider.of<DeviceList>(context).deviceList)),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<Device> deviceList) => GridView.count(
        padding: const EdgeInsets.all(15),
        mainAxisSpacing: 35,
        crossAxisSpacing: 35,
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        children: List.generate(
          deviceList.length,
          (index) => DeviceTile(
            device: deviceList[index],
          ),
        ),
      );
}
