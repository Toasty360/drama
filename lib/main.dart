import 'package:Dramatic/pages/wrapper.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  Scraper scraper = Scraper("https://dramacool.pa/", "https://asianwiki.co");
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
