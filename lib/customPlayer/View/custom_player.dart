import 'package:custom_video/customPlayer/controller/custome_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomPlayer extends StatelessWidget {
  CustomPlayer({Key? key}) : super(key: key);
  CustomController controller = Get.put(CustomController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Video Player"),
        centerTitle: true,
      ),
      body: Center(
        child: controller.customPlayer(),
      ),
    );
  }
}
