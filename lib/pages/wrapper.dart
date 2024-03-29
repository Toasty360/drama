// ignore_for_file: prefer_const_constructors

import 'package:Dramatic/components/detailsPage.dart';
import 'package:Dramatic/pages/homePage.dart';
import 'package:Dramatic/pages/profilePage.dart';
import 'package:Dramatic/pages/recentPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import '../settings.dart';

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
  int pindex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: [
        HomePage(
          scraper: scraper,
          spotlight: widget.spotlight,
          popular: widget.popular,
        ),
        RecentPage(recent: widget.recent),
        ProfilePage()
      ][pindex],
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.blueGrey,
              iconTheme: MaterialStatePropertyAll(
                  IconThemeData(color: Colors.white70)),
              labelTextStyle: MaterialStatePropertyAll(
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child: NavigationBar(
            backgroundColor: Colors.black,
            height: 65,
            selectedIndex: pindex,
            onDestinationSelected: (value) {
              setState(() {
                pindex = value;
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.watch_later_sharp), label: "Recent"),
              NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
            ],
          )),
    );
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

header(String text, Widget? clear) {
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
                color: Color.fromARGB(255, 229, 223, 223))),
        Spacer(),
        clear ?? const Center()
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
                            Color.fromARGB(16, 0, 0, 0),
                            Color.fromARGB(255, 0, 0, 0),
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
              ))
          .cast<Widget>()
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        autoPlay: true,
      ));
}


// myCardList(List<Drama> data, Size screen) {
//   return SizedBox(
//     height: 250,
//     child: ListView.builder(
//       padding: const EdgeInsets.only(left: 10, top: 10),
//       shrinkWrap: true,
//       scrollDirection: Axis.horizontal,
//       itemCount: data.length,
//       itemBuilder: (context, index) => InkWell(
//         onTap: () => Navigator.push(context,
//             MaterialPageRoute(builder: (ctx) => DetailsPage(data[index]))),
//         child: Container(
//           width: 175,
//           padding: const EdgeInsets.only(left: 10),
//           child: Stack(children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: ExtendedNetworkImageProvider(data[index].image!,
//                         headers: {"Referer": "https://asianwiki.co"},
//                         cache: true),
//                     fit: BoxFit.cover,
//                   )),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               alignment: Alignment.bottomCenter,
//               height: double.maxFinite,
//               width: double.maxFinite,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   gradient: const LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color.fromARGB(16, 0, 0, 0),
//                         Color.fromARGB(189, 0, 0, 0),
//                       ])),
//               child: Text(
//                 data[index].title!,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w800, color: Colors.white),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     ),
//   );
// }



// Container(
//         alignment: Alignment.center,
//         width: screen.width,
//         height: screen.height,
//         child: ListView(
//           shrinkWrap: true,
//           scrollDirection: Axis.vertical,
//           physics: ClampingScrollPhysics(),
//           children: recent.isNotEmpty
//               ? [
//                   isSearch
//                       ? Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 20),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                               color: Colors.blue.shade800,
//                               borderRadius: BorderRadius.circular(12)),
//                           child: TextField(
//                               onSubmitted: (value) {
//                                 mysnack(scraper.search(value, "1"), context);
//                               },
//                               decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   prefixIcon: Icon(Icons.search))),
//                         )
//                       : const Center(),
//                   trendingCards(context, spotlight, screen),
//                   header("Popular"),
//                   myCardList(popular, screen),
//                   header("Recent"),
//                   recentCards(recent, screen)
//                 ]
//               : [
//                   Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 ],
//         ),
//       ),