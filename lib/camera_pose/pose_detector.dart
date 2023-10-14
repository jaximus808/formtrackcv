import 'dart:ffi';
import 'dart:async';
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

double abs(double n) {
  return max(n, -n);
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(
      options: PoseDetectorOptions(model: PoseDetectionModel.accurate));
  bool _canProcess = true;
  bool _isBusy = false;
  bool _firstImage = true;
  CustomPaint? _customPaint;
  String? _text;

  bool _isCalibrating = true;

  double average = 0.0;
  double total = 0;
  double p = 0;
  double rangeError = 0.2;

  String _displayText = "cock";

  var _cameraLensDirection = CameraLensDirection.front;
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

  double getDist(Pose _pose, double imgWidth) {
    double distL = -1.0;

    double distR = -1.0;

    final landmark0 = _pose.landmarks[PoseLandmarkType.leftShoulder];
    final landmark1 = _pose.landmarks[PoseLandmarkType.rightShoulder];
    final landmark2 = _pose.landmarks[PoseLandmarkType.leftHip];
    final landmark3 = _pose.landmarks[PoseLandmarkType.rightHip];

    // if (landmark0?.x != null && landmark2?.x != null) {
    //   landmark0!;
    //   landmark2!;
    //   if (landmark0.likelihood > 0.9 && landmark2.likelihood > 0.9) {
    //     distL = sqrt(pow((landmark0.x - landmark2.x), 2) +
    //             pow((landmark0.y - landmark2.y), 2) +
    //             pow((landmark0.z - landmark2.z), 2)) *
    //         max(landmark0.z - landmark2.z, -(landmark0.z - landmark2.z)) /
    //         2;
    //   }
    // }

    // if (landmark1?.x != null && landmark3?.x != null) {
    //   landmark1!;
    //   landmark3!;
    //   if (landmark1.likelihood > 0.9 && landmark3.likelihood > 0.9) {
    //     distR = sqrt(pow((landmark1.x - landmark3.x), 2) +
    //             pow((landmark1.y - landmark3.y), 2) +
    //             pow((landmark1.z - landmark3.z), 2)) *
    //         max(landmark1.z - landmark3.z, -(landmark1.z - landmark3.z)) /
    //         2;
    //     ;
    //   }
    // }

    if (landmark0?.x != null &&
        landmark2?.x != null &&
        landmark1?.x != null &&
        landmark3?.x != null) {
      landmark0!;
      landmark2!;
      landmark1!;
      landmark3!;
      double shoulderWidth = abs(landmark0.x - landmark1.x);
      if (landmark0.likelihood > 0.9 && landmark2.likelihood > 0.9) {
        distL =
            abs(landmark0.y - landmark2.y) * (1 / (shoulderWidth / imgWidth));
      }
      if (landmark1.likelihood > 0.9 && landmark3.likelihood > 0.9) {
        distR =
            abs(landmark1.y - landmark3.y) * (1 / (shoulderWidth / imgWidth));
        ;
      }
    }

    print(distR);
    print(distL);
    if (distR < 0 && distL < 0) {
      return -1;
    } else {
      if (distR < 0) {
        return distL;
      } else if (distL < 0) {
        return distR;
      } else {
        return (distL + distR) / 2;
      }
    }
  }

  void calibrate(List<Pose> poses, double width) {
    double tempDist = getDist(poses[0], width);

    if (tempDist > 0) {
      setState(() {
        p++;
        total += tempDist;
        average = total / p;
      });
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    if (_firstImage) {
      _firstImage = false;
      _isCalibrating = true;
      Timer(const Duration(seconds: 20), () {
        _isCalibrating = false;
      });
    }
    _isBusy = true;
    setState(() {
      _text = '';
    });
    //gets vertexs
    final poses = await _poseDetector.processImage(inputImage);

    if (!_firstImage) {
      if (_isCalibrating) {
        if (poses.isNotEmpty && inputImage.metadata?.size != null) {
          calibrate(List.from(poses), inputImage.metadata!.size.width);
          setState(() {
            _displayText = "calibrating, max length is: $average";
          });
        }
      } else {
        setState(() {
          _displayText = "done calibrating!";
        });
      }
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
