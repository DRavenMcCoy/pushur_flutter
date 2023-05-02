import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'dart:async';
import 'Alarm.dart';
import 'HomePage.dart';
import 'Settings.dart';

//Has to be async for Alarm.init(); to work
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();

  runApp(const MaterialApp(home: MyHomePage()));
}
