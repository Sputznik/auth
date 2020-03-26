import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class YkaSinglePost extends StatefulWidget {
  @override
  _YkaSinglePostState createState() => _YkaSinglePostState();
}

class _YkaSinglePostState extends State<YkaSinglePost> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['title'],
          style: TextStyle(
            fontSize: 16.0,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.red[900],
        titleSpacing: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            fit: BoxFit.cover,
            imageUrl: data['featured'],
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) {
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  data['title'],
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Html(
                  onLinkTap: (link) {
                    _launchURL(link);
                  },
                  data: data['content'],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(link) async {
    var destinationUrl = Uri.encodeFull(link);
    print(destinationUrl);
    await FlutterWebBrowser.openWebPage(
        url: destinationUrl, androidToolbarColor: Colors.red[900]);
  }
}
