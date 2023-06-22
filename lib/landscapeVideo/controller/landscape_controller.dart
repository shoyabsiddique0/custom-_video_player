import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:subtitle/subtitle.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:http/http.dart' as http;

class LandscapeController extends GetxController {
  late VideoPlayerController controller;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  RxBool isPlaying = false.obs;
  var sliderVal = 0.0.obs;
  var isVisible = false.obs;
  final _setBrightness = 1.0.obs;
  final _setVolumeValue = 1.0.obs;
  var volVisible = false.obs;
  var brightVisible = false.obs;
  var playback = 4.obs;
  var caption = [].obs;
  var subVal = 0.obs;
  var lock = false.obs;
  Subtitle? currentSubtitle;
  @override
  void onInit() {
    var pos = Get.arguments;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    super.onInit();
  }

  @override
  void onClose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.onClose();
  }
}
