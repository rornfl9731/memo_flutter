import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/category.dart';
import 'default_layout.dart';

class MemoDetail extends StatefulWidget {
  final int idx;
  var _selectedCategory;
  static const routeName = '/memo_detail';
  MemoDetail({Key? key, required this.idx}) : super(key: key);

  @override
  State<MemoDetail> createState() => _MemoDetailState();
}

class _MemoDetailState extends State<MemoDetail> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // Memo memo = ModalRoute.of(context)!.settings.arguments as Memo;
    // _titleController.text = memo.title;
    // _contentController.text = memo.content;
    Box<Memo> memo = Hive.box('memo');
    // Memo memos = memo.getAt(widget.idx) as Memo;
    widget._selectedCategory = memo.getAt(widget.idx)!.category;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //int idx = ModalRoute.of(context)!.settings.arguments as int;
    int idx = widget.idx;
    Box<Memo> memo = Hive.box('memo');
    Memo memos = memo.getAt(idx) as Memo;
    //Memo memo = Hive.box('memo').getAt(idx) as Memo;
    _titleController.text = memos.title;
    _contentController.text = memos.content;
    Box<Category> category = Hive.box('category');
    var _categories = category.values.toList();


    return DefaultLayout(
      title: "메모 작성",
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
                    print("변경");
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
              onPressed: () {
                Box<Memo> memo = Hive.box('memo');
                memo.putAt(
                    idx,
                    Memo(
                        title: _titleController.text,
                        content: _contentController.text,
                        dateTime: DateTime.now(),
                        category: widget._selectedCategory
                    ));

                // memo.add(Memo(
                //     title: _titleController.text,
                //     content: _contentController.text,
                //     dateTime: DateTime.now()));
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                Box<Memo> memo = Hive.box('memo');
                memo.add(Memo(
                    title: _titleController.text,
                    content: _contentController.text,
                    dateTime: DateTime.now()));
                Navigator.pop(context);
              },
              child: Text('삭제'),
            ),

          ],
        ),
      ),
    );
  }
}
