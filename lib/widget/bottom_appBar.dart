import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/theme.dart';

Widget bottomAppBar(BuildContext context) {
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
