import 'dart:io';

import 'package:camera/camera.dart';
import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:envision_test/ocr/presenntation/bloc/ocr_bloc.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatefulWidget {
  CameraPage({controller, Key key}) : super(key: key) {
    tabController = controller;
  }

  @override
  _CameraPageState createState() => _CameraPageState();
}

TabController tabController;

class _CameraPageState extends State<CameraPage>
    with  WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  static CameraDescription cameraDescription;
  List<CameraDescription> _cameras;
  OCRBloc _ocrBloc;
  String ocrText = "";

  void initCamera() async {
    // Obtain a list of the available cameras on the device.
    _cameras = await availableCameras();
    if (cameraDescription == null) cameraDescription = _cameras[0];

    onNewCameraSelected(cameraDescription);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    // If the _controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        // showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e, s) {
      print(e);
      print(s);
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }


  @override
  void didUpdateWidget(CameraPage oldWidget) {
    _ocrBloc.add(InitializeEvent());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    cameraDescription = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _ocrBloc = BlocProvider.of<OCRBloc>(context);
    _ocrBloc.add(InitializeEvent());

    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    /// wait until the controller is initialized before displaying the
    /// camera preview. Use a BlocBuilder to display a loading spinner until the
    /// the controller has finish initializing.

    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    } else
      return BlocListener<OCRBloc, OCRState>(
        bloc: _ocrBloc,
        listener: (context, state) {
          if(state is OCRInitial){

            ///Initialize the camera.
          }
        },
        child: BlocBuilder<OCRBloc, OCRState>(
          bloc: _ocrBloc,
          builder: (context, state) {
            if (state is OCRInitial) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 14, bottom: 13, top: 31),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CameraPreview(_controller),
                          ),
                        )),
                  ),
                  Positioned(
                      bottom: 33,
                      left: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            /// Take the Picture in a try / catch block. If anything goes wrong,
                            /// catch the error.
                            try {
                              /// Ensure that the camera is initialized.
                              await _initializeControllerFuture;

                              /// Attempt to take a picture and then get the location
                              /// where the image file is saved.
                              final image = await _controller.takePicture();
                              final String imagePath = image.path;
                              File imageFile = File(imagePath);

                              /// send image file to server
                              _ocrBloc.add(OcrEvent(imageFile));

                            } catch (e) {
                              /// If an error occurs, log the error to the console.
                              print(e);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10),
                            child: Text("capture".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "Open Sans",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff6200EE)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(
                                          color: Color(0xff6200EE)))))))
                ],
              );
            } else if (state is OCRLoading) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 14, bottom: 13, top: 31),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CameraPreview(_controller),
                          ),
                        )),
                  ),
                  Positioned(
                      top: 350,
                      left: 35,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff6200EE),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 10),
                          child: Text("OCR in progress...",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Open Sans",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ))
                ],
              );
            } else if (state is EventSuccessful) {
              ocrText = state.response;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 14, bottom: 13, top: 31),
                        child: Container(
                          color: Colors.white,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Text(ocrText),
                          ),
                        )),
                  ),
                  Positioned(
                      bottom: 33,
                      left: 42.64,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              SaveOcrModel model = SaveOcrModel(
                                  message: state.response,
                                  timestamp: DateTime.now());
                              _ocrBloc.add(SaveLocalOCREvent(model));
                            } catch (e) {
                              /// If an error occurs, log the error to the console.
                              print(e);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 4),
                            child: Text("save text to library".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Open Sans",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff6200EE)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(
                                          color: Color(0xff6200EE)))))))
                ],
              );
            } else if (state is EventSavedSuccessful) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 14, bottom: 13, top: 31),
                        child: Container(
                          color: Colors.white,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Text(ocrText),
                          ),
                        )),
                  ),
                  Positioned(
                      bottom: 33,
                      left: 42.64,
                      child: ElevatedButton(
                          onPressed: null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 4),
                            child: Text("save text to library".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Open Sans",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff979797).withOpacity(0.6)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ))))),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 7.5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text("Text saved to library",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Open Sans",
                                        letterSpacing: 0.25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.6))),
                              ),
                              InkWell(
                                  onTap: () {
                                    _ocrBloc= OCRBloc(OCRInitial());
                                    tabController.animateTo(1);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: Text("GO TO LIBRARY",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.25,
                                            color: Color(0xff6200EE))),
                                  ),),
                              SizedBox(width: 8,)
                            ],
                          ),
                        ),
                      ))
                ],
              );
            }
            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 14, bottom: 13, top: 31),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CameraPreview(_controller),
                        ),
                      )),
                ),
                Positioned(
                    bottom: 33,
                    left: 60,
                    child: ElevatedButton(
                        onPressed: () async {
                          /// Take the Picture in a try / catch block. If anything goes wrong,
                          /// catch the error.
                          try {
                            /// Ensure that the camera is initialized.
                            await _initializeControllerFuture;

                            /// Attempt to take a picture and then get the location
                            /// where the image file is saved.
                            final image = await _controller.takePicture();
                            final String imagePath = image.path;
                            File imageFile = File(imagePath);
                            _ocrBloc.add(OcrEvent(imageFile));
                          } catch (e) {
                            /// If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 10),
                          child: Text("capture".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Open Sans",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff6200EE)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(
                                        color: Color(0xff6200EE)))))))
              ],
            );
          },
        ),
      );
  }
}
