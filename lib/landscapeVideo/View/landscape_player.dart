import 'package:custom_video/landscapeVideo/controller/landscape_controller.dart';
import 'package:custom_video/landscapeVideo/widgets/landscape_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandscapePlayer extends StatelessWidget {
  LandscapePlayer({Key? key}) : super(key: key);
  LandscapeController controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LandscapeVideo(),
    );
  }
}
