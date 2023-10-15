import 'package:flutter/material.dart';
import '/camera_pose/pose_detector.dart';

class Gametime extends StatefulWidget {
  const Gametime({Key? key}) : super(key: key);

  @override
  State<Gametime> createState() => _GametimeState();
}

class _GametimeState extends State<Gametime> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: PoseDetectorView()));
  }
}
