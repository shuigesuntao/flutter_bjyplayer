part of flutter_bjyplayer;

class BjyDownloader{
  static final BjyDownloader _instance = BjyDownloader._internal();
  MethodChannel? _channel;
  StreamSubscription? _eventSubscription;
  final StreamController<String> _eventStreamController = StreamController.broadcast();
  Stream<String> get onDownloadEventBroadcast => _eventStreamController.stream;
  //提供了一个工厂方法来获取该类的实例
  factory BjyDownloader(){
    return _instance;
  }

  // 通过私有方法_internal()隐藏了构造方法，防止被误创建
  BjyDownloader._internal(){
    // 初始化
    init();
  }

  init(){
    _channel = MethodChannel('bjy_player');
    _eventSubscription =
        EventChannel("bjy_player_event")
            .receiveBroadcastStream()
            .listen(_eventHandler, onError: _errorHandler);
  }

  _eventHandler(event) {
    if(event == null) return;
    _eventStreamController.add(event);
  }

  _errorHandler(error) {
    //debugPrint("= error = ${error.toString()}");
  }


  void download (String jsonInfo){
    var info = json.decode(jsonInfo);
    _channel!.invokeMethod('download', info);
  }

  Future<List<Map<String,dynamic>>?> getAllDownloadInfo (String courseId) async{
    final Map<String, dynamic> arguments = {
      'courseId': courseId,
    };
    final String? resultData = await _channel!.invokeMethod('getAllDownloadInfo', arguments);
    if(resultData != null){
      return json.decode(resultData);
    }
    return null;
  }


}