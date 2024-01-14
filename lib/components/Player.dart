import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter/services.dart';
import '/services/dramacool.dart';

class vidPlayer extends StatefulWidget {
  final String id;
  final String? seriesid;
  const vidPlayer({super.key, required this.id, this.seriesid});

  @override
  State<vidPlayer> createState() => _PlayerState();
}

class _PlayerState extends State<vidPlayer> {
  final MeeduPlayerController _controller = MeeduPlayerController(
    screenManager: const ScreenManager(
      hideSystemOverlay: true,
      forceLandScapeInFullscreen: true,
      systemUiMode: SystemUiMode.immersiveSticky,
      orientations: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    ),
    initialFit: BoxFit.cover,
    loadingWidget: const CircularProgressIndicator(),
    enabledButtons: const EnabledButtons(
        videoFit: false,
        playBackSpeed: false,
        pip: true,
        rewindAndfastForward: true,
        fullscreen: false),
    customIcons: const CustomIcons(
        minimize: Icon(
          Icons.fullscreen_exit,
          color: Colors.white,
        ),
        fullscreen: Icon(Icons.fullscreen_rounded, color: Colors.white),
        sound: Icon(Icons.volume_up_outlined, color: Colors.white),
        mute: Icon(Icons.volume_off_outlined, color: Colors.white)),
    manageWakeLock: true,
    showLogs: false,
    enabledControls: const EnabledControls(
        brightnessSwipes: true,
        doubleTapToSeek: true,
        volumeSwipes: true,
        escapeKeyCloseFullScreen: true,
        desktopDoubleTapToFullScreen: true,
        enterKeyOpensFullScreen: true,
        seekSwipes: true),
    excludeFocus: true,
    autoHideControls: true,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    DramaCool.fetchLinks(widget.id, widget.seriesid).then((value) {
      print(value[0]["url"]);
      _controller.setDataSource(
        DataSource(
          type: DataSourceType.network,
          source: value[0]["url"],
        ),
        autoplay: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MeeduVideoPlayer(controller: _controller));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    super.dispose();
  }
}
