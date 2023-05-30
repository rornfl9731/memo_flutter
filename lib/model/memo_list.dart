import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memo/screen/default_layout.dart';
import 'package:memo/screen/memo_detail.dart';

import '../screen/home_screen.dart';
import 'category.dart';


class MemoList extends StatefulWidget {
  List<Memo> memos = [];
  var _selectedCategory;
  var a;
  MemoList({
    Key? key,
  }) : super(key: key);

  @override
  State<MemoList> createState() => _MemoListState();
}



class _MemoListState extends State<MemoList> {
  @override
  void initState() {
    // TODO: implement initState
    Box<Memo> memo = Hive.box('memo');
    // widget.memos = memo.values.toList();
    // Box<Category> category = Hive.box('category');
    // widget._selectedCategory = category.values.toList()[0];
    //loadData();

    super.initState();
    memo.watch().listen((event) {
      setState(() {
        widget.memos = memo.values.toList();
      });
  }
  );
  }

  // Future<void> loadData() async {
  //
  //   // 작업이 완료되면 상태 업데이트
  //   setState(() {
  //     Box<Memo> memo = Hive.box('memo');
  //     widget.memos = memo.values.toList();
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    print("build");
    Box<Memo> memo = Hive.box('memo');
    Box<Category> category = Hive.box('category');
    //widget.memos = memo.values.toList();
    widget.memos = memo.values.toList();
    var _categories = category.values.toList();
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )).then((res) => refreshPage());
        },
        child: Icon(Icons.add),
      ),
      title: "메모 리스트",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     //input category hive box
            //     //category.add(Category(name: "할일", memos: []));
            //     //category.add(Category(name: "약속", memos: []));
            //     // print(category.values.toList());
            //     // print(widget._selectedCategory.name);
            //     memo.deleteFromDisk();
            //     // category.deleteFromDisk();
            //     // category.deleteAt(2);
            //     // category.deleteAt(4);
            //
            //
            //
            //   },
            //   child: Text("카테고리 선택"),
            // ),

            //select category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: ElevatedButton(
                    child: Text("카테고리 생성"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("카테고리 생성"),
                              content: TextField(
                                onChanged: (value) {
                                  widget.a = value;
                                },
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("취소"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      category.add(Category(name: widget.a, memos: []));
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("확인"),
                                ),
                              ],
                            );
                          });
                    },
                  )
                ),
                Container(
                  child: DropdownButton(
                    hint: Text("카테고리 선택"),
                    value: widget._selectedCategory ,
                    onChanged: (newValue) {
                      setState(() {
                        widget._selectedCategory = newValue!;
                        print(widget._selectedCategory);

                        //widget.memos = memo.values.where((element) => element.category == widget._selectedCategory).toList();

                        //widget.memos.length;
                        //widget.memos = widget._selectedCategory.memos.toList();
                        // print(widget.memos[0].title+'--------set');
                        // print(widget.memos.length);
                        // setState(() {
                        //   widget.memos = memo.values.where((element) => element.category == widget._selectedCategory).toList();
                        //   //widget.memos = widget._selectedCategory.memos.toList();
                        //   print(widget.memos[0].title+'set');
                        // });

                      });
                    },
                    // items: _categories.map((Category category) {
                    //   return DropdownMenuItem<Category>(
                    //     value: category,
                    //     child: Text(category.name),
                    //   );
                    // }).toList(),
                    items: [
                      DropdownMenuItem(
                        value: 99,
                        child: Text("전체"),
                      ),
                      ..._categories.map((Category category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                //itemCount: widget._selectedCategory == null ? widget.memos.length : memo.values.where((element) => element.category == widget._selectedCategory).toList().length,
                itemCount: widget.memos.length,
                itemBuilder: (BuildContext context, int index) {
                  //print(widget.memos[0].title+'listView');
                  //print(widget._selectedCategory?.name);
                  if(widget._selectedCategory ==99 || widget._selectedCategory == null){
                    return GestureDetector(
                      onTap: () {
                        print(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemoDetail(
                                idx: index,
                              )),
                        ).then((res) => refreshPage());
                        //Navigator.pushNamed(context, '/memo_detail', arguments: index);
                      },
                      child: Card(
                        child: ListTile(
                          // title: Text(widget.memos[index].title ?? "제목 없음"),
                            title: Row(
                              children: [
                                Text(widget.memos[index].title),
                                SizedBox(width: 8),
                                Text(widget.memos[index].category?.name ?? "카테고리 없음"),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.memos[index].content.toString()),
                                SizedBox(width: 8),
                                Text(widget.memos[index].dateTime
                                    .toString()
                                    .substring(0, 10)),
                              ],
                            )),
                      ),
                    );
                  }
                  else if(widget._selectedCategory == widget.memos[index].category){
                    return GestureDetector(
                      onTap: () {
                        print(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemoDetail(
                                idx: index,
                              )),
                        ).then((res) => refreshPage());
                        //Navigator.pushNamed(context, '/memo_detail', arguments: index);
                      },
                      child: Card(
                        child: ListTile(
                          // title: Text(widget.memos[index].title ?? "제목 없음"),
                            title: Row(
                              children: [
                                Text(widget.memos[index].title),
                                SizedBox(width: 8),
                                Text(widget.memos[index].category?.name ?? "카테고리 없음"),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.memos[index].content.toString()),
                                SizedBox(width: 8),
                                Text(widget.memos[index].dateTime
                                    .toString()
                                    .substring(0, 10)),
                              ],
                            )),
                      ),
                    );
                  }
                  else{
                    return Container();
                  }


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  refreshPage() {
    setState(() {
      Box<Memo> memo = Hive.box('memo');
      // widget.memos = memo.values.toList();
    });
  }
}
