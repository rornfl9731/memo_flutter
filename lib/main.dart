import 'package:flutter/material.dart';
import 'package:memo/screen/home_screen.dart';
import 'package:memo/screen/memo_detail.dart';
import 'package:memo/screen/root_tab.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/category.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter<Memo>(MemoAdapter());
  Hive.registerAdapter<Category>(CategoryAdapter());
  await Hive.openBox<Memo>('memo');
  await Hive.openBox<Category>('category');
  runApp(
    MaterialApp(
      // routes: {
      //   MemoDetail.routeName: (context) => MemoDetail(),
      // },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: RootTab(),
    ),
  );
}

