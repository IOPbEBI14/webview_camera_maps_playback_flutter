import 'package:flutter/material.dart';

import 'my_shots_list_view.dart';
import 'my_camera_view.dart';

/// Displays a list of SampleItems.
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final Widget _myCameraView = const MyCameraView();
  final Widget _myShotsListView = const MyShotsListView();

  Widget getBody() {
    if (selectedIndex == 0) {
      return _myCameraView;
    } else {
      return _myShotsListView;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: "Camera",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: "Gallery",
          ),
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
