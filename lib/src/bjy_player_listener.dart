part of flutter_bjyplayer;
abstract class BjyPlayerListener{
  /// 全屏切换
  void onToggleScreen();

  /// 返回
  void onBack();

  /// 播放状态发生变化
  void onStatusChange(String playerStatus);

  /// 播放进度发生变化
  void onPlayingTimeChange(int current, int duration);

}