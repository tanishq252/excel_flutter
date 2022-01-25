import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLutter excel demo',
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
  late File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            ElevatedButton(
              child: Text("Fetch Data"),
              onPressed: () => openFile(
                url:
                    'https://firebasestorage.googleapis.com/v0/b/official-app-7898d.appspot.com/o/Blockchain%20Workshop%20(Responses).xlsx?alt=media&token=31d13302-e89e-4772-9fde-9bc387a1bc71',
                fileName: 'sdp.xlsx',
              ),
            ),
            for (int i = 1; i < ll.length; i++) ll[i],
          ],
        ) 
        );
  }

  openFile({required String url, String? fileName}) async {
    // initializinf the file
    final File? file = await downloadFile(url, fileName!);
    if (file == null) {
      return;
    }

    // below function opens the file just make sure filename is proper along with extension after that
    OpenFile.open(file.path);

    // further functioning is perfoemed in order to write the fetched data in our mobile storage and read the data of "Email Address" column which can be further modified to create users in firebase authentication
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    int counter = 0;
    int emailIndex=0;
    for (var table in excel.tables.keys) {
      print(
          "---------------------------------------------------------------------------");
      print("$table");

      print(
          "---------------------------------------------------------------------------");

      for(var x in excel.tables[table]!.rows[0]){
        if (x.toString() == "Email Address") {
            emailIndex = counter;
            break;
          }
          counter++;
      }

      for (var row in excel.tables[table]!.rows) {
        print("$row");
        String local = row[emailIndex].toString();
        if(local!=null && local!="Email Address"){
          ll.add(Text("$local"));
        }
      }
    }
  }

  // this function will help user to store file locally by converting the file present in firebase storage or any other online file in bytes using Dio package and simple return the new file
  Future<File?> downloadFile(String url, String name) async {
    final storage = await getApplicationDocumentsDirectory();
    final File file = File('${storage.path}/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }
}
