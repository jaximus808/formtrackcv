import 'dart:ffi';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
  bool camOff = false;

  bool _isCalibrating = true;

  double average = 0.0;
  double total = 0;
  double p = 0;
  double rangeError = 0.2;
  double shoulderHipDisAvg = 0.0;
  double totalSH = 0.0;
  double shP = 0.0;

  double recentDist = 0.0;
  double recentshoulderHipDis = 0.0;

  double errorPercent = 0.8;
//

  final audioplayer = AudioPlayer();
  bool badform = false;

  //String _displayText = "stand forward and still!";
  String _displayText = "stand infront of the camera to start!";

  var _cameraLensDirection = CameraLensDirection.front;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    audioplayer.stop();
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
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            widthFactor: 1,
            child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.lightBlue,
                child: Text(
                  _displayText,
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                ))),
      )
    ]);
  }

  double getDist(Pose _pose, double imgWidth, bool calibrating) {
    double distL = -1.0;

    double distR = -1.0;

    final landmark0 = _pose.landmarks[PoseLandmarkType.leftShoulder];
    final landmark1 = _pose.landmarks[PoseLandmarkType.rightShoulder];
    final landmark2 = _pose.landmarks[PoseLandmarkType.leftHip];
    final landmark3 = _pose.landmarks[PoseLandmarkType.rightHip];

    if (landmark0?.x != null &&
        landmark2?.x != null &&
        landmark1?.x != null &&
        landmark3?.x != null) {
      landmark0!;
      landmark2!;
      landmark1!;
      landmark3!;
      double shoulderWidth = sqrt(pow((landmark0.x - landmark1.x), 2) +
          pow((landmark0.y - landmark1.y), 2));
      if (landmark0.likelihood > 0.9 && landmark2.likelihood > 0.9) {
        distL = sqrt(pow((landmark0.x - landmark2.x), 2) +
                pow((landmark0.y - landmark2.y), 2)) *
            (1 / (shoulderWidth / imgWidth));
      }
      if (landmark1.likelihood > 0.9 && landmark3.likelihood > 0.9) {
        distR = sqrt(pow((landmark1.x - landmark3.x), 2) +
                pow((landmark1.y - landmark3.y), 2)) *
            (1 / (shoulderWidth / imgWidth));
      }
      if (distL > 0 && distR > 0) {
        if (calibrating) {
          setState(() {
            totalSH += (abs(sqrt(pow((landmark0.x - landmark1.x), 2)) -
                    sqrt(pow((landmark2.x - landmark3.x), 2)))) *
                (1 / (shoulderWidth / imgWidth));
            shP++;
            shoulderHipDisAvg = totalSH / shP;
          });
        } else {
          setState(() {
            recentshoulderHipDis = (abs(
                    sqrt(pow((landmark0.x - landmark1.x), 2)) -
                        sqrt(pow((landmark2.x - landmark3.x), 2)))) *
                (1 / (shoulderWidth / imgWidth));
          });
        }
      }
    }
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
    double tempDist = getDist(poses[0], width, true);

    if (tempDist > 0) {
      setState(() {
        p++;
        total += tempDist;
        average = total / p;
      });
    }
  }

  void calculateForm(List<Pose> poses, double width) {
    double tempDist = getDist(poses[0], width, false);

    if (tempDist > 0) {
      setState(() {
        recentDist = tempDist * ((shoulderHipDisAvg / recentshoulderHipDis));
      });
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (camOff) return;
    if (!_canProcess) return;
    if (_isBusy) return;

    _isBusy = true;
    setState(() {
      _text = '';
    });
    //gets vertexs
    final poses = await _poseDetector.processImage(inputImage);
    if (_firstImage) {
      _isBusy = false;
      if (!poses.isNotEmpty) {
        return;
      }
      setState(() {
        camOff = true;
        _firstImage = false;
        _displayText = "get into position and face the camera!";
        Timer(const Duration(seconds: 5), () {
          setState(() {
            camOff = false;
            Timer(const Duration(seconds: 8), () {
              _isCalibrating = false;
            });
          });
        });
      });

      return;
    }
    if (!_firstImage) {
      if (_isCalibrating) {
        if (poses.isNotEmpty && inputImage.metadata?.size != null) {
          calibrate(List.from(poses), inputImage.metadata!.size.width);
          setState(() {
            _displayText = "calibrating";
          });
        }
      } else {
        if (poses.isNotEmpty && inputImage.metadata?.size != null) {
          calculateForm(List.from(poses), inputImage.metadata!.size.width);
          double percentAcc = recentDist / average;
          if (percentAcc < errorPercent) {
            audioplayer.play(AssetSource("music/badform.wav"));
          } else {
            audioplayer.stop();
          }

          setState(() {
            _displayText = "done calibrating! current Dis: $percentAcc";
          });
        }
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
