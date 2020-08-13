import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:soundpluguin/soundpluguin.dart';

enum _KeyType { Black, White }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Soundpluguin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onKeyDown(int key) {
    print('key down:$key');
    Soundpluguin.onKeyDown(key).then((value) => print(value));
  }

  void _onKeyUp(int key) {
    print('key up:$key');
    Soundpluguin.onKeyUp(key).then((value) => print(value));
  }

  Widget _makekey({@required _KeyType keyType, @required int key}) {
    return AnimatedContainer(
      height: 200,
      width: 44,
      duration: Duration(seconds: 2),
      curve: Curves.easeIn,
      child: Material(
        color: keyType == _KeyType.White
            ? Colors.white
            : Color.fromARGB(255, 60, 60, 80),
        child: InkWell(
          onTap: () => _onKeyUp(key),
          onTapDown: (details) => _onKeyDown(key),
          onTapCancel: () => _onKeyUp(key),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Piano'),
        ),
        backgroundColor: Colors.grey,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _makekey(keyType: _KeyType.White, key: 10),
                _makekey(keyType: _KeyType.Black, key: 61),
                _makekey(keyType: _KeyType.White, key: 30),
                _makekey(keyType: _KeyType.Black, key: 91),
                _makekey(keyType: _KeyType.White, key: 200),
                _makekey(keyType: _KeyType.Black, key: 100),
                _makekey(keyType: _KeyType.White, key: 66),
                _makekey(keyType: _KeyType.Black, key: 80),
                _makekey(keyType: _KeyType.White, key: 50),
                _makekey(keyType: _KeyType.Black, key: 69),
                _makekey(keyType: _KeyType.White, key: 20),
                _makekey(keyType: _KeyType.Black, key: 71),
              ],
            )
          ],
        )),
      ),
    );
  }
}
