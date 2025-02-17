import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ObjectScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late FlutterTts flutterTts;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var detectedObjectName = ''.obs;
  RxMap<String, dynamic> detectedObject = <String, dynamic>{}.obs;

  bool isModelRunning = false;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
    initTTS();
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    flutterTts.stop();
    super.dispose();
  }

  void onObjectDetected(Map<String, dynamic> objectData) {
    detectedObjectName.value = objectData['label'] ?? 'Unknown';
    detectedObject.value = objectData;
  }
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      try {
        await cameraController.initialize();
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 80 == 0) {
            cameraCount = 0;
            ObjectDetected(image);
          }
          update();
        });
        isCameraInitialized(true);
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("Camera permission denied");
    }
  }

  initTFLite() async {
    try {
      await Tflite.loadModel(
        model: "assets/currency_model.tflite",
        labels: "assets/currency_labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
      print("TFLite model loaded successfully");
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }

  initTTS() {
    flutterTts = FlutterTts();
  }

  ObjectDetected(CameraImage image) async {
    if (isModelRunning) return;
    isModelRunning = true;
    try {
      var detected = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) => e.bytes).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4,
      );

      print("Model inference result: $detected");

      if (detected != null && detected.isNotEmpty) {
        final detectedLabel = detected[0]['label'] ?? 'Unknown';
        final detectedConfidence = detected[0]['confidence'] ?? 0.0;

        print("Detected label: $detectedLabel with confidence: $detectedConfidence");

        detectedObjectName.value = detectedLabel;
        onObjectDetected({
          'label': detectedLabel,
        });
        speak(detectedLabel);
      } else {
        detectedObjectName.value = 'No object detected';
      }
    } catch (e) {
      print("Error running model on frame: $e");
    } finally {
      isModelRunning = false;
    }
  }
  speak(String label) async {
    try {
      await flutterTts.setLanguage("ur"); 
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(label);
    } catch (e) {
      print("Error in TTS: $e");
    }
  }
}




class ObjectScanController2 extends ObjectScanController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late FlutterTts flutterTts;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var detectedObjectName = ''.obs;
  RxMap<String, dynamic> detectedObject = <String, dynamic>{}.obs;

  bool isModelRunning = false;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
    initTTS();
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    flutterTts.stop();
    super.dispose();
  }

  void onObjectDetected(Map<String, dynamic> objectData) {
    detectedObjectName.value = objectData['label'] ?? 'Unknown';
    detectedObject.value = objectData;
  }
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      try {
        await cameraController.initialize();
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 80 == 0) {
            cameraCount = 0;
            ObjectDetected(image);
          }
          update();
        });
        isCameraInitialized(true);
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("Camera permission denied");
    }
  }

  initTFLite() async {
    try {
      await Tflite.loadModel(
        model: "assets/object_model.tflite",
        labels: "assets/object_labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
      print("TFLite model loaded successfully");
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }

  initTTS() {
    flutterTts = FlutterTts();
  }

  ObjectDetected(CameraImage image) async {
    if (isModelRunning) return;
    isModelRunning = true;
    try {
      var detected = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) => e.bytes).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4,
      );

      print("Model inference result: $detected");

      if (detected != null && detected.isNotEmpty) {
        final detectedLabel = detected[0]['label'] ?? 'Unknown';
        final detectedConfidence = detected[0]['confidence'] ?? 0.0;

        print("Detected label: $detectedLabel with confidence: $detectedConfidence");

        detectedObjectName.value = detectedLabel;
        onObjectDetected({
          'label': detectedLabel,
        });
        speak(detectedLabel);
      } else {
        detectedObjectName.value = 'No object detected';
      }
    } catch (e) {
      print("Error running model on frame: $e");
    } finally {
      isModelRunning = false;
    }
  }
  speak(String label) async {
    try {
      await flutterTts.setLanguage("ur"); 
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(label);
    } catch (e) {
      print("Error in TTS: $e");
    }
  }
}





class ObjectScanController3 extends ObjectScanController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late FlutterTts flutterTts;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var detectedObjectName = ''.obs;
  RxMap<String, dynamic> detectedObject = <String, dynamic>{}.obs;

  bool isModelRunning = false;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
    initTTS();
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    flutterTts.stop();
    super.dispose();
  }

  void onObjectDetected(Map<String, dynamic> objectData) {
    detectedObjectName.value = objectData['label'] ?? 'Unknown';
    detectedObject.value = objectData;
  }
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      try {
        await cameraController.initialize();
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 80 == 0) {
            cameraCount = 0;
            ObjectDetected(image);
          }
          update();
        });
        isCameraInitialized(true);
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("Camera permission denied");
    }
  }

  initTFLite() async {
    try {
      await Tflite.loadModel(
        model: "assets/textual_model.tflite",
        labels: "assets/textual_labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
      print("TFLite model loaded successfully");
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }

  initTTS() {
    flutterTts = FlutterTts();
  }

  ObjectDetected(CameraImage image) async {
    if (isModelRunning) return;
    isModelRunning = true;
    try {
      var detected = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) => e.bytes).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4,
      );

      print("Model inference result: $detected");

      if (detected != null && detected.isNotEmpty) {
        final detectedLabel = detected[0]['label'] ?? 'Unknown';
        final detectedConfidence = detected[0]['confidence'] ?? 0.0;

        print("Detected label: $detectedLabel with confidence: $detectedConfidence");

        detectedObjectName.value = detectedLabel;
        onObjectDetected({
          'label': detectedLabel,
        });
        speak(detectedLabel);
      } else {
        detectedObjectName.value = 'No object detected';
      }
    } catch (e) {
      print("Error running model on frame: $e");
    } finally {
      isModelRunning = false;
    }
  }
  speak(String label) async {
    try {
      await flutterTts.setLanguage("ur"); 
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(label);
    } catch (e) {
      print("Error in TTS: $e");
    }
  }
}


