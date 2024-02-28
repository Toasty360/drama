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
  static String baseurl = "https://www.dramacool.pa";
  static Future<List<Drama>> popular() async {
    try {
      final Response v = await Dio().get("$baseurl/most-popular-drama",
          options: Options(headers: {
            "Access-Control-Allow-Origin": "*",
            "Referer": baseurl
          }));
      var doc = parse(v.data);

      List<Drama> items = [];

      for (Element e in doc.querySelectorAll(".list-episode-item > li")) {
        var id = e.querySelector("a")!.attributes["href"] ?? "";
        items.add(Drama(id, e.querySelector("h3")!.text, '$baseurl$id',
            e.querySelector("a > img")!.attributes["data-original"] ?? ""));
      }
      return items;
    } catch (e) {}
    return [];
  }

  static Future<List<Drama>> spotlight() async {
    final Response v =
        await Dio().get("https://valerien-api.vercel.app/drama/trending");

    List<Drama> items = [];
    v.data.forEach((e) {
      items.add(Drama(e["id"], e["title"], e["description"], e["image"]));
    });
    return items;
  }

  static Future<DramaDetails> fetchDetails(String id) async {
    print(id);
    id = id.startsWith("drama-detail") || id.startsWith("/drama-detail")
        ? id
        : "drama-detail/$id";
    String url = "https://toasty-kun.vercel.app/movies/dramacool/info?id=$id";

    final Response v = await Dio().get(url,
        options: Options(headers: {"Access-Control-Allow-Origin": "*"}));
    List<EpisodeDetails> epslist = [];
    for (Map e in v.data["episodes"]) {
      epslist.add(EpisodeDetails(e['id'], e['title'], e['episode'].toString(),
          e['releaseDate'], e['url']));
    }

    return DramaDetails(
        v.data['id'],
        v.data['title'],
        v.data['otherNames'],
        v.data['image'],
        v.data['description'].toString().replaceAll(RegExp(r'/\n/\b/\t'), ""),
        v.data['releaseDate'],
        epslist);
  }

  static Future<DramaDetails> fetchInfo(String id) async {
    id = id.startsWith("drama-detail") || id.startsWith("/drama-detail")
        ? id
        : "drama-detail/$id";
    print("$baseurl/$id");
    final Response v = await Dio().get("$baseurl/$id");
    var doc = parse(v.data);

    Map<String, dynamic> data = {};

    data["image"] = doc.querySelector(".img > img")?.attributes['src'];
    data["title"] = doc.querySelector(".info")?.querySelector("h1")?.text;

    data["otherNames"] = [];
    doc.querySelectorAll(".details .other_name > a").forEach((element) {
      data["otherNames"].add(element.text);
    });
    print(doc.querySelectorAll(".info > p").length);
    data["description"] = doc
        .querySelectorAll(".info > p")
        .where((paragraph) => !paragraph.querySelector('span')!.hasChildNodes())
        .map((paragraph) => paragraph.text)
        .toList()
        .join("\n");
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
            .toList(),
        doc.querySelector(".img > img")!.attributes["src"]!,
        doc.querySelector(".info > p:nth-child(4)")?.text ?? "",
        v.data['releaseDate'],
        data["episodes"]);
  }

  static Future<dynamic> fetchLinks(epsid) async {
    String url =
        "https://toasty-kun.vercel.app/movies/dramacool/watch?episodeId=$epsid";
    final Response v = await Dio().get(url,
        options: Options(headers: {"Access-Control-Allow-Origin": "*"}));
    return v.data["sources"];
  }

  static Future<List<Drama>> fetchSearchData(name) async {
    final Response v = await Dio().get(
        "https://toasty-kun.vercel.app/movies/dramacool/$name",
        options: Options(headers: {"Access-Control-Allow-Origin": "*"}));
    List<Drama> list = [];
    for (Map e in v.data["results"]) {
      list.add(Drama(e['id'], e['title'], e['url'], e['image']));
    }
    return list;
  }

  static Future<List<Drama>> fetchRecent() async {
    final Response v =
        await Dio().get("https://valerien-api.vercel.app/drama/recent");
    List<Drama> data = [];
    v.data.forEach((e) {
      var _item = Drama(e["id"], e["title"], e["time"], e["image"]);
      _item.epsnumber = e["epsNumber"].toString();
      data.add(_item);
    });
    return data;
  }
}
