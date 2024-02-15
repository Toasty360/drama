import 'package:Dramatic/model/drama.dart';
import 'package:Dramatic/services/dramacool.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import '/components/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  Future<List<Drama>> spotlight = DramaCool.spotlight();
  Future<List<Drama>> popular = DramaCool.popular();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Dramatic",
    darkTheme: ThemeData.dark(useMaterial3: true),
    theme: ThemeData(
        fontFamily: 'Open_Sans',
        brightness: Brightness.dark,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF17203A))),
    home: Home(popular: popular, spotlight: spotlight),
  ));
}
