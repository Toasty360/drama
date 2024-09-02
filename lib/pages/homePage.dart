import 'dart:math';

import 'package:Dramatic/pages/dramaDetailsPage.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/extractor.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

import 'wrapper.dart';

class HomePage extends StatefulWidget {
  final Future<List<Drama>> popular;
  final Future<List<Drama>> spotlight;
  final Scraper scraper;

  const HomePage(
      {super.key,
      required this.scraper,
      required this.popular,
      required this.spotlight});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Drama> spotlight = [];
  static List<Drama> popular = [];

  Future<void> loadData() async {
    await widget.spotlight.then((value) => spotlight = value);
    await widget.popular.then((value) => popular = value);
  }

  @override
  void initState() {
    super.initState();
    if (spotlight.isEmpty || popular.isEmpty) {
      loadData().then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        width: screen.width,
        height: screen.height,
        child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            children: popular.isNotEmpty
                ? [
                    trendingCards(context, spotlight, screen),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 12, 14, 17),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextField(
                          onSubmitted: (value) {
                            mysnack(widget.scraper.search(value, "1"), context);
                          },
                          decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search))),
                    ),
                    header("Popular", null),
                    myGrid(popular, screen, context)
                  ]
                : [
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ]),
      ),
    );
  }
}

myGrid(
  List<Drama> data,
  Size screen,
  BuildContext context,
) {
  return GridView(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: max(2, screen.width ~/ 200),
        mainAxisSpacing: 15,
        mainAxisExtent: 250,
        crossAxisSpacing: 10),
    children: data.map((e) => cards(context, e)).toList().cast<Widget>(),
  );
}

cards(BuildContext context, Drama item) {
  return InkWell(
    onTap: () => Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => Details(item))),
    child: Container(
      width: 175,
      padding: const EdgeInsets.only(left: 10),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: ExtendedNetworkImageProvider(item.image!,
                    headers: {"Referer": "https://asianwiki.co"},
                    cache: true,
                    cacheKey: item.title),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.bottomCenter,
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(16, 0, 0, 0),
                    Color.fromARGB(189, 0, 0, 0),
                  ])),
          child: Text(
            item.title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ]),
    ),
  );
}
