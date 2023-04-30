import 'package:alarm/model/alarm_settings.dart';

//List can be accessed by any other file with this imported
List<AlarmSettings> alarms = [];

//The point of this is so we can grab the alarm list from any of the other files
//There is probably a better way to do this but it is 11:59 and I'm tired
void alarmStart() {
//This is a test value for an alarm
  final alarmSettings = AlarmSettings(
    id: 1,
    //YY,MM,DD,HH,Min
    dateTime: DateTime(2023, 4, 30, 0, 50),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: false,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: 'ALARM 1!',
    notificationBody: 'IT IS WORKING',
    enableNotificationOnKill: true,
  );
//This is a test value for an alarm
  final alarmSettings2 = AlarmSettings(
    id: 2,
    //YY,MM,DD,HH,Min
    dateTime: DateTime(2023, 4, 30, 0, 51),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: false,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: 'THIS ALARM IS ALARM 2!',
    notificationBody: 'IT IS WORKING',
    enableNotificationOnKill: true,
  );

  alarms.add(alarmSettings);
  alarms.add(alarmSettings2);
}