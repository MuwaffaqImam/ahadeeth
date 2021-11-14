import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:seand_ahadeeth_to_firebase/them_provider.dart';
import 'package:url_launcher/url_launcher.dart';

String searchText = '';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<dynamic> ahadeeth = [];
  var cardColor = Color.fromRGBO(252, 245, 218, 1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', ''),
      ],
      home: buildScaffold(),
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "أحاديث",
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              margin: EdgeInsets.all(8),
              child: buildSearchFiled(),
            ),
            getDataFromFirebase(),
          ],
        );
      }),
      bottomNavigationBar: Builder(builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: buildBottomAppBar());
      }),
    );
  }

  Widget buildSearchFiled() {
    return TextField(
      decoration: InputDecoration(
        fillColor: Provider.of<ThemeProvider>(context).getTheme() == darkMode
            ? Colors.black45
            : cardColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60.0),
          borderSide: BorderSide(width: 3),
        ),
        hintText: "بحث",
        hintStyle: TextStyle(fontSize: 20),
        prefixIcon: Icon(Icons.search, size: 25),
      ),
      onChanged: (value) => setState(() => searchText = value),
    );
  }

  // Get data from firebase
  Widget getDataFromFirebase() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Ahadeeth').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            ahadeeth = docs;
            print('ok good retrieve data from firebase!!!!!!!!!!!!');
            return searchAhadeeth();
          }

          return CircularProgressIndicator();
        });
  }

  // search function in ahadeeth
  Widget searchAhadeeth() {
    if (searchText.isEmpty) {
      return buildListView();
    } else {
      final result =
          ahadeeth.where((res) => res['hadeeth'].contains(searchText)).toList();
      ahadeeth = result;
      return buildListView();
    }
  }

  // List view widget
  Widget buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: ahadeeth.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 7, right: 7),
            child: ListTile(
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '${ahadeeth[index]['hadeeth']}',
                        // maxLines: 3,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8),
                    //   child: Text(
                    //     '${ahadeeth[index]['tafseer']}',
                    //     maxLines: 3,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: TextStyle(fontSize: 20, fontFamily: 'Tajawal'),
                    //     textAlign: TextAlign.justify,
                    //   ),
                    // ),
                    Divider(),
                  ]),
              subtitle: Text(
                '${ahadeeth[index]['hadeethBook']} \\ ${ahadeeth[index]['number']}',
                style: TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
              ),
            ),
          );
        },
      ),
    );
  }

  // Bottom appBar widget.
  Widget buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            child: Icon(Icons.brightness_4, size: 30),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
          ),
          InkWell(
            child: Icon(Icons.star_rate, size: 34, color: Colors.amber),
            onTap: () {
              _launchURL();
            },
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    var url;
    if (Platform.isAndroid) url = 'https://play.google.com/store/apps/';
    if (Platform.isIOS) url = 'https://apps.apple.com/us/app/apple-store/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
