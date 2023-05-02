import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:pushur_flutter/Alarm.dart';

import 'Settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Subscription for listening, and alarms is so we can see how many alarms we have and place them
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  //self-explanatory
  @override
  void initState(){
    super.initState();
    loadAlarm();
    //This will do a callback when an alarm rings, may add later
    //subscription ??= Alarm.ringStream.stream.listen((alarmSettings) =>  { })
  }

  //loads alarms into list
  void loadAlarm(){
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  //Disposes of subscription
  @override
  void dispose(){
    subscription?.cancel();
    super.dispose();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        /*
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

         */
        builder: (context) {
          return AddAlarm(alarmSettings: settings);
          //return FractionallySizedBox(
           // heightFactor: 0.6,
            //child: AddAlarm(alarmSettings: settings),
          //);
        });

    if (res != null && res == true) loadAlarm();
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //Some of this is inspired by the example provided in the Alarm library
    return Scaffold(
        appBar: AppBar(title: const Text('Alarm app')),
        body: SafeArea(
            child: alarms.isNotEmpty
                ? ListView.separated(
                itemCount: alarms.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index){
                  //This will be how every container for each alarm is created
                  return Container(
                    key: Key(alarms[index].id.toString()),
                    height: 200,
                    margin: const EdgeInsets.all(2),
                    color: Colors.blue[200],
                    child: MaterialButton(
                      child: Text('Alarm Time: ${alarms[index].dateTime.hour}:'
                          '${alarms[index].dateTime.minute} \nAlarm Name: ${alarms[index].notificationTitle}',
                          style: const TextStyle(fontSize: 24),
                      ),
                        onPressed: () => navigateToAlarmScreen(alarms[index])
                    ),
                  );
                },
            )
                : Center(
              child: Text(
                "No Alarms",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
        ),
      //These are for the floating action buttons that allow you to add alarms or change settings
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SettingsMenu(),
                    ));
              },
              tooltip: 'NextScreen',
              child: const Icon(Icons.settings),
            ),
            FloatingActionButton(
              onPressed: () => navigateToAlarmScreen(null),
              tooltip: 'NextScreen',
              child: const Icon(Icons.add),
            )

          ]
        )
      )
    );

  }
}