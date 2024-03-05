import 'dart:math';

import 'package:Dramatic/pages/wrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

import '../components/Player.dart';
import '../components/detailsPage.dart';

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
        body: recent.isNotEmpty
            ? ListView(
                children: [header("Recent", null), recentCards(recent, screen)],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
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
                child: const Icon(Icons.info_outline),
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
