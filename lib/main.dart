import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'dart:async';
import 'Alarm.dart';
import 'HomePage.dart';
import 'Settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();

  //This is a test value for an alarm
  final alarmSettings = AlarmSettings(
    id: 1,
                     //YY,MM,DD,HH,Min
    dateTime: DateTime(2023,4,29,17,25,0,0,0),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: false,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: 'ALARM',
    notificationBody: 'IT IS WORKING',
    enableNotificationOnKill: true,
  );
  //This sets the alarm
  await Alarm.set(alarmSettings: alarmSettings);

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'My Home Page'),
        '/second': (context) => const AddAlarm(title: 'Alarm Menu'),
        '/third': (context) => const SettingsMenu(title: 'Settings Menu'),
      },
    );
  }
}