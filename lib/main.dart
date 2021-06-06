import 'dart:async';

import 'package:camera/camera.dart';
import 'package:envision_test/ocr/presenntation/bloc/ocr_bloc.dart';
import 'package:envision_test/ocr/presenntation/page/splash.dart';
import 'package:envision_test/util/ocr_bloc/ocr_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'ocr/presenntation/page/landing_page.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    runApp(MyApp(
      camera: firstCamera,
    ));
  }, (error, stackTrace) async {
    ///Log any error to the console
    ///Send error to sentry or Crashlytics
  });
}

class MyApp extends StatefulWidget {

  final CameraDescription camera;

  static final navigator = GlobalKey<NavigatorState>();

  const MyApp({Key key, this.camera}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CameraController _controller;

  OCRBloc _ocrBloc;
  GetOCRBloc _getOcrBloc;


  @override
  void initState() {
    super.initState();
    _ocrBloc = OCRBloc(OCRInitial());
    _getOcrBloc = GetOCRBloc(GetOCRInitial());
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _ocrBloc.close();
    _getOcrBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigator,
      title: "Envision Test",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6200EE),
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<OCRBloc>(
            create: (context) => _ocrBloc,
          ),
          BlocProvider<GetOCRBloc>(
            create: (context) => _getOcrBloc,
          ),
        ],
        child: FutureBuilder(
            // Replace the 3 second delay with your initialization code:
            future: Future.delayed(Duration(seconds: 4)),
            //_initializeControllerFuture
            builder: (context, AsyncSnapshot snapshot) {
              // Show splash screen while waiting for app resources to load:
              if (snapshot.connectionState == ConnectionState.waiting) {
                return WelcomePage();
              } else {
                // Loading is done, return the app:
                return MyTabbedPage(
                  key: Key("tab"),
                );
              }
            },
          ),
      ),
    );
  }
}
