import 'package:flutter/material.dart';
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
  Duration? lastSeek;
  RxBool isPlaying = false.obs;
  var sliderVal = 0.0.obs;
  var isVisible = false.obs;
  final _setBrightness = 1.0.obs;
  final _setVolumeValue = 1.0.obs;
  var volVisible = false.obs;
  var brightVisible = false.obs;
  late TabController _tabController;
  var playback = 1.obs;
  var caption = [].obs;
  @override
  void onInit() {
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
    _tabController = TabController(length: 3, vsync: this);
    ScreenBrightness()
        .current
        .then((brightness) => _setBrightness.value = brightness);
    VolumeController()
        .getVolume()
        .then((volume) => _setVolumeValue.value = volume);
    super.onInit();
  }

  Widget customPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(
        () => GestureDetector(
          onTap: () {
            isVisible.value = !isVisible.value;
            Future.delayed(const Duration(seconds: 5), () {
              isVisible.value = false;
            });
          },
          child: Stack(
            children: [
              VideoPlayer(controller),
              ClosedCaption(
                  text:
                      VideoPlayerValue(duration: position.value).caption.text),
              Visibility(
                // visible: isVisible.value,
                visible: true,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black45),
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(top: 55.w, left: 50.w, right: 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: SvgPicture.asset("assets/reverse.svg"),
                              onPressed: () {
                                controller.seekTo(controller.value.position -
                                    const Duration(seconds: 10));
                              },
                            ),
                            TextButton(
                              child: SvgPicture.asset(
                                isPlaying.value
                                    ? "assets/pause.svg"
                                    : "assets/play.svg",
                              ),
                              onPressed: () {
                                isPlaying.value = !isPlaying.value;
                                controller.value.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                              },
                            ),
                            TextButton(
                              child: SvgPicture.asset(
                                "assets/forward.svg",
                              ),
                              onPressed: () {
                                controller.seekTo(controller.value.position +
                                    const Duration(seconds: 10));
                              },
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Container(
                          padding: EdgeInsets.only(top: 100.w),
                          height: 200.h,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 30.w,
                                bottom: 30.w,
                                left: 20.w,
                                right: 18.w),
                            child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 2.w,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 6.w),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 1.w),
                                  thumbColor: Colors.red,
                                  activeTrackColor: Colors.red,
                                  inactiveTrackColor: Colors.grey),
                              child: Slider(
                                value: position.value.inSeconds.toDouble(),
                                min: 0.0,
                                max: duration.value.inSeconds.toDouble(),
                                // divisions: duration.value.inSeconds.round(),
                                onChanged: (double newValue) {
                                  // position.value =
                                  // Duration(seconds: newValue.toInt());
                                  controller.seekTo(
                                      Duration(seconds: newValue.toInt()));
                                },
                                mouseCursor: MouseCursor.uncontrolled,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 160.w, left: 25.w, right: 25.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: formatDuration(position.value),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Text(
                                formatDuration(duration.value),
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          )),
                      Positioned(
                        bottom: 55.h,
                        left: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: brightVisible.value,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: SizedBox(
                                  width: 80.w,
                                  // margin: EdgeInsets.only(
                                  //     top: 30.w,
                                  //     bottom: 30.w,
                                  //     left: 20.w,
                                  //     right: 18.w),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 2.w,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.w),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 1.w),
                                        thumbColor: Colors.white,
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.grey),
                                    child: Slider(
                                      value: _setBrightness.value,
                                      min: 0.0,
                                      max: 1.0,
                                      // divisions: duration.value.inSeconds.round(),
                                      onChanged: (double newValue) {
                                        // position.value =
                                        // Duration(seconds: newValue.toInt());
                                        _setBrightness.value = newValue;
                                        ScreenBrightness()
                                            .setScreenBrightness(newValue);
                                      },
                                      mouseCursor: MouseCursor.uncontrolled,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: TextButton(
                                onPressed: () {
                                  brightVisible.value = !brightVisible.value;
                                  Future.delayed(const Duration(seconds: 5),
                                      () => brightVisible.value = false);
                                },
                                child: SvgPicture.asset(
                                  "assets/brightness.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 55.h,
                        right: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: volVisible.value,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: SizedBox(
                                  width: 80.w,
                                  // margin: EdgeInsets.only(
                                  //     top: 30.w,
                                  //     bottom: 30.w,
                                  //     left: 20.w,
                                  //     right: 18.w),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 2.w,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.w),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 1.w),
                                        thumbColor: Colors.white,
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.grey),
                                    child: Slider(
                                      value: _setVolumeValue.value,
                                      min: 0.0,
                                      max: 1.0,
                                      // divisions: duration.value.inSeconds.round(),
                                      onChanged: (double newValue) {
                                        // position.value =
                                        // Duration(seconds: newValue.toInt());
                                        _setVolumeValue.value = newValue;
                                        VolumeController().setVolume(newValue);
                                      },
                                      mouseCursor: MouseCursor.uncontrolled,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: TextButton(
                                onPressed: () {
                                  volVisible.value = !volVisible.value;
                                  Future.delayed(const Duration(seconds: 5),
                                      () => volVisible.value = false);
                                },
                                child: SvgPicture.asset(
                                  "assets/volume.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: -8.w,
                          right: 10.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.bottomSheet(Container(
                                    color: Colors.black,
                                    height: 280.h,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Settings",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.w),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15.w,
                                          ),
                                          TabBar(
                                            labelColor: Colors.white,
                                            unselectedLabelColor:
                                                Colors.white60,
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.w),
                                            indicatorColor: Colors.white,
                                            tabs: const [
                                              Tab(
                                                text: "Quality",
                                              ),
                                              Tab(
                                                text: "Playback Speed",
                                              ),
                                              Tab(
                                                text: "Subtitle",
                                              ),
                                            ],
                                            controller: _tabController,
                                          ),
                                          SizedBox(
                                            height: 150.h,
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Full HD upto 1080p",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "HD upto 720p",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "HD upto 480p",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Low Data Saver",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    ],
                                                  ),
                                                ),
                                                Obx(
                                                  () => SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ListTile(
                                                            onTap: () {
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      0.25);
                                                              playback.value =
                                                                  1;
                                                            },
                                                            title: Text(
                                                              "0.25x",
                                                              style: TextStyle(
                                                                  color: playback
                                                                              .value ==
                                                                          1
                                                                      ? const Color(
                                                                          0xffC02739)
                                                                      : Colors
                                                                          .white),
                                                            )),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  2;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      0.5);
                                                            },
                                                            title: Text("0.5x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            2
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  3;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      0.75);
                                                            },
                                                            title: Text("0.75x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            3
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  4;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      1);
                                                            },
                                                            title: Text(
                                                                "Normal",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            4
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      1.25);
                                                              playback.value =
                                                                  5;
                                                            },
                                                            title: Text("1.25x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            5
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  6;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      1.5);
                                                            },
                                                            title: Text("1.5x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            6
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  7;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      1.75);
                                                            },
                                                            title: Text("1.75x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            7
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                        ListTile(
                                                            onTap: () {
                                                              playback.value =
                                                                  8;
                                                              controller
                                                                  .setPlaybackSpeed(
                                                                      2);
                                                            },
                                                            title: Text("2x",
                                                                style: TextStyle(
                                                                    color: playback.value ==
                                                                            8
                                                                        ? const Color(
                                                                            0xffC02739)
                                                                        : Colors
                                                                            .white))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Off",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          onPressed: () async {
                                                            List srtFile =
                                                                await _getCloseCaptionFile(
                                                                    "https://www.capitalcaptions.com/wp-content/uploads/2017/04/How-to-Write-.SRT-Subtitles-for-Video.srt");
                                                            const AsyncSnapshot
                                                                .waiting();
                                                            caption.value =
                                                                srtFile;
                                                          },
                                                          child: const Text(
                                                              " English",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Hindi",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ]),
                                  ));
                                },
                                style: TextButton.styleFrom(
                                  fixedSize: Size(35.w, 35.w),
                                  minimumSize: Size(35.w, 35.w),
                                  maximumSize: Size(35.w, 35.w),
                                ),
                                child: SvgPicture.asset(
                                  "assets/settings.svg",
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  fixedSize: Size(35.w, 35.w),
                                  minimumSize: Size(35.w, 35.w),
                                  maximumSize: Size(35.w, 35.w),
                                ),
                                child: SvgPicture.asset(
                                  "assets/fullscreen.svg",
                                  width: 15.w,
                                  height: 15.w,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static String formatDuration(Duration position) {
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

  Future<List> _getCloseCaptionFile(url) async {
    try {
      final data = await http.get(Uri.parse(url));
      final srtContent = data.body.toString().trim();
      var lines = srtContent.split('\n');
      // var subtitles = <String, String>{};

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

          final data = lines[++i].trim();

          subtitles
              .add(Subtitle(index: index, start: start, end: end, data: data));
        }
        return subtitles;
      }
    } catch (e) {
      print('Failed to get subtitles');
      print(e);
    }
    return [];
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    int seconds;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds =
        (double.parse(parts[parts.length - 1].split(",")[0]) * 1000000).round();
    micros =
        (double.parse(parts[parts.length - 1].split(",")[1]) * 1000000).round();
    return Duration(
        hours: hours, minutes: minutes, microseconds: micros, seconds: seconds);
  }
}
