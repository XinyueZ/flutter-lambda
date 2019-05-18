import 'package:flutter/material.dart';

import 'image_app_page.dart';

class ImageAppPager extends StatefulWidget {
  final String _title;

  ImageAppPager(this._title, {Key key}) : super(key: key);

  @override
  _ImageAppPagerState createState() => _ImageAppPagerState();
}

class _ImageAppPagerState extends State<ImageAppPager> {
  int _selectedIndex = 0;
  PageView _pageView = null;

  PageView _initPageView() {
    _pageView = PageView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ImageAppPage(index: index));
    return _pageView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 15,
        title: Text(widget._title),
      ),
      body: _initPageView(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_left),
            title: Text("Backward"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_right),
            title: Text("Forward"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        // For the 0.page(first page), ignore.
        if (_pageView.controller.page < 1) {
          debugPrint("to page, ignore on first page");
          return;
        }
        _backwardPager(Duration(milliseconds: 200), SawTooth(5));
      } else {
        _forwardPager(Duration(milliseconds: 200), SawTooth(5));
      }
    });
  }

  void _forwardPager(Duration duration, Curve curve) {
    int toPage = (_pageView.controller.page + 1.0).toInt();

    _pageView.controller.nextPage(duration: duration, curve: curve);

    debugPrint("to page $toPage");
  }

  void _backwardPager(Duration duration, Curve curve) {
    int toPage = (_pageView.controller.page - 1.0).toInt();

    _pageView.controller.previousPage(duration: duration, curve: curve);

    debugPrint("to page $toPage");
  }
}
