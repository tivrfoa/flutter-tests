import 'dart:async';

import 'package:flutter/material.dart';
import 'src/article.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _articles = articles;
  Map<String, bool> tilesExpanded = new Map();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Builder(
          builder: (BuildContext context) {
            return new RefreshIndicator(
              onRefresh: () async {
                await new Future.delayed(const Duration(seconds: 1));
                setState(() {
                  _articles.removeAt(0);
                });
              },
              child: new ListView(
                children: _articles.map(_buildItem).toList(),
              ),
            );
          }
        ));
  }

  Widget _buildItem(Article e) {
    bool isExpanded = tilesExpanded.containsKey(e.text);
    return new Padding(
        key: Key(e.text),
        padding: const EdgeInsets.all(8.0),
        child: new ExpansionTile(
            onExpansionChanged: (expand) {
              controlExpansion(e.text);
            },
            initiallyExpanded: tilesExpanded.containsKey(e.text),
            title: new Text(e.text, style: new TextStyle(fontSize: 24.0)),
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text("${e.commentsCount} comments"),
                  new MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      launchURL("https://" + e.domain);
                    },
                    child: new Text("OPEN"),
                  )
                ],
              ),
            ]));
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  Widget _buildItem1(Article e) {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListTile(
            title: new Text(e.text, style: new TextStyle(fontSize: 24.0)),
            subtitle: new Text("${e.commentsCount} comments"),
            onTap: () async {
              String url = "https://" + e.domain;
              if (await canLaunch(url)) {
                launch(url);
              }
            }));
  }

  void toast(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  }

  void controlExpansion(String text) {
    if (tilesExpanded.remove(text) == null) {
      tilesExpanded.putIfAbsent(text, () => true);
    }
  }
}
