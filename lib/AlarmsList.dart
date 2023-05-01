import 'package:alarm/model/alarm_settings.dart';

//List can be accessed by any other file with this imported
List<AlarmSettings> alarms = [];
//This is used to dynamically name the alarm settings
final Map alarmsDynamic = {};

//The point of this is so we can grab the alarm list from any of the other files
//There is probably a better way to do this but it is 11:59 and I'm tired
void alarmStart() {
  //In case this function is called twice
  if(alarms.isEmpty) {
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
  for(int i = 0; i < alarms.length; i++){
    alarmsDynamic['alarmSettings$i'] = alarms[i];
  }
}

void createAlarmAddList(int i, DateTime dt, String audioPath, bool loop, bool vib, double fade, String notifTit, String notifBod){
  //Creates a new alarm based upon the specifications
  final alarmSettings = AlarmSettings(
    id: i,
    dateTime: dt,
    assetAudioPath: audioPath,
    loopAudio: loop,
    vibrate: vib,
    fadeDuration: fade,
    notificationTitle: notifTit,
    notificationBody: notifBod,
    enableNotificationOnKill: true,
  );
  //grabs the current length of the alarms list + 1
  int x = alarms.length + 1;
  //Dynamically names it and places it in the map
  alarmsDynamic['alarmSettings$x'] = alarmSettings;
  //Adds the dynamically named alarm to the list
  alarms.add(alarmsDynamic['alarmSettings$x']);
}