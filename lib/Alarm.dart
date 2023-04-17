import 'package:flutter/material.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}
enum NotificationType {alarm, notification}

class _AddAlarmState extends State<AddAlarm> {
  NotificationType? _notificationType = NotificationType.alarm;
  bool isRepeatable = false;
  bool isSunday = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> dayPicker() async {
    TimeOfDay?  pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
  }






  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

             Text(
              'Type',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListTile(
                title: const Text("Alarm"),
              leading: Radio<NotificationType>(
                value: NotificationType.alarm,
                groupValue: _notificationType,
                onChanged: (NotificationType? value) {
                  setState(() {
                    _notificationType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Notification"),
              leading: Radio<NotificationType>(
                value: NotificationType.notification,
                groupValue: _notificationType,
                onChanged: (NotificationType? value) {
                  setState(() {
                    _notificationType = value;
                  });
                },
              ),
            ),
        CheckboxListTile(
          title: const Text("Repeatable?"),
          checkColor: Colors.white,
          value: isRepeatable,
          onChanged: (bool? value) {
            setState(() {
              isRepeatable = value!;
            });
          },
         ),
            ElevatedButton(
                onPressed: dayPicker , child: const Text("Pick Time")),
            Text("$selectedTime"),
          ],

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: <Widget>[
            FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              tooltip: 'Cancel',
              label: const Text("Cancel"),

            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              tooltip: 'Save',
              label: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}