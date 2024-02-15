import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:signee/data/adapters.dart';
import 'package:signee/screens/loading.dart';

void main() async {
  await Hive.initFlutter();
  // register the adapter
  Hive.registerAdapter(Uint8ListAdapter());
  // ignore: unused_local_variable
  var box = Hive.openBox('signee_db');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}
