import 'package:ai/controller/scanner.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  final ObjectScanController scanController;

  const CameraView({
    required this.scanController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Camera Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<ObjectScanController>(
        init: scanController,
        builder: (controller) {
          return Stack(
            children: [
              // Camera Preview or Loading
              controller.isCameraInitialized.value
                  ? CameraPreview(controller.cameraController)
                  : const Center(child: CircularProgressIndicator()),

              // Detected object details
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => Text(
                    controller.detectedObjectName.value.isNotEmpty
                        ? controller.detectedObjectName.value
                        : 'No object detected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}