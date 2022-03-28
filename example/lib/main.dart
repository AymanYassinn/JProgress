import 'package:flutter/material.dart';
import 'package:jprogress/jprogress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JProgress Example',
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProgressController controller;
  @override
  void initState() {
    controller = ProgressController(
        duration: const Duration(minutes: 3),
        timeFormat: DateFormatN.SecMin,
        tickPeriod: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String b = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView(
            children: [
              progress(),
              button("Timing Progress Circle", "1"),
              button("Timing Progress Linear", "2"),
              button("Timing Only", "3"),
              button("Custom Progress Circle", "4"),
              button("Custom Progress Linear", "5"),
            ],
          )), //Timing Progress
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: () {
          controller.stop();
        },
      ),
    );
  }

  Widget progress() {
    switch (b) {
      case "1":
        return CountdownProgress(
            controller: controller,
            valueColor: Colors.blue,
            backgroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.overline,
            strokeWidth: 3.0,
            progressWidget: ProgressWidget.Indicator,
            progressType: ProgressType.Circular,
            size: 150,
            onTimeout: () => controller.stop(), //Or Do Something
            onUpdate: () {
              setState(() {});
            });
      case "2":
        return CountdownProgress(
            controller: controller,
            valueColor: Colors.red,
            backgroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.overline,
            strokeWidth: 3.0,
            progressWidget: ProgressWidget.Indicator,
            progressType: ProgressType.Linear,
            size: 90,
            onTimeout: () => controller.stop(), //Or Do Something
            onUpdate: () {
              setState(() {});
            });
      case "3":
        return CountdownProgress(
            controller: controller,
            size: 90,
            onTimeout: () => controller.stop(), //Or Do Something
            onUpdate: () {
              setState(() {});
            });
      case "4":
        return CustomProgress(
          valueColor: Colors.red,
          backgroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.overline,
          strokeWidth: 3.0,
          progressType: ProgressType.Circular,
          size: 90,
          title: "Hello",
          value: controller.valuePercent,
        );
      case "5":
        return CustomProgress(
          valueColor: Colors.red,
          backgroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.overline,
          strokeWidth: 3.0,
          size: 90,
          title: "Hello",
          progressType: ProgressType.Linear,
          value: controller.valuePercent,
        );
      default:
        return const SizedBox(
          height: 1,
        );
    }
  }

  Widget button(String title, String p) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          controller.start();
          setState(() => b = p);
        },
        child: Container(
          height: 50,
          width: 80,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
