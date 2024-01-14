import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import '/components/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initMeeduPlayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    initMeeduPlayer();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "senpei",
      theme: ThemeData(
          fontFamily: 'Open_Sans',
          brightness: Brightness.dark,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF17203A))),
      home: const Home(),
    );
  }
}
