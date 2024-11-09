import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

const String baseURL = "https://asianc.co/";
final key = encrypt.Key.fromBase64(
    base64.encode(utf8.encode("93422192433952489752342908585752")));
final iv =
    encrypt.IV.fromBase64(base64.encode(utf8.encode("9262859232435825")));
String _decryptAES(String encryptedText) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
  return decrypted;
}

String _encryptAES(String text) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}

Future<Map> _generateM3U8(String hash) async {
  var data2 = _decryptAES(hash);
  var data3 = data2.substring(0, data2.indexOf("&"));
  var params =
      "id=${Uri.encodeComponent(_encryptAES(data3))}${data2.substring(data2.indexOf("&"))}&${Uri.encodeComponent(data3)}";
  var resp = await Dio().get("https://pladrac.net/encrypt-ajax.php?$params");
  return jsonDecode(_decryptAES(jsonDecode(resp.data)["data"]));
}

Future<Map> fetchSource(String id) async {
  var resp = await Dio().get("$baseURL$id");
  var url =
      "https:${RegExp(r'data-video="(.*?)"').firstMatch(resp.data)!.group(1)!}";
  var resp1 = await Dio().get(url);
  var hash = RegExp(r'data-value="(.*?)"').firstMatch(resp1.data)!.group(1);
  return await _generateM3U8(hash!);
}
