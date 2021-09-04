
part of flutter_bjyplayer;


const kMethodOnToggleScreen = 'onToggleScreen';
const kMethodOnBack = 'onBack';
const kMethodOnPlayingTimeChange = 'onPlayingTimeChange';
const kMethodOnStatusChange = 'onStatusChange';

class BjyPlayerController {
  ObserverList<BjyPlayerListener>? _listeners = ObserverList<BjyPlayerListener>();
  MethodChannel? _channel;
  EventChannel? _eventChannel;

  void initWithViewId(int viewId) {
    _channel = MethodChannel('plugin.bjyPlayer_$viewId');
    _eventChannel = EventChannel('plugin.bjyPlayer_event_$viewId');
    _eventChannel!.receiveBroadcastStream().listen(_onEvent);
  }

  _onEvent(dynamic event) {
    if(event is Map){
      String listener = '${event['listener']}';
      String method = '${event['method']}';

      switch (listener) {
        case 'BjyPlayerListener':
          notifyListeners(method, event['data']);
          break;
      }
    }
  }


  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError('A $runtimeType was used after being disposed.\n'
            'Once you have called dispose() on a $runtimeType, it can no longer be used.');
      }
      return true;
    }());
    return true;
  }

  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners!.isNotEmpty;
  }

  void addListener(BjyPlayerListener listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.add(listener);
  }

  void removeListener(BjyPlayerListener listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.remove(listener);
  }

  void dispose() {
    assert(_debugAssertNotDisposed());
    released();
    _listeners = null;
  }

  void notifyListeners(String? method, [dynamic data]) {
    assert(_debugAssertNotDisposed());
    if (_listeners != null) {
      final List<BjyPlayerListener> localListeners = List<BjyPlayerListener>.from(_listeners!);
      for (final BjyPlayerListener listener in localListeners) {
        try {
          if (_listeners!.contains(listener)) {
            switch (method) {
              case kMethodOnToggleScreen:
                listener.onToggleScreen();
                break;
              case kMethodOnBack:
                listener.onBack();
                break;
              case kMethodOnStatusChange:
                listener.onStatusChange(data['playerStatus']);
                break;
              case kMethodOnPlayingTimeChange:
                listener.onPlayingTimeChange(
                  data['cur'],
                  data['dur'],
                );
                break;
            }
          }
        } catch (exception) {}
      }
    }
  }

  void init (){
    _channel!.invokeMethod('init', {});
  }

  void bindPlayerView (){
    _channel!.invokeMethod('bindPlayerView', {});
  }

  void play(){
    _channel!.invokeMethod('play', {});
  }

  void pause(){
    _channel!.invokeMethod('pause', {});
  }

  void stop(){
    _channel!.invokeMethod('stop', {});
  }

  void rePlay(){
    _channel!.invokeMethod('rePlay', {});
  }

  void released(){
    _channel!.invokeMethod('released', {});
  }

  void seek(int time) {
    final Map<String, dynamic> arguments = {
      'time': time,
    };
    _channel!.invokeMethod('seek', arguments);
  }

  void setUserInfo(String username,String userId) {
    final Map<String, dynamic> arguments = {
      'username': username,
      'userId': userId,
    };
    _channel!.invokeMethod('setUserInfo', arguments);
  }

  void hideBackIcon(){
    _channel!.invokeMethod('hideBackIcon', {});
  }

  void setupOnlineVideoWithId(String videoId,String token){
    final Map<String, dynamic> arguments = {
      'videoId': videoId,
      'token': token,
    };
    _channel!.invokeMethod('setupOnlineVideoWithId', arguments);
  }

  Future<bool> isReleased() async {
    return await _channel!.invokeMethod('isReleased', {});
  }

  Future<bool> isPlaying() async {
    return await _channel!.invokeMethod('isPlaying', {});
  }
}