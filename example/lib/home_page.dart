import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bjyplayer/flutter_bjyplayer.dart';
import 'package:flutter_bjyplayer_example/player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _token = "KHpaJXjgS3Py99ZztkR0KMk0y71zrbNYp7FIYOmg76U63lVNIDOJdg";
  var _videoId = "67487836";
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
        child: Column(
          children: [
            TextButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage())),
              child: Text("去播放页"),
            ),
            SizedBox(height: 50,),
            TextButton(
              onPressed: ()=> gotoNativeFullScreenPage(_videoId,_token),
              child: Text("去全屏页"),
            ),
          ],
        )
      ),
    );
  }


  void gotoNativeFullScreenPage(String videoId,String token) {
    //获取通道对象
    const nativePlugin = const MethodChannel('bjy_player');
    nativePlugin.invokeMethod('gotoFullScreenPage',{"videoId":videoId,"token":token});
  }
}
