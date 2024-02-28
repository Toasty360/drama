// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:io';
import 'package:Dramatic/services/dramacool.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:ui_web';

class MediaPlayer extends StatefulWidget {
  final File? videoFile;
  final String? m3u8Url;
  final String? id;
  final String? title;

  const MediaPlayer({
    super.key,
    this.videoFile,
    this.m3u8Url,
    this.id,
    this.title,
  });

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  late final player = Player(
    configuration: const PlayerConfiguration(
      vo: 'gpu',
    ),
  );
  late final controller = VideoController(
    player,
    configuration: const VideoControllerConfiguration(
      hwdec: 'auto-safe',
      androidAttachSurfaceAfterVideoParameters: false,
    ),
  );

  String currentQuality = "";
  Map quality = {};

  @override
  void initState() {
    print(widget.title);
    readym3u8();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  readym3u8() async {
    DramaCool.fetchLinks(widget.id).then(
      (value) {
        // print(value);
        setState(() {
          player.open(Media(value[0]["url"]));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
      normal: MaterialVideoControlsThemeData(
          brightnessGesture: true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          volumeGesture: true,
          displaySeekBar: true,
          seekOnDoubleTap: true,
          seekBarThumbSize: 12,
          seekBarMargin: EdgeInsets.only(bottom: 20),
          buttonBarButtonSize: 24.0,
          buttonBarButtonColor: Colors.white,
          bottomButtonBarMargin: EdgeInsets.only(bottom: 25),
          topButtonBarMargin: EdgeInsets.symmetric(horizontal: 0),
          topButtonBar: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                player.dispose();
              },
            ),
            Text(widget.title!,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
          bottomButtonBar: [
            Spacer(),
            IconButton(
              onPressed: () {
                player.seek(player.state.position - Duration(seconds: 10));
              },
              icon: Icon(
                Icons.replay_10_sharp,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                player.seek(player.state.position + Duration(seconds: 10));
              },
              icon: Icon(
                Icons.forward_10_rounded,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                player.seek(
                    player.state.position + Duration(minutes: 1, seconds: 30));
              },
              icon: Icon(
                Icons.double_arrow_rounded,
                color: Colors.white,
              ),
            ),
          ]),
      fullscreen: const MaterialVideoControlsThemeData(
        displaySeekBar: true,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        body: Video(
          fit: kIsWeb ? BoxFit.fitWidth : BoxFit.fill,
          controller: controller,
          wakelock: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    player.dispose();
    super.dispose();
  }
}
