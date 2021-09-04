import 'package:flutter/material.dart';
import 'package:flutter_bjyplayer/flutter_bjyplayer.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with BjyPlayerListener {
  BjyPlayerController _playerController = BjyPlayerController();
  var _token = "w23vn0sctxQYFe_rjL5tFr5mJbeoZk2nt4M4sFjcCqMfgVjhW6nuIpgdYUaodCwc";
  var _videoId = "155946606";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((value) => _init());
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("百家云Demo"),
      ),
      body: Container(
          width: width,
          child: BjyPlayerView(controller: _playerController)
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
  void onToggleScreen() {
    print("onToggleScreen");
  }

  void _init() {
    _playerController.addListener(this);
    _playerController.setupOnlineVideoWithId(_videoId, _token);
  }
}
