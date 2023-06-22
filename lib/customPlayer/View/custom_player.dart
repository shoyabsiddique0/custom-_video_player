import 'package:custom_video/customPlayer/controller/custome_video_controller.dart';
import 'package:custom_video/customPlayer/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: PotraitPlayer(),
      ),
    );
  }
}
