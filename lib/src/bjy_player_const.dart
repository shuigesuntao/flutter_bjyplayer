part of flutter_bjyplayer;

class BjyPlayerConst {
  // 播放状态
  static final String stateError = "STATE_ERROR";
  static final String stateIdel = "STATE_IDLE";
  static final String stateInitialized = "STATE_INITIALIZED";
  static final String statePrepared = "STATE_PREPARED";
  static final String stateStarted = "STATE_STARTED";
  static final String statePaused = "STATE_PAUSED";
  static final String stateStopped = "STATE_STOPPED";
  static final String statePlaybackCompleted = "STATE_PLAYBACK_COMPLETED";

  // 下载文件类型
  static final int fileTypeCourseWave = 1;
  static final int fileTypeLibrary = 2;
  static final int fileTypePlayBack = 3;
  static final int fileTypePlayBackSmall = 31;
  static final int fileTypeVideo = 4;
  static final int fileTypeVideoAudio = 41;
  static final int fileTypeFileCourse = 5;
  static final int fileTypeFileVideo = 6;
  static final int fileTypeFileAudio = 7;
  static final int fileTypeCustom = 8;

  // 下载状态
  static final int downloadStatusComplete = 1;
  static final int downloadStatusDownloading = 2;
  static final int downloadStatusWaiting = 3;
  static final int downloadStatusStop = 4;
  static final int downloadStatusError = 5;
}