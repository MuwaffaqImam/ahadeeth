import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:seand_ahadeeth_to_firebase/firebase/fetch_data.dart';

import 'package:seand_ahadeeth_to_firebase/provider/theme.dart';
import 'package:seand_ahadeeth_to_firebase/widget/bottom_appBar.dart';

String searchText = '';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "أحاديث",
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
        ),
        body: SafeArea(
          child: Builder(builder: (context) {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  margin: EdgeInsets.all(8),
                  child: searchFiled(),
                ),
                Expanded(child: fetchData()),
              ],
            );
          }),
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: bottomAppBar(context));
        }),
      ),
    );
  }

  // search Filed user input widget
  Widget searchFiled() {
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
}
