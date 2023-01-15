import 'dart:convert';
import 'dart:html';

Future<String> download(String body, String name) async {
  print("downloading in web $name");
  final content = base64Encode(body.codeUnits);
  final _ = AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    ..setAttribute("download", name)
    ..download = name
    ..click();
  return null;
}