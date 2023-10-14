import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Gametime extends StatefulWidget {
  const Gametime({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<Gametime> createState() => _GametimeState();
}

class _GametimeState extends State<Gametime> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();

    // widget.cameras grabs cameras field from parent class
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}
