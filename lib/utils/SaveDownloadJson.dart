import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveDownloadJson {
  static File jsonFile;
  static Directory dir;
  static String fileName = "download.json";
  static bool fileExists = false;

  static dynamic getIndexData() {
    if (fileExists) {
      final data = jsonDecode(jsonFile.readAsStringSync());
      if (data != null) {
        return data;
      }
    }

    return {};
  }

  static void setIndexData(String key, dynamic data) {}

  static Future<void> init() async {
    print(fileName);
    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + "/" + fileName);

    fileExists = jsonFile.existsSync();
    // if (fileExists) await jsonFile.delete();
    // fileExists = false;
    // if (fileExists) this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
  }

  static void createFile(dynamic content, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  static void writeToFile(dynamic value) {
    print("Writing to file!");
    dynamic content = {
      "save": [value]
    };

    if (fileExists) {
      print("File exists");
      content = jsonDecode(jsonFile.readAsStringSync());
      for (int i = 0; i < content["save"].length; i++) {
        if (content["save"][i]["name"].toString().compareTo(value["name"]) == 0) {
          content["save"].removeAt(i);
          break;
        }
      }
      content["save"].insert(0, value);
      dynamic jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, fileName);
    }
    // this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
    // print(jsonDecode(jsonFile.readAsStringSync()));
  }
}
