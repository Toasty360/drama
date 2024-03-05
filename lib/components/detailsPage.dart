import 'package:Dramatic/pages/actorDetails..dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../main.dart';
import '../settings.dart';
import 'Player.dart';

class DetailsPage extends StatefulWidget {
  final Drama item;
  const DetailsPage(this.item, {super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Drama item;
  bool isDataReady = false;
  bool play = false;
  final laterBox = WatchList.hive;
  static Map<String, Drama> tempData = {};
  bool issaved = false;

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
      setState(() {});
    });
  }

  @override
  void initState() {
    issaved = laterBox.containsKey(widget.item.id!.split("/").last);
    print(widget.item.id!.split("/").last);
    print(issaved);
    print(laterBox.keys.toList());
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.item.title!),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (issaved) {
                    laterBox.delete(widget.item.id!.split("/").last);
                    Toast.show("Removed",
                        backgroundColor: const Color.fromARGB(225, 31, 33, 35),
                        textStyle: const TextStyle(color: Colors.red));
                  } else {
                    laterBox.put(widget.item.id!.split("/").last, item);
                    Toast.show("Added",
                        backgroundColor: const Color.fromARGB(225, 31, 33, 35),
                        textStyle: const TextStyle(color: Colors.green));
                  }
                  issaved = !issaved;
                });
              },
              icon: Icon(issaved ? Icons.bookmark : Icons.bookmark_border))
        ],
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
                  image: NetworkImage(widget.item.image!),
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
                          child: ExtendedImage.network(
                            isDataReady ? item.image! : widget.item.image!,
                            fit: BoxFit.cover,
                            height: 400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: screen.width * 0.55,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.item.title!,
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
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white38)),
                              child: Text(item.year!),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 2,
                              height: 20,
                              color: Colors.grey,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white38)),
                              child: Text(item.country!),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 2,
                              height: 20,
                              color: Colors.grey,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white38)),
                              child: Text(item.status!),
                            )
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                          clipBehavior: Clip.antiAlias,
                          runSpacing: 8,
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: item.altTitles!
                              .sublist(
                                  0, item.altTitles!.length > 10 ? 5 : null)
                              .map((element) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(225, 31, 33, 35),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(element),
                                );
                              })
                              .toList()
                              .cast<Widget>()),
                    ),
                    item.genre!.isNotEmpty
                        ? SizedBox(
                            width: screen.width,
                            child: ListTile(
                              title: const Text(
                                "Genres :",
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                              subtitle: Text(
                                item.genre!.join(", "),
                              ),
                            ),
                          )
                        : const Center(),
                    SizedBox(
                      width: screen.width,
                      child: ListTile(
                        title: const Text(
                          "Description :",
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                        subtitle: Text(
                          item.description!,
                        ),
                      ),
                    ),
                    item.actors.runtimeType != Null && item.actors!.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(border: Border.all()),
                            height: 200,
                            width: screen.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Actors :",
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 16),
                                ),
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const ClampingScrollPhysics(),
                                    children: item.actors!
                                        .map((e) => InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActorDetails(actor: e),
                                                  )),
                                              mouseCursor:
                                                  SystemMouseCursors.click,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                alignment: Alignment.center,
                                                height: 200,
                                                width: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                              image:
                                                                  NetworkImage(e
                                                                      .image!))),
                                                    ),
                                                    Text(
                                                      e.name!,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList()
                                        .cast<Widget>(),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const Center(),
                    const SizedBox(
                      height: 10,
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
                    item.episodes!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: item.episodes!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print(item.episodes![index].id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MediaPlayer(
                                          episode: item.episodes![index]
                                            ..image = item.image,
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
                                    child: Text(item.episodes![index].name!)),
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
  }
}
