import 'package:flutter/material.dart';

import 'image_app_page.dart';
import 'viewmodel/image_app_page_view_model.dart';
import 'viewmodel/image_app_pager_view_model.dart';

class ImageAppPager extends StatefulWidget {
  final String _title;

  ImageAppPager(this._title, {Key key}) : super(key: key);

  @override
  _ImageAppPagerState createState() => _ImageAppPagerState();
}

const BACKWARD = 0;
const FORWARD = 1;
const PAGE_DURATION = Duration(milliseconds: 200);
const PAGE_SAWTOOTH = SawTooth(10);

class _ImageAppPagerState extends State<ImageAppPager> {
  PageView _pageView;
  final ImageAppPagerViewModel _viewModel = ImageAppPagerViewModel();

  PageView _initPageView() {
    _pageView = PageView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ImageAppPage(ImageAppPageViewModel(), index: index));
    return _pageView;
  }

  void _showAboutPopup() async {
    // flutter defined function
    final aboutList = await _viewModel.getAboutList(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("About"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: aboutList,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 15,
          title: Text(widget._title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                _showAboutPopup();
              },
            )
          ],
        ),
        body: _initPageView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _toHome();
          },
          child: Icon(Icons.home),
          backgroundColor: Colors.blueAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Builder(
          builder: (cxt) => BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    title: SizedBox(width: 0.0, height: 0.0),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    title: SizedBox(width: 0.0, height: 0.0),
                  ),
                ],
                currentIndex: 0,
                selectedItemColor: Colors.black,
                backgroundColor: Colors.black,
                onTap: (index) {
                  _onItemTapped(cxt, index);
                },
              ),
        ));
  }

  void _onItemTapped(BuildContext cxt, int index) {
    setState(() {
      switch (index) {
        case BACKWARD:
          // For the 0.page(first page), ignore.
          if (_pageView.controller.page < 1) {
            final SnackBar snackBar = const SnackBar(
              content: Text("Already at homepage 👌"),
              duration: Duration(milliseconds: 500),
            );
            Scaffold.of(cxt).showSnackBar(snackBar);
            return;
          }
          _backwardPager();
          return;
        case FORWARD:
          _forwardPager();
          return;
      }
    });
  }

  void _forwardPager(
      {Duration duration = PAGE_DURATION, Curve curve = PAGE_SAWTOOTH}) {
    int toPage = (_pageView.controller.page + 1.0).toInt();

    _pageView.controller.nextPage(duration: duration, curve: curve);

    debugPrint("to page $toPage");
  }

  void _toHome() {
    int toPage = 0;

    _pageView.controller.jumpTo(toPage.toDouble());

    debugPrint("to page $toPage");
  }

  void _backwardPager(
      {Duration duration = PAGE_DURATION, Curve curve = PAGE_SAWTOOTH}) {
    int toPage = (_pageView.controller.page - 1.0).toInt();

    _pageView.controller.previousPage(duration: duration, curve: curve);

    debugPrint("to page $toPage");
  }
}
