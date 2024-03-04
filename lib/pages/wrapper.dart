// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:Dramatic/components/detailsPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import '../components/Player.dart';

class Wrapper extends StatefulWidget {
  final Future<List<Drama>> popular;
  final Future<List<Drama>> spotlight;
  final Future<List<Drama>> recent;
  const Wrapper(
      {super.key,
      required this.popular,
      required this.spotlight,
      required this.recent});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Scraper scraper = Scraper("https://dramacool.pa/", "https://asianwiki.co");
  final TextEditingController _controller = TextEditingController();
  bool toggelSearch = false;
  bool isSearch = false;

  late List<Drama> spotlight = [];
  late List<Drama> recent = [];
  late List<Drama> popular = [];

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {});
    });
  }

  Future<void> loadData() async {
    widget.spotlight.then((value) => spotlight = value);
    widget.popular.then((value) => popular = value);
    await widget.recent.then((value) => recent = value);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    final screen = MediaQuery.of(context).size;
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
              },
              child: const Text(
                "Val",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              )),
          actions: [
            IconButton(
                onPressed: () {
                  toggelSearch = !toggelSearch;
                  isSearch = !isSearch;
                  setState(() {});
                },
                icon: Icon(!isSearch ? Icons.search : Icons.cancel)),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          alignment: Alignment.center,
          width: screen.width,
          height: screen.height,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            children: recent.isNotEmpty
                ? [
                    isSearch
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextField(
                                onSubmitted: (value) {
                                  mysnack(scraper.search(value, "1"), context);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search))),
                          )
                        : const Center(),
                    trendingCards(context, spotlight, screen),
                    header("Popular"),
                    myCardList(popular, screen),
                    header("Recent"),
                    recentCards(recent, screen)
                  ]
                : [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
          ),
        ));
  }
}

mysnack(Future<List<Drama>> fuData, BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  return showModalBottomSheet(
    elevation: 0,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    enableDrag: true,
    isDismissible: true,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    showDragHandle: true,
    shape: BeveledRectangleBorder(),
    context: context,
    builder: (context) => FutureBuilder(
      future: fuData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Drama> data = snapshot.data!;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(data[index]),
                        )),
                    child: Container(
                      width: screen.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(225, 31, 33, 35)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: ExtendedNetworkImageProvider(
                                        data[index].image!))),
                          ),
                          Container(
                            width: screen.width * 0.5,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index].title!,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data[index].country!,
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 212, 212, 216),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      data[index].status!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}

myCardList(List<Drama> data, Size screen) {
  return Container(
    height: 250,
    child: ListView.builder(
      padding: const EdgeInsets.only(left: 10, top: 10),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => DetailsPage(data[index]))),
        child: Container(
          width: 175,
          padding: const EdgeInsets.only(left: 10),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: ExtendedNetworkImageProvider(data[index].image!,
                        headers: {"Referer": "https://asianwiki.co"},
                        cache: true),
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
                        Color.fromARGB(16, 23, 24, 59),
                        Color.fromARGB(190, 23, 24, 59),
                      ])),
              child: Text(
                data[index].title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}

BoxDecoration gradientBox() => BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x000ffeee),
          blurRadius: 20.0,
        ),
      ],
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(118, 141, 84, 200),
          Color.fromARGB(148, 71, 119, 200)
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    );

header(String text) {
  return Container(
    margin: const EdgeInsets.only(left: 20, top: 20),
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          color: Colors.red,
          width: 5,
          height: 20,
        ),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 229, 223, 223)))
      ],
    ),
  );
}

trendingCards(BuildContext ctx, List<Drama> trending, Size screen) {
  return CarouselSlider(
      items: trending
          .map((e) => GestureDetector(
                onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(e),
                    )),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(e.image!),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color.fromARGB(16, 23, 24, 59),
                              Color.fromARGB(255, 23, 24, 59),
                            ])),
                        child: Text(
                          e.title!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .cast<Widget>()
          .toList(),
      options: CarouselOptions(
          height: 250,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlay: true,
          enlargeCenterPage: true));
}

recentCards(List<Drama> recent, Size screen) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: max(2, screen.width ~/ 200),
        mainAxisSpacing: 15,
        mainAxisExtent: 250,
        crossAxisSpacing: 10),
    itemCount: recent.length,
    itemBuilder: (context, index) {
      return Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(recent[index].image!),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomCenter,
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(15, 23, 24, 59),
                    Color.fromARGB(255, 23, 24, 59),
                  ])),
          child: Text(
            recent[index].title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          width: 40,
          decoration: const BoxDecoration(
              color: Color.fromARGB(107, 33, 149, 243),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            recent[index].epsNumber!.toInt().toString(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(recent[index]),
                      ));
                },
                child: Icon(Icons.info_outline),
              )),
        ),
        Center(
            child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(87, 155, 39, 176),
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () {
                print(recent[index].id!.split("/").last);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPlayer(
                          id: recent[index].id!.split("/").last,
                          title: recent[index].title),
                    ));
              }),
        ))
      ]);
    },
  );
}
