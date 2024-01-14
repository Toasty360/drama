import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/detailsPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/drama.dart';
import '../services/dramacool.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  List<Drama> data = [];
  static List<Drama> popular = [];
  List<Drama> searchData = [];
  List<Drama> spotlight = [];
  bool isSearch = false;
  bool isSearching = false;
  bool toggelSearch = false;

  fetchPopular() async {
    await DramaCool.popular().then((value) {
      data = value;
      popular = data;
      setState(() {});
    });
  }

  fetchSearchData(name) async {
    await DramaCool.fetchSearchData(name).then((value) {
      searchData = value;
      data = value;
      isSearching = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPopular();
    DramaCool.spotlight().then((value) => spotlight = value);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              isSearch = false;
              isSearching = false;
              toggelSearch = false;
              data = popular;
              _controller.clear();
              setState(() {});
            },
            child: Container(
              width: 175,
              child: const Stack(
                children: [
                  Text(
                    "D R A M A T I C",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Text(
                      "Beta!",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  )
                ],
              ),
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
      ),
      backgroundColor: const Color(0xFF17203A),
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
                          data = popular;
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
                                            height: 200,
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
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(8))),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 5),
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
                                pauseAutoPlayOnManualNavigate: true,
                                autoPlay: true,
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
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemExtent: 200,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => DetailsPage(data[index])));
                        },
                        child: Container(
                          width: screen.width,
                          height: screen.height * 0.1,
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
                                colorFilter:
                                    const ColorFilter.srgbToLinearGamma(),
                                scale: 1.5,
                                image: NetworkImage(data[index].image),
                                onError: (exception, stackTrace) {
                                  Container(
                                      color: Colors.amber,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Whoops!',
                                        style: TextStyle(fontSize: 15),
                                      ));
                                },
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 8, bottom: 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6)
                                    ],
                                  ),
                                  width: screen.width * 0.35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      data[index].image,
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
                              Container(
                                // decoration: BoxDecoration(border: Border.all(width: 10, color: Colors.black)),
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                width: 160,
                                child: Text(
                                  data[index].title,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
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
                                    fontSize: 20, fontWeight: FontWeight.bold))
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
    );
  }
}
