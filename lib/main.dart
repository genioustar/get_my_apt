import 'package:flutter/material.dart';
import 'package:get_my_apt/data/services/apartment_storage_service.dart';
import 'package:get_my_apt/screens/detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApartmentStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ApartmentDetailScreen(),
    );
  }
}
