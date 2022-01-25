// import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tflite Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.lightGreenAccent,
        primaryColor: Colors.greenAccent ,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _load = true;
  bool _gallery = true;

  File _imgToPredict;
  List _output;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "Pneumonia Detector",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  // Colors.red,
                  // Colors.yellow,
                  Colors.black,

                  Colors.black,

                  Colors.deepPurpleAccent,
                  Colors.black,
                  Colors.black,

                  // Colors.blue,
                ])),
            child: Container(
              // height: 750,
              decoration: BoxDecoration(
                  // image: ,
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 20.0,
                    ),
                  ]),
              // color: Colors.black.withOpacity(0.3),

              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: (_load == true)
                          ? Container(
                              decoration: BoxDecoration(
                                  // color: Colors.white.withOpacity(0.7),
                                  ),
                              height: 400,
                              width: 400,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  // color: Colors.white.withOpacity(0.7),
                                  ),
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      height: 400,
                                      width: 300,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: Image.file(
                                          _imgToPredict,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  Divider(
                                    height: 50,
                                    thickness: 10,
                                  ),
                                  (_output != null)
                                      ? Text("Result : ${_output[0]['label']}",
                                          style: TextStyle(
                                              color: Colors.purple[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))
                                      : Container(
                                          height: 30,
                                        ),
                                  Divider(
                                    height: 50,
                                    thickness: 10,
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.7),
                        ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            setState(() {
                              pickImageCamera();
                              // _gallery = false;
                              // uploadImage();
                            })
                          },
                          child: Container(
                            width: 200,
                            height: 60,
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    // begin: Alignment.bottomCenter,
                                    // end: Alignment.topCenter,
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      // Colors.red,
                                      // Colors.yellow,
                                      Colors.black,
                                      Colors.black,
                                      // Colors.grey[800],
                                      // Colors.purpleAccent,
                                      // Colors.purpleAccent
                                    ]),
                                // color: Colors.lightGreenAccent,
                                borderRadius: BorderRadius.circular(120),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10.0,
                                  ),
                                ]),
                            child: Text(
                              "Camera",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () => {
                            setState(() {
                              pickImageGallery();
                            })
                          },
                          child: Container(
                            width: 200,
                            height: 60,
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                ),
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // end: Alignment.bottomLeft,
                                  // begin: Alignment.topRight,
                                  colors: [
                                    // Colors.red,
                                    // Colors.yellow,
                                    Colors.black,
                                    Colors.black,

                                    // Colors.purpleAccent
                                  ]),
                              // color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(120),
                            ),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // main function which can give the output of the model by providing the input
  // you can refer to tensorflow library aswell to see the exact functioning of runModelOnImage
  classifyImage(File img) async {
    var output = await Tflite.runModelOnImage(
      path: img.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 150,
      imageStd: 150,
    );
    setState(() {
      _output = output;
      _load = false;
    });
  }

// the modelwill be loaded from tflite
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/modelCNN.tflite', labels: 'assets/labels.txt');
  }

  // image from camera
  Future pickImageCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }

    setState(() {
      _imgToPredict = File(image.path);
    });

    classifyImage(_imgToPredict);
  }

  // image from gallery
  Future pickImageGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }

    setState(() {
      _imgToPredict = File(image.path);
    });

    classifyImage(_imgToPredict);
  }

  // for popup we can use this function
  Future uploadImage() async {
    final _picker = ImagePicker();
    PickedFile image;
    if (PermissionStatus.granted != null) {
      image = (_gallery)
          ? (_picker.getImage(source: ImageSource.gallery))
          : (await _picker.getImage(source: ImageSource.camera));
      var file = File(image.path);
      setState(() {
        _imgToPredict = File(image.path);
      });
      classifyImage(_imgToPredict);
    }
  }
}
