import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomController extends GetxController {
  late VideoPlayerController controller;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  Duration? lastSeek;
  RxBool isPlaying = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    controller = VideoPlayerController.network(
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((value) {
        position.value = controller.value.position;
        duration.value = controller.value.duration;
      });

    super.onInit();
  }

  VideoPlayerValue _getValue() {
    if (lastSeek != null) {
      return controller.value.copyWith(position: lastSeek);
    } else {
      return controller.value;
    }
  }

  Widget customPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(
        () => Stack(
          children: [
            VideoPlayer(controller),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                onPressed: () {
                  controller.seekTo(
                      controller.value.position + const Duration(seconds: 10));
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                onPressed: () {
                  controller.seekTo(
                      controller.value.position - const Duration(seconds: 10));
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(isPlaying.value ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  isPlaying.value = !isPlaying.value;
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                },
              ),
            ),
            CustomPaint(
              painter: _ProgressBarPainter(
                _getValue(),
              ),
            ),
            Positioned(
                bottom: 20.w,
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
                ))
          ],
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
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value);

  VideoPlayerValue value;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const height = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(size.width, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      Paint()..color = const Color.fromRGBO(200, 200, 200, 0.5),
    );
    if (!value.isInitialized) {
      return;
    }
    double playedPartPercent =
        value.position.inMilliseconds / value.duration!.inMilliseconds;
    if (playedPartPercent.isNaN) {
      playedPartPercent = 0;
    }
    final double playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      double start = range.startFraction(value.duration!) * size.width;
      if (start.isNaN) {
        start = 0;
      }
      double end = range.endFraction(value.duration!) * size.width;
      if (end.isNaN) {
        end = 0;
      }
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, size.height / 2),
            Offset(end, size.height / 2 + height),
          ),
          const Radius.circular(4.0),
        ),
        Paint()..color = const Color.fromRGBO(30, 30, 200, 0.2),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(playedPart, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      Paint()..color = const Color.fromRGBO(255, 0, 0, 0.7),
    );
    canvas.drawCircle(
      Offset(playedPart, size.height / 2 + height / 2),
      height * 3,
      Paint()..color = const Color.fromRGBO(200, 200, 200, 1.0),
    );
  }
}
