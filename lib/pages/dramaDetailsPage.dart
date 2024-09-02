import 'dart:math';

import 'package:Dramatic/components/Player.dart';
import 'package:Dramatic/main.dart';
import 'package:Dramatic/pages/actorDetails..dart';
import 'package:Dramatic/settings.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final Drama item;
  const Details(this.item, {super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  late Drama item;
  bool isDataReady = false;
  bool play = false;
  final laterBox = WatchList.hive;
  static Map<String, Drama> tempData = {};
  bool isSaved = false;
  late TabController tabController;
  int selectedIndex = 0;
  getData() async {
    scraper
        .fetchInfo(RegExp(r'cover\/(.*?)-(\d+)\.png')
                .firstMatch(widget.item.image!)
                ?.group(1) ??
            widget.item.id!.split("/").last.split("-episode").first)
        .then((value) {
      item = value;
      isDataReady = true;
      tempData[widget.item.id!] = value;
      if (laterBox.containsKey(widget.item.id!.split("/").last)) {
        laterBox.put(widget.item.id!.split("/").last, value);
      }
      print(item.genre);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
    getData();
    tabController = TabController(
      initialIndex: selectedIndex,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 350,
                    ),
                    Container(
                      width: screen.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              image: NetworkImage(widget.item.image!))),
                    ),
                    Container(
                      height: 210,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(16, 0, 0, 0),
                            Color.fromARGB(152, 0, 0, 0),
                            Color.fromARGB(255, 0, 0, 0),
                          ])),
                    ),
                    Positioned(
                      bottom: 0,
                      left: (screen.width - 150) * 0.5,
                      child: Container(
                        width: 140,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(widget.item.image!))),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    item.title ?? item.title ?? "N/A",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          !isSaved
                              ? WatchList.hive.put(widget.item.id, item)
                              : WatchList.hive.delete(widget.item.id);
                          isSaved = !isSaved;
                        });
                      },
                      child: Text(
                        isSaved ? "In Bucketlist" : "Add to bucket?",
                        style: const TextStyle(color: Colors.purpleAccent),
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    runSpacing: 10,
                    children: item.genre.runtimeType != Null
                        ? item.genre!
                            .map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        const Color.fromARGB(225, 31, 33, 35),
                                  ),
                                  child: Text(e),
                                ))
                            .toList()
                            .cast<Widget>()
                        : [],
                  ),
                ),
                isDataReady
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ))
                    : const Center(),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: Text(
                      item.description != null
                          ? item.description!
                              .substring(0, min(item.description!.length, 400))
                              .replaceAll(RegExp(r'<[^>]*>'), '')
                          : "",
                      textAlign: TextAlign.justify,
                    )),
                isDataReady
                    ? TabBar(
                        splashFactory: NoSplash.splashFactory,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Episodes'),
                          Tab(text: 'Actors'),
                        ],
                        controller: tabController,
                        onTap: (int index) {
                          setState(() {
                            selectedIndex = index;
                            tabController.animateTo(index);
                          });
                        },
                      )
                    : const Center(),
                IndexedStack(
                  index: selectedIndex,
                  children: [
                    Visibility(
                      child: item.episodes.runtimeType != Null
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: item.episodes!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MediaPlayer(
                                            episode: item.episodes![index]
                                              ..image = item.image,
                                          ),
                                        ));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      alignment: Alignment.center,
                                      height: 60,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1)),
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                      child: Text(
                                        item.episodes![index].name!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      )),
                                );
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Visibility(
                      child: item.actors.runtimeType != Null &&
                              item.actors!.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                children: item.actors!
                                    .map((e) => GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ActorDetails(actor: e),
                                              )),
                                          child: Container(
                                              width: screen.width,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    right: 0,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 75,
                                                      width: screen.width - 90,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white
                                                              .withOpacity(0.1),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.1))),
                                                      child: Text(
                                                        e.name!,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 75,
                                                    width: 75,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.network(
                                                          e.image!,
                                                          fit: BoxFit.cover,
                                                          alignment: Alignment
                                                              .topCenter),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ))
                                    .toList()
                                    .cast<Widget>(),
                              ))
                          : const Center(),
                    )
                  ],
                )
              ]),
        ));
  }
}
