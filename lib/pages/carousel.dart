import 'package:Dramatic/pages/dramaDetailsPage.dart';
import 'package:extractor/model.dart';
import 'package:flutter/material.dart';

class TrendingCards extends StatelessWidget {
  final List<Drama> trending;
  final CarouselController _carouselController = CarouselController();

  TrendingCards({super.key, required this.trending});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      width: screen.width,
      height: 250,
      child: CarouselView(
        controller: _carouselController,
        itemExtent: screen.width,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Details(trending[index])),
          );
        },
        itemSnapping: true,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        elevation: 0,
        children: trending.map((e) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(e.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(16, 0, 0, 0),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                  ),
                  child: Text(
                    e.title!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
