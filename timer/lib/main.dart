import 'package:flutter/material.dart';
import 'package:timer/setting.dart';
import 'package:timer/timermodel.dart';
import 'package:timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timer.dart';

void main() => runApp(MyApp());
final double defaultPadding = 5.0;
final CountDownTimer timer = CountDownTimer();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timer.startWork();
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  const TimerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Work Timer',
          ),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if (s == 'Settings') {
                  goToSettings(context);
                }
              },
            )
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;

          return Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff009688),
                        text: "Work",
                        size: 15,
                        onPressed: () => timer.startWork())),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff607D8B),
                        text: "Short Break",
                        size: 10,
                        onPressed: () => timer.startBreak(true))),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff455A64),
                        text: "Long Break",
                        size: 10,
                        onPressed: () => timer.startBreak(false))),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder(
                    initialData: '00:00',
                    stream: timer.stream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      TimerModel timer = (snapshot.data == '00:00')
                          ? TimerModel(time: '00:00', percent: 1)
                          : snapshot.data;
                      return OrientationBuilder(builder: (context, orientation) {
                        if (MediaQuery.of(context).orientation == Orientation.portrait){
                          return Expanded(
                            child: CircularPercentIndicator(
                          radius: availableWidth / 2,
                          lineWidth: 10.0,
                          percent: timer.percent,
                          center: Text(timer.time,
                              style: Theme.of(context).textTheme.headline4),
                          progressColor: Color(0xff009688),
                        ));
                        } else{
                          return Expanded(
                            child: CircularPercentIndicator(
                          radius: availableHeight / 3.2,
                          lineWidth: 10.0,
                          percent: timer.percent,
                          center: Text(timer.time,
                              style: Theme.of(context).textTheme.headline4),
                          progressColor: Color(0xff009688),
                            ));
                        }
                      
                      });
                    })),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff212121),
                        text: 'Stop',
                        size: 10,
                        onPressed: () => timer.stopTimer())),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff009688),
                        text: 'Restart',
                        size: 10,
                        onPressed: () => timer.startTimer())),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
              ],
            )
          ]);
        }));
  }
}

void emptyMethod() {}
void goToSettings(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SettingsScreen()));
}
