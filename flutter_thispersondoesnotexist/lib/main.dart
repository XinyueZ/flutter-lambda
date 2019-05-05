import 'package:flutter/material.dart';

const String imgSrc = "https://thispersondoesnotexist.com/image?index=";
const String placeholderSrc = "https://via.placeholder.com/200x200/";

void main() => runApp(ImageApp());

class ImageApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "These persons don't exist",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageAppPage(title: "These persons don't exist"),
    );
  }
}

class ImageAppPage extends StatefulWidget {
  ImageAppPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ImageAppPageState createState() => _ImageAppPageState();
}

class _ImageAppPageState extends State<ImageAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(100, (index) {
          DateTime now = new DateTime.now();
          final stack = Stack(
            children: <Widget>[
              Center(
                  child: Image.network(
                placeholderSrc,
              )),
              Center(
                child: Image.network(
                  imgSrc,
                  headers: {
                    "accept":
                        "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
                    "accept-encoding": "gzip, deflate, br",
                    "accept-language":
                        "de-DE,de;q=0.9,en-GB;q=0.8,en;q=0.7,zh-CN;q=0.6,zh;q=0.5,en-US;q=0.4",
                    "cache-control": "max-age=0",
                    "dnt": "1",
                    "upgrade-insecure-requests": "1",
                    "if-modified-since": "Sat, 04 May 2019 23:14:04 GMT",
                    "if-none-match": "W/\"5cce1cbc-fa4d4\"",
                    "user-agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"
                  },
                ),
              ),
            ],
          );
          return stack;
        }),
      ),
    );
  }
}
