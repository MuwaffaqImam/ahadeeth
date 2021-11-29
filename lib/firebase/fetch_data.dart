import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:seand_ahadeeth_to_firebase/home_page.dart';
import 'package:seand_ahadeeth_to_firebase/widget/listview.dart';

Widget fetchData() {
  return PaginateFirestore(
    itemBuilderType: PaginateBuilderType.listView,
    itemBuilder: (context, documentSnapshots, index) {
      final data = documentSnapshots;
      if (searchText.isEmpty) {
        return listView(data);
      } else {
        final ahadeeth = data
            .where((element) => element['hadeeth'].contains(searchText))
            .toList();
        return listView(ahadeeth);
      }
    },
    query: FirebaseFirestore.instance.collection('Ahadeeth').orderBy('hadeeth'),
    isLive: true,
  );
}
