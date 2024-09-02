import 'dart:math';

import 'package:Dramatic/pages/dramaDetailsPage.dart';
import 'package:Dramatic/pages/wrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

import '../components/Player.dart';

class RecentPage extends StatefulWidget {
  final Future<List<Drama>> recent;
  const RecentPage({super.key, required this.recent});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  static List<Drama> recent = [];
  Future<void> loadData() async {
    await widget.recent.then((value) => recent = value.sublist(0, 25));
  }

  @override
  void initState() {
    super.initState();
    if (recent.isEmpty) {
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
      body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          children: [
            header("Recent", null),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: recent.length,
              itemBuilder: (context, index) {
                return Container(
                  width: screen.width,
                  height: 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaPlayer(
                              episode: Episode(
                                  image: recent[index].image,
                                  id: recent[index].id!.split("/").last,
                                  name: recent[index].title)),
                        )),
                    child: Stack(children: [
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 160,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              image: DecorationImage(
                                  image: NetworkImage(recent[index].image!),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerRight)),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          child: Container(
                              width: 200,
                              height: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: const [0.5, 0.5],
                                colors: [
                                  Colors.black,
                                  Colors.white.withOpacity(0.1),
                                ],
                              )))),
                      Positioned(
                          left: 15,
                          bottom: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          "Ep ${recent[index].epsNumber!.toInt()}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 10, left: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          recent[index].type!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      )),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Details(recent[index]),
                                        )),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: const Icon(Icons.info),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 25),
                                width: screen.width - 120,
                                child: Text(
                                  recent[index].title!,
                                  maxLines: 2,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ))
                    ]),
                  ),
                );
              },
            )
          ]),
    );
  }
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
                image: ExtendedNetworkImageProvider(recent[index].image!,
                    cache: true, cacheKey: recent[index].title),
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
                    Color.fromARGB(15, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
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
              color: Color.fromARGB(188, 155, 39, 176),
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
                        builder: (context) => Details(recent[index]),
                      ));
                },
                child: const Icon(Icons.info_outline),
              )),
        ),
        Center(
            child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 14, 17),
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPlayer(
                          episode: Episode(
                              image: recent[index].image,
                              id: recent[index].id!.split("/").last,
                              name: recent[index].title)),
                    ));
              }),
        ))
      ]);
    },
  );
}

// recent.isNotEmpty
//             ? ListView(
//                 children: [header("Recent", null), recentCards(recent, screen)],
//               )
//             : const Center(
//                 child: CircularProgressIndicator(),
//               ));
