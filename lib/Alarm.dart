import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AddAlarm extends StatefulWidget {
  //  const AddAlarm({super.key, required this.title});
  final AlarmSettings? alarmSettings;
  const AddAlarm({Key? key, this.alarmSettings})
      : super(key: key);


  //final String title;

  @override
  State<AddAlarm> createState() => _ExampleAlarmEditScreenState();
}



class _ExampleAlarmEditScreenState extends State<AddAlarm> {
  final myController = TextEditingController();
  late bool creating;
  late TimeOfDay selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool showNotification;
  late String assetAudio;
  late String alarmName;



  @override
  void initState() {

    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/mozart.mp3';
      alarmName = "Example Alarm";
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
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
    setState(() {
      alarmName = myController.text;
    });
  }


  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectedTime,
      context: context,
    );
    if (res != null) setState(() => selectedTime = res);
  }

  AlarmSettings buildAlarmSettings() {

    final now = DateTime.now();

    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationTitle: showNotification ? alarmName : null,
      notificationBody: showNotification ? 'Your alarm ($id) is ringing' : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    Alarm.set(alarmSettings: buildAlarmSettings())
        .then((_) => Navigator.pop(context, true));
  }

  Future<void> deleteAlarm() async {
    Alarm.stop(widget.alarmSettings!.id)
        .then((_) => Navigator.pop(context, true));
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
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
            controller: myController,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter an alarm name',
            ),
            onChanged: _setAlarmName(),
          ),

          RawMaterialButton(
            onPressed: pickTime,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                selectedTime.format(context),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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