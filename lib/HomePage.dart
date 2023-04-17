import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //THESE ARE TEST VALUES, SUBJECT TO CHANGE
    List<int> alarms = [1,2,3,4,5,6,1,2,3,4,5,6,2,3,4,5,6,1,2,3,4,5,6];
    List<int> timeAlarm = [1800,2359,0800,0600,1200,0000,1800,2359,0800,0600,1200,0000,2359,0800,0600,1200,0000,1800,2359,0800,0600,1200,0000,2359,0800,0600,1200,0000,1800,2359,0800,0600,1200,0000];
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      /*
      body: new ListView.builder(
          itemBuilder: (BuildContext context, int index){
            return new Card(
              child: const ListTile(
                leading: const Icon(Icons.alarm),
                title: const Text('3:00PM'),
                subtitle: const Text('Go get food'),
              ),
            );
          },
      ),
      */
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              'Push button for next screen',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
           //Evil process to display alarm list
            Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  //Gets the length of the alarms list so it can iterate through for the alarm list
                  //itemCount: alarms.length,
                  //itemBuilder: (BuildContext context, int index) {

                  //generates list of list tiles for the length of the alarms list
                children: List.generate(
                alarms.length,
                 (index) => ListTile(
                   //displays the alarm number and time on it (in 24hr format)
                   title: Text('Alarm: ${alarms[index]} Alarm Time: ${timeAlarm[index]}'),
                   //handles the tap events for alarms currently tells you what you clicked for testing purposes
                   onTap: (){
                     print('Alarm: ${alarms[index]} Alarm Time: ${timeAlarm[index]}');
                   },
                   //handles the on long press events for alarms
                   onLongPress: (){

                   },
                 ),
                 /*return Container(

                    //Hyperinflated height for testing purposes (make smaller later)
                    height: 400,
                    margin: EdgeInsets.all(2),
                    color: Colors.blue[400],
                    child: Center(
                      child: Text('Alarm number: ${alarms[index]} Alarm Time: (${timeAlarm[index]})',
                        style: TextStyle(fontSize: 16),
                    )
                    ),
                 );
                   */
                ),
             )
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              tooltip: 'NextScreen',
              child: const Icon(Icons.settings),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              tooltip: 'NextScreen',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );

  }
}