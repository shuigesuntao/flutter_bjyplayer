import 'package:flutter/material.dart';
import 'package:flutter_bjyplayer/flutter_bjyplayer.dart';
import 'package:flutter_bjyplayer_example/player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // BjyDownloader().getAllDownloadInfo("2");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: Center(
        child: TextButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage())),
          child: Text("去播放页"),
        ),
      ),
    );
  }
}
