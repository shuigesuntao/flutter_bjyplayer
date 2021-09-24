import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bjyplayer/flutter_bjyplayer.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with BjyPlayerListener {
  BjyPlayerController _playerController = BjyPlayerController();
  var _token = "KHpaJXjgS3Py99ZztkR0KMk0y71zrbNYp7FIYOmg76U63lVNIDOJdg";
  var _videoId = "67487836";
  var _currentIndex = 0;
  var _isFullScreen = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((value) => _init());
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async{
          await _playerController.tryOpenFloatViewPlay();
      return true;
    },
    child:Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Visibility(
          visible: !_isFullScreen,
          child: AppBar(
            centerTitle: true,
            title: Text("百家云Demo"),
          )
        ),
      ),
      body: Column(
        children: [
          Container(
              width: width,
              height: min(MediaQuery.of(context).size.height,width/16*9),
              child: BjyPlayerView(controller: _playerController)
          ),
          Expanded(child: Visibility(
            visible: !_isFullScreen,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text("共15个课时",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12)),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 4,
                          child:ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              value: 0 / 100,
                              backgroundColor: Colors.grey[100],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Text("已学习67%",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[400]),
                Expanded(
                    child: ListView(
                      children: List.generate(15, (index) => _buildItem(index)),
                    )
                )
              ],
            ),),),
        ],
      )
    ),);
  }

  Widget _buildItem(int index){
    return InkWell(
      onTap: (){
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 15),
        padding: EdgeInsets.only(left:15,right: 15,bottom: 10,top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color:
              _currentIndex == index ? Colors.red : Colors.grey[300]!,
              width: 1,
              style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
                SizedBox(width: 10),
                Text("这是测试用的啊",
                    style:
                    TextStyle(color: Colors.black, fontSize: 12)),
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: (){},
                  child: Icon(Icons.download_rounded,size: 13,),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: 50 / 100,
                          backgroundColor: Colors.grey[100],
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.red),
                        )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("已学习67%",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void onBack() {
    print("onBack");
  }

  @override
  void onPlayingTimeChange(int current, int duration) {
    // print("onPlayingTimeChange:[current:$current---duration:$duration]");
  }

  @override
  void onStatusChange(String playerStatus) {
    print("onStatusChange:$playerStatus");
  }

  @override
  void onToggleScreen(bool isFullScreen) {
    print("onToggleScreen:$isFullScreen");
    setState(() {
      _isFullScreen = isFullScreen;
    });
  }

  void _init() {
    _playerController.addListener(this);
    _playerController.setupOnlineVideoWithId(_videoId, _token);
  }
}
