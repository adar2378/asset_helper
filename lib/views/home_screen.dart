import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';

class HomeSreen extends StatefulWidget {
  @override
  _HomeSreenState createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen>
    with SingleTickerProviderStateMixin {
  var isSelected = <bool>[
    true,
    false,
  ];

  TextEditingController textEditingController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    inputController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Importing object: "),
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                          selectedIndex = buttonIndex;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  children: <Widget>[Text("Asset"), Text("Font")],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: <Widget>[
                Text("Location: "),
                Expanded(
                  child: TextField(
                    controller: inputController,
                    readOnly: true,
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    // final list = await dirContents(Directory("/Users/adar/development"));
                    // print(list[0].path);
                    try {
                      print("trying");
                      var result = await showOpenPanel(
                          initialDirectory: "/Users/adar",
                          canSelectDirectories: true);
                      print(result.paths);
                      inputController.text = result.paths[0];
                      getAlltheNames(result.paths[0]);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.file_upload),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Browse")
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(6)),
              child: SelectableText(textEditingController.value.text),
            ),
          ],
        ),
      ),
    );
  }

  void getAlltheNames(String sourcePath) {
    String result = "";
    var systemTempDir = Directory.fromUri(Uri.directory(sourcePath));

    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    systemTempDir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      // print(entity.path.substring(sourcePath.length + 1));
      if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.file) {
        if (selectedIndex == 0) {
          result += "- " + entity.path.substring(sourcePath.length + 1) + "\n";
        } else if (!entity.path.contains("zip")) {
          result +=
              "- asset: " + entity.path.substring(sourcePath.length + 1) + "\n";
        }

        textEditingController.text = result;

        setState(() {});
      }
    });
  }
}
