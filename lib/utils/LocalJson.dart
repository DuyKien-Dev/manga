import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalJson {
  static File jsonFile;
  static Directory dir;
  static String fileName = "";
  static bool fileExists = false;

  static dynamic getIndexData(String key) {
    final data = jsonDecode(jsonFile.readAsStringSync());
    if (data["data"] != null) {
      return data["data"];
    }
    return [];
  }

  static void setIndexData(String key, dynamic data) {}

  static Future<void> init(String name) async {
    fileName = name + ".json";
    print(fileName);
    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + "/" + fileName);

    fileExists = jsonFile.existsSync();
    // if (fileExists) await jsonFile.delete();
    // fileExists = false;
    // if (fileExists) this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
  }

  static void createFile(dynamic content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  static void writeToFile(dynamic value) {
    print("Writing to file!");
    dynamic content = {"data": value};

    if (fileExists) {
      print("File exists");
      dynamic jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    // this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
    // print(jsonDecode(jsonFile.readAsStringSync()));
  }
}
