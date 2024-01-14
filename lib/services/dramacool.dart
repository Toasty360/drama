// const fetchTrending = async () => {
//   const url = "https://dramacool.hr/most-popular-drama";
//   const data = await axios.request({
//     method: "GET",
//     url: url,
//     headers: headers,
//   });
//   var $ = cheerio.load(data.data);
//   var recentData = [];
//   $(".list-episode-item")
//     .children()
//     .map((i, ele) => {
//       recentData.push({
//         title: $(ele).find("h3").text(),
//         id: $(ele).find("a").attr("href"),
//         image: $(ele).find("img").attr("src"),
//       });
//     });
//   console.log(recentData);
// };

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '/model/drama.dart';

class DramaCool {
  static Future<List<Drama>> popular() async {
    final Response v =
        await Dio().get("https://dramacool.hr/most-popular-drama");
    var doc = parse(v.data);

    List<Drama> items = [];

    for (Element e in doc.querySelectorAll(".list-episode-item > li")) {
      var id = e.querySelector("a")!.attributes["href"] ?? "";
      items.add(Drama(
          id,
          e.querySelector("h3")!.text,
          'https://dramacool.hr$id',
          e.querySelector("a > img")!.attributes["data-original"] ?? ""));
    }
    print(items.length);
    print(items[0].image);
    return items;
  }

  static Future<List<Drama>> spotlight() async {
    final Response v = await Dio().get("https://dramacool.pa/");
    var doc = parse(v.data);
    List<Drama> items = [];
    for (Element e in doc.querySelectorAll(".ls-slide")) {
      items.add(Drama(
          e.querySelector("a")!.attributes["href"]!.split("/").last,
          e.querySelector("img")!.attributes["title"]!,
          "",
          e.querySelector("img")!.attributes["src"]!));
    }
    return items;
  }

  static Future<DramaDetails> fetchDetails(String id) async {
    print(id);
    id = id.startsWith("drama-detail") || id.startsWith("/drama-detail")
        ? id
        : "drama-detail/$id";
    print("/movies/dramacool/info?id=$id");
    String url = "https://toasty-kun.vercel.app/movies/dramacool/info?id=$id";

    final Response v = await Dio().get(url);
    List<EpisodeDetails> epslist = [];
    for (Map e in v.data["episodes"]) {
      epslist.add(EpisodeDetails(e['id'], e['title'], e['episode'].toString(),
          e['releaseDate'], e['url']));
    }

    return DramaDetails(
        v.data['id'],
        v.data['title'],
        v.data['otherNames'].toString().replaceAll(RegExp(r'\]\['), ""),
        v.data['image'],
        v.data['description'].toString().replaceAll(RegExp(r'/\n/\b/\t'), ""),
        v.data['releaseDate'],
        epslist);
  }

  static Future<DramaDetails> fetchInfo(String id) async {
    print(id);
    final Response v = await Dio().get("https://dramacool.pa/$id");
    var doc = parse(v.data);
    // List<EpisodeDetails> eps = [];
    Map<String, dynamic> data = {};

    data["image"] = doc.querySelector(".img > img")?.attributes['src'];
    data["title"] = doc.querySelector(".info")?.querySelector("h1")?.text;

    data["otherNames"] = [];
    doc.querySelectorAll(".details .other_name > a").forEach((element) {
      data["otherNames"].add(element.text);
    });

    data["description"] = doc.querySelector(".info > p:nth-child(4)")?.text;
    data["status"] = doc.querySelector(".info > p:nth-child(6) > a")?.text;
    data["year"] = doc.querySelector(".info > p:nth-child(7) > a")?.text;

    data["genre"] = [];
    doc.querySelectorAll(".info > p:nth-child(16) > a").forEach((element) {
      data["genre"].add(element.text);
    });

    data["episodes"] = [];
    doc
        .querySelectorAll(
            "div.content-left > div.block-tab > div > div > ul > li")
        .forEach((element) {
      var el = element as Element;

      data["episodes"].add({
        'id': el
            .querySelector("a")!
            .attributes['href']!
            .split("/")
            .last
            .split(".html")
            .first,
        'title': el
            .querySelector("h3")!
            .text
            .replaceFirst(data["title"] ?? '', '')
            .trim(),
        'episode': double.parse(el
            .querySelector("a")!
            .attributes['href']!
            .split("-episode-")
            .last
            .split(".html")
            .first
            .replaceAll('-', '.')),
        'subType': el.querySelector("span.type")?.text,
        'releaseDate': el.querySelector("span.time")?.text,
        'url': el.querySelector("a")?.attributes['href'],
      });
    });
    print(data);
    return DramaDetails(
        id,
        doc.querySelector(".info > h1")!.text,
        doc
            .querySelectorAll(".other_name > a")
            .map((element) => element.text)
            .toString(),
        doc.querySelector(".img > img")!.attributes["src"]!,
        doc.querySelector(".info > p:nth-child(4)")?.text ?? "",
        v.data['releaseDate'],
        data["episodes"]);
  }

  static Future<dynamic> fetchLinks(epsid, movieid) async {
    // https://api.consumet.org/movies/dramacool/watch?episodeId=duty-after-school-2023-episode-1&mediaId=drama-detail/duty-after-school
    print(epsid);
    String url =
        "https://toasty-kun.vercel.app/movies/dramacool/watch?episodeId=$epsid";
    print(url);
    final Response v = await Dio().get(url);
    print(v.statusCode);
    return v.data["sources"];
  }

  static Future<List<Drama>> fetchSearchData(name) async {
    // https://api.consumet.org/movies/dramacool/shadow-detective-season-2
    final Response v =
        await Dio().get("https://toasty-kun.vercel.app/movies/dramacool/$name");
    List<Drama> list = [];
    for (Map e in v.data["results"]) {
      list.add(Drama(e['id'], e['title'], e['url'], e['image']));
    }
    return list;
  }
}

// text().replace(/\n/g, "").trim(),
