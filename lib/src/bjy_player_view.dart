part of flutter_bjyplayer;

class BjyPlayerView extends StatelessWidget{
  final BjyPlayerController controller;
  final bool isFloat;

  const BjyPlayerView({Key? key,required this.controller,this.isFloat = false}) : super(key: key);

  void _onPlatformViewCreated(viewId) {
    controller.initWithViewId(viewId);
  }

  @override
  Widget build(BuildContext context) {
    return getPlatformView();
  }

  Widget getPlatformView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: isFloat?'bjy_float_player_view':'bjy_player_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: isFloat?'bjy_float_player_view':'bjy_player_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }


}
