import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tflite_maven/tflite.dart';

import 'AboutCancers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isImageLoaded = false;
bool scanningBrain = true;
bool isCancerDetected = true;
bool isLoading = false;
// ignore: prefer_typing_uninitialized_variables
var imageFile;
double confidence = 0.00;
String label = '';
String cancerDesc = '';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Align(
              alignment: Alignment.topCenter,
              //The Top Container > which contains the image
              child: Container(
                width: devWidth * 0.90,
                height: devHeight * 0.40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 209, 208, 208),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6),
                      topLeft: Radius.circular(6),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                ),
                child: Center(
                    child: imageFile == null
                        ? Image.asset(
                            'assets/noImage.png',
                            height: devHeight * 0.30,
                            width: devWidth * 0.80,
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(6),
                                topLeft: Radius.circular(6),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            child: Image.file(
                              imageFile,
                              height: devHeight * 0.40,
                              width: devWidth * 0.90,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: isImageLoaded
                  ? displayDetailsAfterImageLoaded(devWidth, devHeight)
                  : displayDetailsBeforeImageLoaded(devWidth, devHeight),
            ),
          ),
        ],
      ),
    );
  }

  displayDetailsAfterImageLoaded(devWidth, devHeight) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: devHeight * 0.45,
          ),
          //Loading Shimmer Container
          isLoading
              ? SizedBox(
                  width: devWidth * 0.96,
                  height: devHeight * 0.55,
                  child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 250, 222, 222),
                      highlightColor: const Color.fromARGB(255, 224, 250, 222),
                      child: Container(
                        width: devWidth * 0.96,
                        height: devHeight * 0.55,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 227, 227, 227),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                      )),
                )
              :
              //The Bottom Container > which contains the details after uploading images
              Container(
                  constraints: BoxConstraints(
                    maxWidth: devWidth * 0.96,
                    minHeight: devHeight * 0.55,
                  ),
                  decoration: BoxDecoration(
                    color: isCancerDetected
                        // ignore: dead_code
                        ? const Color.fromARGB(255, 250, 222, 222)
                        : const Color.fromARGB(255, 224, 250, 222),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isCancerDetected
                                  // ignore: dead_code
                                  ? scanningBrain
                                      ? "Tumor Detected !"
                                      : "Cancer Detected !"
                                  : "No Cancer Detected !",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () async {
                                //Clear Image
                                setState(() {
                                  isImageLoaded = false;
                                  isCancerDetected = false;
                                  scanningBrain = true;
                                  imageFile = null;
                                  confidence = 0.00;
                                  label = '';
                                });
                                await Tflite.close();
                              },
                              child: Container(
                                width: devWidth * 0.17,
                                height: devWidth * 0.17,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Image.asset(
                                        'assets/bin.png',
                                        width: devWidth * 0.08,
                                        height: devWidth * 0.08,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 6.0, bottom: 4.0),
                                      child: Text(
                                        "Clear",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isCancerDetected
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Confidence: ",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "${confidence.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      isCancerDetected
                          // ignore: dead_code
                          ? Text(
                              label,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          : const Text(""),
                      isCancerDetected
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 20.0, 10.0, 32.0),
                              child: Text(
                                cancerDesc,
                                style: const TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const Text(""),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: isCancerDetected
                            ? scanningBrain
                                ? Image.asset(
                                    'assets/brainTumorVector.png',
                                    width: devWidth * 0.80,
                                    height: devHeight * 0.15,
                                  )
                                : Image.asset(
                                    'assets/skinCancerVector.png',
                                    width: devWidth * 0.80,
                                    height: devHeight * 0.15,
                                  )
                            : Image.asset(
                                'assets/cancerRibbon.png',
                                width: devWidth * 0.80,
                                height: devHeight * 0.15,
                              ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 18.0, 10.0, 12.0),
                        child: Text(
                          "(It is advised to consult with a doctor or a specialist before taking any decisions on your own)",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 8.0),
                        child: Text(
                          "\"This is just an experimental AI model, the results above are not accurate. This app was created with an intention of showcasing my personal portfolio.\"",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  displayDetailsBeforeImageLoaded(devWidth, devHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: devHeight * 0.45,
        ),
        isLoading
            //Loading Shimmer Container
            ? SizedBox(
                width: devWidth * 0.96,
                height: devHeight * 0.55,
                child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 250, 222, 222),
                    highlightColor: const Color.fromARGB(255, 224, 250, 222),
                    child: Container(
                      width: devWidth * 0.96,
                      height: devHeight * 0.55,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 227, 227, 227),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                    )),
              )
            :
            //The Bottom Container > which contains the details before uploading images
            Container(
                constraints: BoxConstraints(
                  maxWidth: devWidth * 0.96,
                  minHeight: devHeight * 0.55,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 227, 227, 227),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                scanningBrain = true;
                              });
                              letUserPickAnImage();
                            },
                            child: Container(
                              width: devWidth * 0.20,
                              height: devWidth * 0.20,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 240, 240, 240),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Image.asset(
                                      'assets/brain.png',
                                      width: devWidth * 0.12,
                                      height: devWidth * 0.12,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 6.0, bottom: 5.0),
                                    child: Text(
                                      "Brain Tumor",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                scanningBrain = false;
                              });
                              letUserPickAnImage();
                            },
                            child: Container(
                              width: devWidth * 0.20,
                              height: devWidth * 0.20,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 240, 240, 240),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Image.asset(
                                      'assets/tumor.png',
                                      width: devWidth * 0.12,
                                      height: devWidth * 0.12,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 6.0, bottom: 5.0),
                                    child: Text(
                                      "Skin Cancer",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: devHeight * 0.10),
                        child: const Text(
                          "Tap on any of the buttons above to start predicting.",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Image.asset(
                          'assets/cancerRibbon.png',
                          width: devWidth * 0.80,
                          height: devHeight * 0.15,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "(Kindly upload only MRI or Dermatoscopic Images)",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Text(
                          "\"This is just an experimental AI model, the results will not be accurate. This app was created with an intention of showcasing my personal portfolio.\"",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  letUserPickAnImage() {
    double devHeight = MediaQuery.of(context).size.height;
    double devWidth = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            title: const Text('Pick an Image'),
            content: SizedBox(
              height: devHeight * 0.15,
              child: Center(
                  child: scanningBrain
                      ? const Text(
                          "Kindly upload only MRI (Magnetic Resonance Imaging) image.",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )
                      : const Text(
                          "Kindly upload only Dermatoscopic image.",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        //Accept images from user via camera
                        _getImage(ImageSource.camera);
                      },
                      child: Container(
                        width: devWidth * 0.17,
                        height: devWidth * 0.17,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset(
                                'assets/camera.png',
                                width: devWidth * 0.08,
                                height: devWidth * 0.08,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 4.0),
                              child: Text(
                                "Camera",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: devWidth * 0.13,
                    ),
                    InkWell(
                      onTap: () {
                        //Accept images from user via gallery
                        _getImage(ImageSource.gallery);
                      },
                      child: Container(
                        width: devWidth * 0.17,
                        height: devWidth * 0.17,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset(
                                'assets/gallery.png',
                                width: devWidth * 0.08,
                                height: devWidth * 0.08,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 4.0),
                              child: Text(
                                "Gallery",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  _getImage(source) async {
    XFile? xFile = await ImagePicker()
        .pickImage(source: source, preferredCameraDevice: CameraDevice.rear);
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile.path);
        isImageLoaded = true;
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      startPredicting();
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      setState(() {
        imageFile = null;
        isImageLoaded = false;
        isCancerDetected = false;
      });
      // ignore: use_build_context_synchronously
      _displaySnackBar(context, "No Image Selected.", true);
    }
  }

  _displaySnackBar(contextThis, message, isError) {
    ScaffoldMessenger.of(contextThis).showSnackBar(SnackBar(
      content: Row(
        children: [
          isError
              ? const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.info_rounded,
                  color: Colors.black,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              message,
              style: TextStyle(color: isError ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 1800),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
      backgroundColor: isError ? Colors.red.withOpacity(0.85) : Colors.white,
    ));
  }

  startPredicting() async {
    setState(() {
      isLoading = true;
    });
    int expectedResultNumber;
    if (scanningBrain) {
      expectedResultNumber = 4;
      await Tflite.loadModel(
          model: 'assets/brainTumor.tflite', labels: 'assets/brainLabels.txt');
    } else {
      expectedResultNumber = 7;
      await Tflite.loadModel(
          model: 'assets/skinCancer.tflite', labels: 'assets/skinLabels.txt');
    }

    await Tflite.runModelOnImage(
      path: imageFile.path,
      numResults: expectedResultNumber,
    ).then((pred) {
      //print(pred);
      switch (pred!.first['label']) {
        case 'Glioma Tumor':
          setState(() {
            cancerDesc = CancerDetails().getGilomaDetails().toString();
          });
          break;
        case 'Meningioma Tumor':
          setState(() {
            cancerDesc = CancerDetails().getMeninDetails().toString();
          });
          break;
        case 'Pituitary Tumor':
          setState(() {
            cancerDesc = CancerDetails().getPituitaryDetails().toString();
          });
          break;
        case 'Actinic keratoses':
          setState(() {
            cancerDesc = CancerDetails().getactinicDetails().toString();
          });
          break;
        case 'Basal cell carcinoma':
          setState(() {
            cancerDesc = CancerDetails().getbasalCellDetails().toString();
          });
          break;
        case 'Benign keratosis-like lesions':
          setState(() {
            cancerDesc = CancerDetails().getbenignKLDetails().toString();
          });
          break;
        case 'Dermatofibroma':
          setState(() {
            cancerDesc = CancerDetails().getdermatofibromaDetails().toString();
          });
          break;
        case 'Melanoma':
          setState(() {
            cancerDesc = CancerDetails().getmelanomaDetails().toString();
          });
          break;
        case 'Melanocytic nevi':
          setState(() {
            cancerDesc = CancerDetails().getMelanocyticDetails().toString();
          });
          break;
        case 'Vascular lesions':
          setState(() {
            cancerDesc = CancerDetails().getvascularDetails().toString();
          });
          break;
      }
      setState(() {
        confidence = pred.first['confidence'] * 100;
        label = pred.first['label'];
        if (confidence < 20.0) {
          isCancerDetected = false;
        } else {
          if (label == 'No Tumor') {
            isCancerDetected = false;
          } else {
            isCancerDetected = true;
          }
        }
        isLoading = false;
      });
    }).catchError((e) {
      // ignore: avoid_print
      print("error while predicting: $e");
      setState(() {
        isLoading = false;
      });
      _displaySnackBar(context, "An error occurred while predicting!", true);
    });
  }
}
