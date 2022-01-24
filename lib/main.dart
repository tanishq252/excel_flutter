import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Demo in FLutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FLutter excel demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ByteData data;
  var bytes;
  var excel;
  List<Widget> ll = [];

  readExcel() async {
    data = await rootBundle.load("assets/App_trial.xlsx");
    bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        print("$row");
        String local = row[0][0].toString();
        ll.add(Text("$local"));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    readExcel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            for (int i = 1; i < ll.length; i++) ll[i],
            ElevatedButton(child: Text("adsfhj"),
            onPressed:() {},),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
