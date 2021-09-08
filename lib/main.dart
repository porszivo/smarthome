import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/data/device_list.dart';
import 'package:smarthome/screens/dashboard_screen.dart';
import 'package:smarthome/screens/device_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceList(),
      child: Consumer<DeviceList>(
        builder: (context, provider, child) => MaterialApp(
          routes: {
            '/': (context) => const DashboardScreen(),
            DeviceScreen.routeName: (context) => const DeviceScreen(),
          },
          theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF30A3DC),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF30A3DC),
                shadowColor: Color(0xFF30A3DC),
              )),
          initialRoute: '/',
        ),
      ),
    );
  }
}
