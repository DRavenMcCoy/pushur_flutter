import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:pushur_flutter/_alarm.dart';


//Much of this is made with the consideration of how the alarm library works, other iterations have been tried prior however other iterations ran into fatal errors (week of progress lost)
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

  //Does exactly what the function is named after
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
                  //The next few lines solve an issue with integers, as a leading "0" is not mathematically significant they are removed when converting to string
                  //These work by finding if the int is lower than 2, if so then we add a leading 0
                  String minutes = alarms[index].dateTime.minute.toString();
                  if(minutes.length < 2) {
                    String temp = '0$minutes';
                    minutes = temp;
                  }
                  print('Full alarm in MM/DD/YY : HH/MM format ${alarms[index].dateTime.month}/${alarms[index].dateTime.day}/${alarms[index].dateTime.year} : ${alarms[index].dateTime.hour}/${alarms[index].dateTime.minute}');
                  //This will be how every container for each alarm is created
                  //Decides if the alarm needs to be in AM or PM based on if it is after 12
                  if(alarms[index].dateTime.hour > 12) {
                  //makes the container holding the alarm information, along with all relevant information. All other 'return Container' instances in this script do similarly as such I will not comment on them
                    return Container(
                      key: Key(alarms[index].id.toString()),
                      height: 200,
                      margin: const EdgeInsets.all(2),
                      color: Colors.blue[200],
                      child: MaterialButton(
                          child: Text(
                            'Alarm Date: ${alarms[index].dateTime.month} / ${alarms[index].dateTime.day} / ${alarms[index].dateTime.year}\n'
                            'Alarm Time: ${alarms[index].dateTime.hour - 12}:'
                                '$minutes PM \nAlarm Name: ${alarms[index]
                                .notificationTitle}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          onPressed: () => navigateToAlarmScreen(alarms[index])
                      ),
                    );
                  }

                  //If it is equal to 12 no need to subtract
                  else if(alarms[index].dateTime.hour == 12) {
                    return Container(
                      key: Key(alarms[index].id.toString()),
                      height: 200,
                      margin: const EdgeInsets.all(2),
                      color: Colors.blue[200],
                      child: MaterialButton(
                          child: Text(
                            'Alarm Date: ${alarms[index].dateTime.month} / ${alarms[index].dateTime.day} / ${alarms[index].dateTime.year}\n'
                            'Alarm Time: ${alarms[index].dateTime.hour}:'
                                '$minutes PM \nAlarm Name: ${alarms[index]
                                .notificationTitle}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          onPressed: () => navigateToAlarmScreen(alarms[index])
                      ),
                    );
                  }

                  //If it is 12 AM it would appear as 00:00 24-hour clock, so this must be fixed
                  else if(alarms[index].dateTime.hour == 0){

                    return Container(
                      key: Key(alarms[index].id.toString()),
                      height: 200,
                      margin: const EdgeInsets.all(2),
                      color: Colors.blue[200],
                      child: MaterialButton(
                          child: Text(
                            'Alarm Date: ${alarms[index].dateTime.month} / ${alarms[index].dateTime.day} / ${alarms[index].dateTime.year}\n'
                            'Alarm Time: 12:'
                                '$minutes AM \nAlarm Name: ${alarms[index]
                                .notificationTitle}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          onPressed: () => navigateToAlarmScreen(alarms[index])
                      ),
                    );
                  }

                  //If it is not past 12 and it is not 12 then it must be the AMs
                  else{

                    return Container(
                      key: Key(alarms[index].id.toString()),
                      height: 200,
                      margin: const EdgeInsets.all(2),
                      color: Colors.blue[200],
                      child: MaterialButton(
                          child: Text(
                            'Alarm Date: ${alarms[index].dateTime.month} / ${alarms[index].dateTime.day} / ${alarms[index].dateTime.year}\n'
                            'Alarm Time: ${alarms[index].dateTime.hour}:'
                                '$minutes AM \nAlarm Name: ${alarms[index]
                                .notificationTitle}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          onPressed: () => navigateToAlarmScreen(alarms[index])
                      ),
                    );
                  }
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