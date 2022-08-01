import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera/src/data/my_images_repository.dart';
import 'package:my_camera/src/domain/my_image_list.dart';

/// Displays detailed information about a SampleItem.
class MyCameraView extends StatefulWidget {
  const MyCameraView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  State<MyCameraView> createState() => _MyCameraViewState();
}

class _MyCameraViewState extends State<MyCameraView>
    with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? controller;
  XFile? lastImage;

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = controller;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Camera Preview',
        ),
      ),
      body: MaterialApp(
        home: Stack(
          children: [
            (cameraController != null && cameraController.value.isInitialized)
                ? Padding(
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CameraPreview(controller!)),
                  )
                : const Center(
                    child: Icon(
                      Icons.camera,
                      size: 100,
                      color: Colors.greenAccent,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<MyImageList, MyImagesRepository>(builder: (_, state) {
        return FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              var now = DateTime.now();

              String file =
                  '${now.year}-${now.month}-${now.day}-${now.hour}${now.minute}${now.second}.png';
              //соединение пути
              String pathAll = '/storage/emulated/0/Pictures/$file';
              lastImage = await controller?.takePicture();
              lastImage?.saveTo(pathAll);

              setState(() {
                _addImagePath(context, pathAll);
              });
            },
            child: const Icon(
              Icons.camera,
            ));
      }),
    );
  }

  void _addImagePath(BuildContext context, String path) {
    context.read<MyImageList>().setFileName(path);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        case 'cameraPermission':
          // Android & web only
          showInSnackBar('Unknown permission error.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    unawaited(initCamera());
    // getPublicDirectoryPath();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
