import 'package:custom_video/landscapeVideo/View/landscape_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:http/http.dart' as http;
import 'package:subtitle/subtitle.dart';

class CustomController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late VideoPlayerController controller;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  RxBool isPlaying = false.obs;
  var sliderVal = 0.0.obs;
  var isVisible = false.obs;
  final setBrightness = 1.0.obs;
  final setVolumeValue = 1.0.obs;
  var volVisible = false.obs;
  var brightVisible = false.obs;
  late TabController tabController;
  var playback = 4.obs;
  var caption = [].obs;
  var subVal = 0.obs;
  Subtitle? currentSubtitle;
  var pos = Get.arguments;
  @override
  void onInit() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    controller = VideoPlayerController.network(
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((value) {
        position.value = controller.value.position;
        duration.value = controller.value.duration;
      });
    controller.addListener(() {
      position.value = controller.value.position;
      sliderVal.value = position.value.inSeconds / duration.value.inSeconds;
    });
    tabController = TabController(length: 3, vsync: this);
    ScreenBrightness()
        .current
        .then((brightness) => setBrightness.value = brightness);
    VolumeController()
        .getVolume()
        .then((volume) => setVolumeValue.value = volume);
    controller.addListener(() {
      if (caption.isNotEmpty) {
        currentSubtitle = getSubtitleForCurrentPosition(position.value);
        // print("---->${currentSubtitle!.data}");
      }
    });
    super.onInit();
  }

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  Future<List> getCloseCaptionFile(url) async {
    try {
      final data = await http.get(Uri.parse(url));
      final srtContent = data.body.toString().trim();
      var lines = srtContent.split('\n');
      // var subtitles = <String, String>{};
      // print("---->${lines.length}");
      List<Subtitle> subtitles = [];
      int index = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line.isEmpty) {
          continue;
        }

        if (int.tryParse(line) != null) {
          index = int.parse(line);
        } else if (line.contains('-->')) {
          final parts = line.split(' --> ');
          final start = parseDuration(parts[0]);
          final end = parseDuration(parts[1]);

          var data = lines[++i].trim();
          var j = i + 1;
          if (lines[j].isNotEmpty) {
            data += " ${lines[++i]}";
          }
          subtitles
              .add(Subtitle(index: index, start: start, end: end, data: data));
          // print("---->${subtitles.length}");
        }
        // print("---->${subtitles.length}");
      }
      return subtitles;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int seconds;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = (double.parse(parts[parts.length - 1].split(",")[0])).round();
    // print("----->$hours $minutes $seconds");
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Subtitle? getSubtitleForCurrentPosition(Duration position) {
    // print("----->${caption.value.length}");
    for (var subtitle in caption.value) {
      // print("----->${subtitle.start}---${subtitle.end}");
      if (position >= subtitle.start && position <= subtitle.end) {
        return subtitle;
      }
    }
    return null;
  }
}
