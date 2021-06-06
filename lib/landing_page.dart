import 'package:flutter/material.dart';

import 'ocr/presenntation/page/camera_page.dart';
import 'ocr/presenntation/page/library_page.dart';

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({Key key}) : super(key: key);

  @override
  _MyTabbedPageState createState() =>  _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  final keyCapture = GlobalKey();
  final keyLibrary = GlobalKey();


  final List<Tab> myTabs = <Tab>[
     Tab(text: 'CAPTURE'),
     Tab(text: 'LIBRARY'),
  ];
   List<Widget> _pages;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: 1);
    _pages= <Widget>[
      Container(
          child: CameraPage(
              controller: tabController, key: keyCapture,
          )),
      Container(child: LibraryPage(controller: tabController, key: keyLibrary,)),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(tabController.index != 0) {
          setState(() {
            tabController.index = 0;
          });
          return false;
        }
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              controller: tabController,
              tabs: myTabs,
              indicatorWeight: 5,
              indicatorColor: Colors.white,
              labelColor: Colors.white,

            ),
          ),
          body:  TabBarView(
            physics: NeverScrollableScrollPhysics(),
            key: RIKeys.riKey1,
            controller: tabController,
            children: _pages.map((Widget tab) {
              return tab;
            }).toList(),
          ),
          // floatingActionButton: new FloatingActionButton(
          //   onPressed: () =>
          //       tabController.animateTo((tabController.index + 1) % 2),
          //   // Switch tabs
          //   child: new Icon(Icons.swap_horiz),
          // ),
        ),
      ),
    );
  }
}


class RIKeys {
  static final riKey1 = const Key('__ENVISIONIKEY1__');
}
