part of flutter_bjyplayer;

class BjyDownloader{

  ObserverList<BjyDownLoaderListener>? _listeners = ObserverList<BjyDownLoaderListener>();
  MethodChannel? _channel;
  EventChannel? _eventChannel;

  BjyDownloader(){
    _channel = MethodChannel('plugin.bjy_downloader');
    _eventChannel = EventChannel('plugin.bjy_downloader_event');
    _eventChannel!.receiveBroadcastStream().listen(_onEvent);
  }

  _onEvent(dynamic event) async{
    if(event is Map){
      String listener = '${event['listener']}';
      String method = '${event['method']}';

      switch (listener) {
        case 'BjyDownLoaderListener':
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

  void addListener(BjyDownLoaderListener listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.add(listener);
  }

  void removeListener(BjyDownLoaderListener listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.remove(listener);
  }

  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  void notifyListeners(String? method, [dynamic data]) {
    assert(_debugAssertNotDisposed());
    if (_listeners != null) {
      final List<BjyDownLoaderListener> localListeners = List<BjyDownLoaderListener>.from(_listeners!);
      for (final BjyDownLoaderListener listener in localListeners) {
        try {
          if (_listeners!.contains(listener)) {
            switch (method) {
              case kMethodOnToggleScreen:
                // listener.onToggleScreen();
                break;
              case kMethodOnBack:
                // listener.onBack();
                break;
              case kMethodOnStatusChange:
                // listener.onStatusChange(data['playerStatus']);
                break;
              case kMethodOnPlayingTimeChange:
                // listener.onPlayingTimeChange(
                //   data['cur'],
                //   data['dur'],
                // );
                break;
            }
          }
        } catch (exception) {}
      }
    }
  }

  void download (String jsonInfo){
    var info = json.decode(jsonInfo);
    _channel!.invokeMethod('download', info);
  }


}