import 'package:Dramatic/pages/homePage.dart';
import 'package:Dramatic/pages/wrapper.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

import '../settings.dart';

class ActorDetails extends StatefulWidget {
  final Actor actor;
  const ActorDetails({super.key, required this.actor});

  @override
  State<ActorDetails> createState() => _ActorDetailsState();
}

class _ActorDetailsState extends State<ActorDetails> {
  late Actor actor = Actor(id: "");
  @override
  void initState() {
    super.initState();

    scraper.fetchActor(widget.actor.id).then((value) {
      actor = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(widget.actor.name!)),
      backgroundColor: Colors.black,
      body: SizedBox(
        width: screen.width,
        height: screen.height,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Container(
                  height: 250,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                          opacity: 0.9,
                          image: NetworkImage(widget.actor.image!))),
                ),
              ),
              ...renderReamining(actor, context),
            ]),
      ),
    );
  }
}

renderReamining(Actor actor, BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  return actor.id != ""
      ? [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              actor.name!,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: actor.otherNames!
                    .map((e) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.4))),
                          child: Text(e),
                        ))
                    .toList()
                    .cast<Widget>()),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Text(actor.dob!),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Text(actor.nationality!),
          ),
          const SizedBox(height: 10),
          header("Movies", null),
          myGrid(actor.movies!, screen, context),
          const SizedBox(height: 10)
        ]
      : [
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ];
}
