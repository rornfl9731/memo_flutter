import 'package:flutter/material.dart';
import 'package:memo/model/memo_list.dart';
import 'package:memo/screen/home_screen.dart';

import 'default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            MemoList(),
            Container(
              child: Center(
                child: Text("ㅁㅁㅁ"),
              ),
            ),
            Container(
              child: Center(
                child: Text("ㄴㄴㄴ"),
              ),
            ),
            Container(
              child: Center(
                child: Text("ㅇㅇㅇ"),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // selectedItemColor: ,
          // unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (int index){
            controller.animateTo(index);
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "To-Do",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: "캘린더",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "설정",
            ),
          ],
        )
    );
  }
}
