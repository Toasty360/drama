import 'package:Dramatic/pages/wrapper.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';

import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ActorAdapter());
  Hive.registerAdapter(EpisodeAdapter());
  Hive.registerAdapter(DramaAdapter());

  await WatchList.initializeHive();
  await LeftOver.initializeHive();
  await Constants.initializeHive();

  Future<List<Drama>> spotlight = scraper.trending();
  Future<List<Drama>> popular = scraper.fetchPopular();
  Future<List<Drama>> recent = scraper.recent();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Dramatic",
    darkTheme: ThemeData.dark(useMaterial3: true),
    theme: ThemeData(
        fontFamily: 'Open_Sans',
        brightness: Brightness.dark,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF17203A))),
    home: Wrapper(popular: popular, spotlight: spotlight, recent: recent),
  ));
}

class WatchList {
  static late Box<Drama> _hive;

  static Future<void> initializeHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    _hive = await Hive.openBox<Drama>('Later', path: appDocumentDirectory.path);
  }

  static Box<Drama> get hive => _hive;
}

class LeftOver {
  static late Box<Episode> _hive;

  static Future<void> initializeHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    _hive = await Hive.openBox<Episode>('leftover',
        path: appDocumentDirectory.path);
  }

  static Box<Episode> get hive => _hive;
}

class Constants {
  static late Box<String> _hive;

  static Future<void> initializeHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    _hive = await Hive.openBox<String>('constants',
        path: appDocumentDirectory.path);
  }

  static Box<String> get hive => _hive;
}
