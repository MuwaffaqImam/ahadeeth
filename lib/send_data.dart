import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:seand_ahadeeth_to_firebase/data/Hadeeth.dart';

class SendShowAhadeeth extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Hadeeth> ahadeeth = [];

  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: title.isEmpty
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Column(
                      children: [
                        Text('$title'),
                        // FloatingActionButton.extended(
                        //   label: Text("Save to FireBase"),
                        //   onPressed: sendToFirebase,
                        //   icon: Icon(Icons.send),
                        // )
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ahadeeth.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              leading: Text(
                                  '${ahadeeth[index].hadeethBook} \n${ahadeeth[index].number}'),
                              title: Text(
                                '${ahadeeth[index].hadeeth}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                '${ahadeeth[index].tafseer}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("إفتح الأحاديث"),
        onPressed: loadCsvFromStorage,
        tooltip: 'Increment',
        icon: Icon(Icons.folder_open_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Hadeeth>> loadingCsvData(String path) async {
    final input = new File(path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter(eol: "\n"))
        .toList();
    print("check");
    fields.forEach((element) {
      if (element.length != 3) print("Falsssssssssssssssssseb1");
      ahadeeth.add(Hadeeth.fromList(element));
    });
    setState(() {
      title = path;
    });
    return ahadeeth;
  }

  loadCsvFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String? path = result!.files.first.path;
    loadingCsvData(path!);
  }

  void sendToFirebase() async {
    if (ahadeeth.isEmpty) return;
    CollectionReference ahadeethColection =
        FirebaseFirestore.instance.collection('Ahadeeth');
    ahadeeth.forEach((element) async {
      print('Adding hadeeth # ${element.hadeeth}');
      await ahadeethColection.add({
        'hadeeth': element.hadeeth,
        'number': element.number,
        'hadeethBook': element.hadeethBook,
        'tafseer': element.tafseer
      }).then((value) {
        print('Done adding hadeeth # ${element.hadeeth}');
      }).catchError((error) => print("Failed to add user: $error"));
    });
  }
}
