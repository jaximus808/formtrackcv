import 'dart:ffi';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
import '/camera_pose/painter/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  PoseDetectorView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  bool _isCalibrating = true;

  double maxLength = 0.0;
  double rangeError = 0.2;

  String _displayText = "cock";

  var _cameraLensDirection = CameraLensDirection.back;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DetectorView(
        title: 'Pose Detector',
        customPaint: _customPaint,
        text: _text,
        onImage: _processImage,
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      ),
      Container(
          alignment: const FractionalOffset(0.5, 0.75),
          child: Text(_displayText))
    ]);
  }

  // double getDist(Pose _pose) {
  //   double sqrtD = 0.0;
  //   final landmark0 = _pose.landmarks[11]!;
  //   final landmark1 = _pose.landmarks[12]!;
  //   final landmark2 = _pose.landmarks[23]!;
  //   final landmark3 = _pose.landmarks[24]!;

  //   double avgXDist = pow((landmark0.x - landmark2.x), 2)+pow((landmark1.x - landmark3.x), 2);
  //   double avgYDist = pow((landmark0.x - landmark1.x), 2).toDouble();
  //   double avgYDist = pow((landmark1.x - landmark1.x), 2).toDouble();

  //   return 0.5;
  // }

  // void calibrate(List<Pose> poses) {
  //   //double dist = poses[];
  // }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    //gets vertexs
    final poses = await _poseDetector.processImage(inputImage);

    if (poses.isNotEmpty) {
      setState(() {
        _displayText = poses.isNotEmpty &&
                poses[0].landmarks[PoseLandmarkType.nose]?.x != null
            ? poses[0].landmarks[PoseLandmarkType.nose]!.x.toString()
            : "";
      });
    }

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      //this draws the stuff with the vertices
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
