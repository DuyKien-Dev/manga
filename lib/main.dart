
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english/screens/splash/SplashScreen.dart';
import 'package:english/utils/PreferencesUtil.dart';

void main() async {
  runApp(MyApp());
  await PreferencesUtil.setup();
  if (PreferencesUtil.getPreferences("server").length == 0) {
    PreferencesUtil.setPreferences("server", "Mangafox");
  }
}

class MyApp extends StatelessWidget {
  static const platform = const MethodChannel('samples.flutter.dev');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      // home: MyDrawer(),
    );
  }
}

// import 'dart:core';

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:convert'; //to convert json to maps and vice versa
// import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file

// void main() {
//   runApp(new MaterialApp(
//     home: new Home(),
//   ));
// }

// class Home extends StatefulWidget {
//   @override
//   State createState() => new HomeState();
// }

// class HomeState extends State<Home> {
//   TextEditingController keyInputController = new TextEditingController();
//   TextEditingController valueInputController = new TextEditingController();

//   File jsonFile;
//   Directory dir;
//   String fileName = "my1JSONFile.json";
//   bool fileExists = false;
//   Map<String, String> fileContent;

//   @override
//   void initState() {
//     super.initState();
//     getApplicationDocumentsDirectory().then((Directory directory) {
//       dir = directory;
//       jsonFile = new File(dir.path + "/" + fileName);
//       jsonFile.delete();
//       fileExists = jsonFile.existsSync();
//       if (fileExists) this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
//     });
//   }

//   @override
//   void dispose() {
//     keyInputController.dispose();
//     valueInputController.dispose();
//     super.dispose();
//   }

//   void createFile(dynamic content, Directory dir, String fileName) {
//     print("Creating file!");
//     File file = new File(dir.path + "/" + fileName);
//     file.createSync();
//     fileExists = true;
//     file.writeAsStringSync(jsonEncode(content));
//   }

//   void writeToFile(String key, String value) {
//     print(dir);
//     print("Writing to file!");
//     dynamic content = [
//       {key: value},
//       {key: value},
//       {key: value}
//     ];
//     if (fileExists) {
//       print("File exists");
//       dynamic jsonFileContent = json.decode(jsonFile.readAsStringSync());
//       jsonFileContent.addAll(content);
//       jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
//     } else {
//       print("File does not exist!");
//       createFile(content, dir, fileName);
//     }
//     // this.setState(() => fileContent = jsonDecode(jsonFile.readAsStringSync()));
//     print(jsonDecode(jsonFile.readAsStringSync()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("JSON Tutorial"),
//       ),
//       body: new Column(
//         children: <Widget>[
//           new Padding(padding: new EdgeInsets.only(top: 10.0)),
//           new Text(
//             "File content: ",
//             style: new TextStyle(fontWeight: FontWeight.bold),
//           ),
//           new Text(fileContent.toString()),
//           new Padding(padding: new EdgeInsets.only(top: 10.0)),
//           new Text("Add to JSON file: "),
//           new TextField(
//             controller: keyInputController,
//           ),
//           new TextField(
//             controller: valueInputController,
//           ),
//           new Padding(padding: new EdgeInsets.only(top: 20.0)),
//           new RaisedButton(
//             child: new Text("Add key, value pair"),
//             onPressed: () => writeToFile(keyInputController.text, valueInputController.text),
//           )
//         ],
//       ),
//     );
//   }
// }
