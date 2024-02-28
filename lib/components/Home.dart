// ignore_for_filnst_constructors

import 'dart:math';

import 'package:Dramatic/components/Player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/detailsPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/drama.dart';
import '../services/dramacool.dart';

class Home extends StatefulWidget {
  final Future<List<Drama>> popular;
  final Future<List<Drama>> spotlight;
  const Home({super.key, required this.popular, required this.spotlight});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  static List<Drama> initialData = [];
  List<Drama> data = [];
  // static List<Drama> popular = [];
  List<Drama> spotlight = [];
  bool isSearch = false;
  bool isSearching = false;
  bool toggelSearch = false;

  fetchSearchData(name) async {
    await DramaCool.fetchSearchData(name).then((value) {
      data = value;
      isSearching = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    widget.spotlight.then((value) {
      spotlight = value;
      setState(() {});
    });
    widget.popular.then((value) {
      data = value;
      print("lenght of value ${value.length}");
      initialData = value.sublist(0, min(15, value.length));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    final screen = MediaQuery.of(context).size;
    return NotificationListener<ScrollNotification>(
      // onNotification: (notification) {
      //   if (notification.metrics.maxScrollExtent ==
      //           notification.metrics.pixels &&
      //       initialData.length < data.length) {
      //     print("Entered");
      //     print(data.length);

      //     setState(() {
      //       initialData
      //           .addAll(data.sublist(initialData.length, min(10, data.length)));
      //     });
      //     print(initialData.length);
      //   }
      //   return true;
      // },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: GestureDetector(
              onTap: () {
                isSearch = false;
                isSearching = false;
                toggelSearch = false;
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          width: screen.width,
          height: screen.height,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              toggelSearch
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          color: const Color.fromARGB(123, 118, 141, 208),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        onSubmitted: (value) {
                          if (value != "") {
                            isSearch = true;
                            isSearching = true;
                            fetchSearchData(value);
                          } else {
                            isSearch = false;
                            isSearching = false;
                            setState(() {});
                          }
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: "Wanna see some Drama?",
                            hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            border: InputBorder.none),
                      ),
                    )
                  : const Center(),
              !isSearch
                  ? Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 5,
                          color: const Color.fromARGB(197, 33, 149, 243),
                        ),
                        const Text(
                          "Spotlight",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ]),
                    )
                  : const Center(),
              !isSearch
                  ? spotlight.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: CarouselSlider.builder(
                              itemCount: spotlight.length,
                              itemBuilder: (context, index, realIndex) {
                                return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                DetailsPage(spotlight[index]))),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: screen.width,
                                          alignment: Alignment.center,
                                          height: 300,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      spotlight[index].image),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8)),
                                              color: Color.fromARGB(
                                                  122, 52, 86, 189)),
                                          child: Text(
                                            '#${(index + 1).toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 223, 110, 102)),
                                          ),
                                        )),
                                        Positioned(
                                            top: 0,
                                            child: Container(
                                              height: 300,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          31, 27, 36, 0),
                                                      Color.fromRGBO(
                                                          31, 27, 36, 1),
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: screen.width,
                                            )),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                              width: screen.width,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              alignment: Alignment.center,
                                              child: Text(
                                                spotlight[index].title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 223, 110, 102)),
                                              )),
                                        ),
                                      ],
                                    ));
                              },
                              options: CarouselOptions(
                                  height: 200,
                                  pauseAutoPlayOnManualNavigate: true,
                                  autoPlay: true,
                                  aspectRatio: 1,
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 1),
                                  viewportFraction: 1,
                                  pauseAutoPlayOnTouch: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  animateToClosest: true,
                                  enlargeCenterPage: true)),
                        )
                      : const Center()
                  : const Center(),
              !isSearch
                  ? Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 5,
                          color: const Color.fromARGB(197, 33, 149, 243),
                        ),
                        const Text(
                          "Trending",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ]),
                    )
                  : Row(
                      children: [
                        const Text(
                          "Looking for",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: screen.width * 0.5,
                          child: Text(
                            '${_controller.text}?',
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
              data.isNotEmpty && !isSearching
                  ? recentCards(initialData)
                  : FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 6), () {
                        return true;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                              margin: const EdgeInsets.only(top: 60),
                              child: const Center(
                                  child: Text(
                                "Seriously? 😑",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )));
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 60),
                          alignment: Alignment.bottomCenter,
                          height: screen.height,
                          child: const Center(
                            child: Column(children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator()),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Fetching the data!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ]),
                          ),
                        );
                      },
                    ),
              data.isNotEmpty && !isSearching
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      child: const Text(
                        "Toasty ©",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ))
                  : const Center(),
            ],
          ),
        ),
      ),
    );
  }
}

recentCards(List<Drama> recent) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        mainAxisExtent: 250,
        crossAxisSpacing: 10),
    itemCount: recent.length,
    itemBuilder: (context, index) {
      return Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: ExtendedNetworkImageProvider(recent[index].image,
                    cache: true, cacheKey: recent[index].id),
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
                    Color.fromARGB(49, 23, 24, 59),
                    Color.fromARGB(190, 23, 24, 59),
                  ])),
          child: Text(
            recent[index].title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(
                onPressed: () {
                  recent[index].id = recent[index]
                      .image
                      .split("cover/")
                      .last
                      .split(RegExp("-[0-9]*.png"))
                      .first;
                  print(recent[index].id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => DetailsPage(recent[index])));
                },
                icon: const Icon(Icons.info_outline_rounded))),
        Center(
            child: Container(
          decoration: gradientBox(),
          child: TextButton(
              child: Text(
                "Eps ${recent[index].epsnumber}",
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPlayer(
                          id: recent[index].epsnumber,
                          title: recent[index].title),
                    ));
              }),
        ))
      ]);
    },
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
