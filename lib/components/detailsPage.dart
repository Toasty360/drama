import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import '/model/drama.dart';
import '/services/dramacool.dart';

import 'Player.dart';

class DetailsPage extends StatefulWidget {
  final Drama item;
  const DetailsPage(this.item, {super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late DramaDetails item;
  bool isDataReady = false;
  bool play = false;
  late MeeduPlayerController _meeduPlayerController;
  static Map<String, DramaDetails> tempData = {};

  getData() async {
    // DramaCool.fetchInfo(widget.item.id);
    print(widget.item.id);
    DramaCool.fetchDetails(widget.item.id).then((value) {
      item = value;
      print(item.des);
      isDataReady = true;
      tempData[widget.item.id] = value;
      print(value.Episodes.length);
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (tempData.containsKey(widget.item.id)) {
      item = tempData[widget.item.id]!;
      isDataReady = true;
      setState(() {});
    } else {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: ListView(shrinkWrap: true, children: [
          Container(
            width: screen.width,
            height: screen.height * 0.3,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(255, 104, 131, 211),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6)
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.4,
                  colorFilter: const ColorFilter.srgbToLinearGamma(),
                  scale: 1.5,
                  image: NetworkImage(widget.item.image),
                  onError: (exception, stackTrace) {
                    Container(
                        color: Colors.amber,
                        alignment: Alignment.center,
                        child: const Text(
                          'Whoops!',
                          style: TextStyle(fontSize: 20),
                        ));
                  },
                )),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                  child: SizedBox(
                    width: screen.width * 0.35,
                    height: 200,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: const Color(0xFF17203A),
                                body: Center(
                                  child: GestureDetector(
                                    onVerticalDragEnd: (details) =>
                                        context.navigator.pop(),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: screen.height * 0.6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(0, 2),
                                                blurRadius: 6)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(isDataReady
                                                  ? item.image
                                                  : widget.item.image))),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            isDataReady ? item.image : widget.item.image,
                            fit: BoxFit.cover,
                            height: 400,
                            errorBuilder: (ctx, error, stackTrace) {
                              return Container(
                                  color: Colors.amber,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Whoops!',
                                    style: TextStyle(fontSize: 30),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all(width: 10, color: Colors.black)),
                  alignment: Alignment.center,
                  width: screen.width * 0.55,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.item.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
          isDataReady
              ? ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: screen.width,
                      height:
                          item.OtherNames.split(",").length > 7 ? 212 : null,
                      child: Wrap(
                          clipBehavior: Clip.antiAlias,
                          runSpacing: 8,
                          spacing: 8,
                          children: item.OtherNames.split(",")
                              .map((element) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(97, 33, 149, 243),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(element),
                                );
                              })
                              .toList()
                              .cast<Widget>()),
                    ),
                    SizedBox(
                      width: screen.width,
                      child: ListTile(
                        title: const Text(
                          "Description :",
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                        subtitle: Text(
                          item.des,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: SizedBox(
                        width: screen.width,
                        child: const Text(
                          "Episodes: ",
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 16),
                        ),
                      ),
                    ),
                    item.Episodes.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: item.Episodes.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // print("Clicked - /movies/dramacool/watch?episodeId=${item.Episodes[index].id}&mediaId=${item.id}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => vidPlayer(
                                          id: item.Episodes[index].id,
                                          seriesid: item.id,
                                        ),
                                      ));
                                  setState(() {});
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        shape: BoxShape.rectangle,
                                        color: const Color.fromARGB(
                                            161, 104, 131, 211),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 6)
                                        ]),
                                    child: Text(item.Episodes[index].title)),
                              );
                            },
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: const Center(
                              child: Text(
                                "TSKK!! No Episodes yet\nSo get Lost 🐸\n👨‍🦯",
                                style: TextStyle(
                                    color: Colors.indigoAccent, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    play ? _meeduPlayerController.dispose() : true;
  }
}
