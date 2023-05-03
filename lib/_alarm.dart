import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AddAlarm extends StatefulWidget {
  //  const AddAlarm({super.key, required this.title});
  final AlarmSettings? alarmSettings;

  const AddAlarm({Key? key, this.alarmSettings}) : super(key: key);

  @override
  State<AddAlarm> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AddAlarm> {
  // Value and important tools declaration
  final nameInputController = TextEditingController();
  late bool creating;
  late DateTime selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool showNotification;
  late String assetAudio;
  late String alarmName;
  late int year = 2023;
  late int month = 5;
  late int day = 4;
  late int hour = 12;
  late int minute = 30;
  late int second = 0;
  late int millisecond = 0;
  late int microsecond = 0;
  late TimeOfDay hourAndMinute = TimeOfDay(hour: hour, minute: minute);

  @override
  void initState() {
    // Setting up default Alarm Settings
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = DateTime(year = dt.year, month = dt.month, day = dt.day, hour = dt.hour, minute = dt.minute, second, millisecond, microsecond);
      hourAndMinute = TimeOfDay(hour: hour, minute: minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/mozart.mp3';
      alarmName = "Example Alarm";
    } else {
      selectedTime = DateTime(
        year = widget.alarmSettings!.dateTime.year,
        month = widget.alarmSettings!.dateTime.month,
        day = widget.alarmSettings!.dateTime.day,
        hour = widget.alarmSettings!.dateTime.hour,
        minute = widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  _setAlarmName() {
    // Method for setting the name of the generated Alarm
    setState(() {
      alarmName = nameInputController.text;
    });
  }

  Future<void> pickTime() async {
    // Method for setting the timing of the generated Alarm
    final res = await showTimePicker(
      initialTime: hourAndMinute,
      context: context,
    );
    if (res != null) setState(() => hourAndMinute = res);
  }

  Future<void> pickDate() async {
    // Method for setting the timing of the generated Alarm
    final res = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(4000,12,31),
      context: context,
    );
    if (res != null) setState(() => selectedTime = res);
  }

  AlarmSettings buildAlarmSettings() {
    // Method for building the parameters of the generated Alarm
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      selectedTime.year,
      selectedTime.month,
      selectedTime.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );

    hourAndMinute = TimeOfDay(hour: hour, minute: minute);

    if (dateTime.isBefore(DateTime.now())) {
      // Adding one because the dates are saved to arrays, which start at 0
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      // Method for finalising the Alarm's settings
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationTitle: showNotification ? alarmName : null,
      notificationBody:
          showNotification ? 'Your alarm ($alarmName) is ringing' : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    // Method for saving the generated Alarm
    Alarm.set(alarmSettings: buildAlarmSettings())
        .then((_) => Navigator.pop(context, true));
  }

  Future<void> deleteAlarm() async {
    // Method for deleting the generated Alarm
    Alarm.stop(widget.alarmSettings!.id)
        .then((_) => Navigator.pop(context, true));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                // Cancel making new alarm and go back button
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.redAccent),
                ),
              ),
              TextButton(
                // Generate current alarm and save button
                onPressed: saveAlarm,
                child: Text(
                  "Save",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
          TextField(
            // Alarm name input field
            controller: nameInputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter an alarm name',
            ),
            onChanged: _setAlarmName(),
          ),


          RawMaterialButton(
            // Time picker button, looks like a digital clock
            onPressed: pickDate,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                selectedTime.month.toString() + "/" + selectedTime.day.toString() + "/" + selectedTime.year.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RawMaterialButton(
              // Time picker button, looks like a digital clock
              onPressed: pickTime,
              fillColor: Colors.grey[200],
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  hourAndMinute.format(context),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
            ),

          ]),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Vibration toggle switch
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Vibration toggle switch
                'Show notification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: showNotification,
                onChanged: (value) => setState(() => showNotification = value),
              ),
            ],
          ),
          if (!creating)
            TextButton(
              // Button for deleting an already generated alarm
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}

/*
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
                Navigator.pop(context, '/');
              },
              tooltip: 'Cancel',
              label: const Text("Cancel"),

            ),
            FloatingActionButton.extended(
              onPressed: () {

                Navigator.pop(context, '/');
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
 */
