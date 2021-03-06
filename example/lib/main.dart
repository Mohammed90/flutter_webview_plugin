import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and then invoke "hot reload" (press "r" in the console where
        // you ran "flutter run", or press Run > Hot Reload App in IntelliJ).
        // Notice that the counter didn't reset back to zero -- the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  TextEditingController _ctrl =
      new TextEditingController(text: "https://flutter.io");
  StreamSubscription _onDestroy;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  initState() {
    super.initState();
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text("Webview Destroyed")));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onDestroy?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Plugin example app'),
      ),
      body: new Column(children: [
        new Container(
            padding: const EdgeInsets.all(24.0),
            child: new TextField(controller: _ctrl)),
        new RaisedButton(onPressed: _onPressed, child: new Text("Open Webview"))
      ], mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  void _onPressed() {
    try {
      flutterWebviewPlugin.launch(_ctrl.text);

      new Timer(const Duration(seconds: 10), () {
        flutterWebviewPlugin.close();
      });
    } catch (e) {
      print(e);
    }
  }
}
