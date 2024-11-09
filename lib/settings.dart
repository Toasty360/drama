import 'package:extractor/extractor.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

class settings {
  static String? baseURL;
  static String? wikiURL;
  static String? user;
  static String? pfp;
  static StreamProvider? provider = StreamProvider.DoodStream;
}

Scraper scraper = Scraper("https://asianc.co/", "https://asianwiki.co");
Color idk = const Color.fromARGB(225, 31, 33, 35);
