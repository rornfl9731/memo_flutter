import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memo/model/memo_list.dart';
import 'package:memo/screen/default_layout.dart';

import '../model/category.dart';

class HomeScreen extends StatefulWidget {
  final String? title;
  var _selectedCategory;
  HomeScreen({Key? key, this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box<Category> category = Hive.box('category');
    Box<Memo> memo = Hive.box('memo');
    var _categories = category.values.toList();

    return DefaultLayout(
        title: "메모 작성",
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: DropdownButton<Category>(
                    hint: Text("카테고리 선택"),
                    value: widget._selectedCategory ,
                    onChanged: (newValue) {
                      setState(() {
                        widget._selectedCategory = newValue!;
                      });
                    },
                    items: _categories.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '여기에 제목을 입력하세요',
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: TextField(
                      controller: _contentController,
                      maxLines: 15,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '여기에 메모를 입력하세요',
                      )),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 50)),
                  onPressed: () async {
                    Box<Memo> memo = Hive.box('memo');
                    await memo.add(Memo(
                      title: _titleController.text,
                      content: _contentController.text,
                      dateTime: DateTime.now(),
                      category: widget._selectedCategory,
                    ));
                    // Box<Category> category = Hive.box('category');
                    // print(widget._selectedCategory.name);
                    // print(await category.values.where((element) => element == widget._selectedCategory).toList()[0].key);
                    // category.put(category.values.where((element) => element == widget._selectedCategory).toList()[0].key,
                    //     Category(
                    //       name: widget._selectedCategory.name,
                    //       memos: category.values.where((element) => element == widget._selectedCategory).toList()[0].memos..add(Memo(
                    //         title: _titleController.text,
                    //         content: _contentController.text,
                    //         dateTime: DateTime.now(),
                    //         category: widget._selectedCategory,
                    //       )),
                    //     ),
                    // );

      //               await category.put(
      // 1,
      //                   Category(
      //                     name: widget._selectedCategory.name,
      //                     memos: [
      //                       Memo(
      //                         title: _titleController.text,
      //                         content: _contentController.text,
      //                         dateTime: DateTime.now(),
      //                         category: widget._selectedCategory,
      //                       )],
      //                   ),
      //
      //               );
                    Navigator.pop(context);
                  },
                  child: Text('저장하기'),
                ),
              ],
            ),
          ),
        ));
  }
}
