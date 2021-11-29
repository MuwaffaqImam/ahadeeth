import 'dart:ui';

import 'package:flutter/material.dart';

Widget listView(List ahadeeth) {
  return ListView.builder(
    itemCount: ahadeeth.length,
    shrinkWrap: true,
    physics: ScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        child: ListTile(
          title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            Divider(),
          ]),
          subtitle: Text(
            '${ahadeeth[index]['hadeethBook']} \\ ${ahadeeth[index]['number']}',
            style: TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
          ),
        ),
      );
    },
  );
}
