import 'package:Dramatic/main.dart';
import 'package:Dramatic/service/extractor.dart';
import 'package:dio/dio.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:toast/toast.dart';

import '../settings.dart';

class MediaPlayer extends StatefulWidget {
  final Episode episode;

  const MediaPlayer({super.key, required this.episode});

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
        hwdec: 'auto-safe', enableHardwareAcceleration: true),
  );

  Box<Episode> leftover = LeftOver.hive;
  Box<String> myconstants = Constants.hive;

  List<Map<String, dynamic>> qualities = [];
  bool showVertical = false;

  @override
  void initState() {
    readym3u8();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  getQualities(String src) async {
    try {
      var base = "${src.substring(0, src.lastIndexOf("/"))}/";
      src = await (await Dio().get(src)).data;
      List<String> lines = src.split('\n');
      for (String line in lines) {
        if (!line.startsWith('#EXT-X-STREAM-INF') && line.contains("m3u8")) {
          qualities.add({
            'url': base + line,
            'quality': "${line.split(".").reversed.toList()[1]}p",
          });
        }
      }
    } catch (e) {
      Toast.show(e.toString());
    }
  }

  readym3u8() async {
    print(widget.episode.id);
    try {
      var data = await fetchSource(widget.episode.id!);
      getQualities(data["source"][0]["file"]);
      setState(() {
        player.open(Media(data["source"][0]["file"]));
      });
    } catch (e) {
      print(e);
      scraper
          .fetchStreamingLinks(widget.episode.id!,
              provider: StreamProvider.DoodStream)
          .then(
        (value) {
          setState(() {
            player.open(Media(value["src"],
                httpHeaders: {"Referer": value["referer"]}));
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
      normal: MaterialVideoControlsThemeData(
          brightnessGesture: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          volumeGesture: true,
          displaySeekBar: true,
          seekOnDoubleTap: true,
          seekBarThumbSize: 12,
          seekBarMargin: const EdgeInsets.only(bottom: 20),
          buttonBarButtonSize: 24.0,
          buttonBarButtonColor: Colors.white,
          bottomButtonBarMargin: const EdgeInsets.only(bottom: 25),
          topButtonBarMargin: const EdgeInsets.symmetric(horizontal: 0),
          topButtonBar: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(widget.episode.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
            const Spacer(),
            PopupMenuButton(
                icon: const Icon(Icons.bar_chart_rounded),
                tooltip: "Quality",
                itemBuilder: (context) => qualities
                    .map((e) => PopupMenuItem(
                          child: Text(e["quality"]),
                          onTap: () {
                            var pos = player.state.position;
                            Toast.show(e["quality"]);
                            player.open(Media(e["url"])).then((value) {
                              player.state.copyWith(position: pos);
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                player.seek(pos);
                              });
                            });
                          },
                        ))
                    .toList()
                    .cast<PopupMenuItem>()),
            PopupMenuButton(
                itemBuilder: (context) => StreamProvider.values
                    .map((e) => PopupMenuItem(
                          child: Text(e.name),
                          onTap: () {
                            scraper
                                .fetchStreamingLinks(widget.episode.id!,
                                    provider: e)
                                .then(
                              (value) {
                                if (value["src"] != "not found") {
                                  setState(() {
                                    player.open(Media(value["src"],
                                        httpHeaders: e !=
                                                StreamProvider.DoodStream
                                            ? null
                                            : {"Referer": value["referer"]}));
                                  });
                                } else {
                                  Toast.show("Media not found!");
                                }
                              },
                            );
                          },
                        ))
                    .toList()
                    .cast<PopupMenuItem>())
          ],
          bottomButtonBar: [
            const SizedBox(
              width: 10,
            ),
            const MaterialPositionIndicator(),
            const Spacer(),
            IconButton(
              onPressed: () {
                player
                    .seek(player.state.position - const Duration(seconds: 10));
              },
              icon: const Icon(
                Icons.replay_10_sharp,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                player
                    .seek(player.state.position + const Duration(seconds: 10));
              },
              icon: const Icon(
                Icons.forward_10_rounded,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                if (!showVertical) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                }
                showVertical = !showVertical;
                if (mounted) setState(() {});
              },
              icon: const Icon(
                Icons.screen_rotation_rounded,
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
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: Video(
          fit: BoxFit.fitWidth,
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
    if (mounted) {
      myconstants.put(
          "duration",
          (int.parse(myconstants.get("duration") ?? "0") +
                  player.state.position.inMinutes)
              .toString());
      if (player.state.position.inMinutes <
          player.state.duration.inMinutes * 0.8) {
        leftover.put(widget.episode.id, widget.episode);
      }
    }
    player.dispose();
    super.dispose();
  }
}
