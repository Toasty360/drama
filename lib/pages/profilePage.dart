import 'package:Dramatic/components/Player.dart';
import 'package:Dramatic/pages/homePage.dart';
import 'package:Dramatic/pages/wrapper.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentHour = DateTime.now().hour;
  final laterBox = WatchList.hive;
  final lefover = LeftOver.hive;
  final constants = Constants.hive;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: screen.width,
        height: screen.height,
        child: ListView(padding: const EdgeInsets.only(top: 60), children: [
          Container(
            width: screen.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.2,
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2825&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              ListTile(
                title: Text(
                  currentHour >= 5 && currentHour < 12
                      ? "Good morning!"
                      : currentHour >= 12 && currentHour < 17
                          ? "Good afternoon!"
                          : "Good evening!",
                  style: const TextStyle(color: Colors.green),
                ),
                trailing: const Text("Valarien~"),
              ),
              SizedBox(
                height: 100,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      colcard("WatchList", laterBox.length.toString()),
                      const VerticalDivider(),
                      colcard("Total Minutes Spent",
                          constants.get("duration").toString()),
                    ]),
              )
            ]),
          ),
          header(
              "History",
              TextButton(
                  onPressed: () {
                    setState(() {
                      lefover.clear();
                    });
                  },
                  child: const Text("Clear?"))),
          Center(
            child: ValueListenableBuilder<Box<Episode>>(
              valueListenable: lefover.listenable(),
              builder: (context, box, _) {
                return box.isNotEmpty
                    ? myhistory(box.values.toList().reversed.toList(), context)
                    : nodata();
              },
            ),
          ),
          header(
              "WatchList",
              TextButton(
                  onPressed: () {
                    setState(() {
                      laterBox.clear();
                    });
                  },
                  child: const Text("Clear?"))),
          Center(
            child: ValueListenableBuilder<Box<Drama>>(
              valueListenable: laterBox.listenable(),
              builder: (context, box, _) {
                return box.isNotEmpty
                    ? myGrid(box.values.toList(), screen, context)
                    : nodata();
              },
            ),
          ),
        ]),
      ),
    );
  }
}

nodata() {
  return Container(
    alignment: Alignment.center,
    child: const Text(
      "~ No Data Yet ~",
      style: TextStyle(color: Colors.blueGrey),
    ),
  );
}

colcard(String title, String data) {
  return Expanded(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
      ),
      Text(
        data,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.blueGrey),
      )
    ],
  ));
}

myhistory(List<Episode> data, BuildContext context) {
  return Container(
    height: 100,
    padding: const EdgeInsets.only(left: 20),
    margin: const EdgeInsets.only(top: 10),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: data
          .map((e) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPlayer(episode: e),
                    )),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(e.image!),
                          fit: BoxFit.cover,
                          opacity: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(225, 31, 33, 35)),
                  width: 150,
                  child: Text(
                    e.name!.contains("Episode")
                        ? e.name!
                        : "${e.name!}\n${RegExp(r"episode-(\d+)").firstMatch(e.id!)!.group(0)!}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
          .toList()
          .cast<Widget>(),
    ),
  );
}
