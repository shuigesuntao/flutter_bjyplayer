package com.sun.flutter_bjyplayer;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleOwner;

import com.google.gson.Gson;
import com.nj.baijiayun.downloader.DownloadManager;
import com.nj.baijiayun.downloader.realmbean.DownloadItem;
import com.nj.baijiayun.downloader.request.DownloadRequest;
import com.sun.flutter_bjyplayer.sdk_player.manager.BjyVideoPlayManager;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.functions.Consumer;

public class BjyDownloader implements MethodChannel.MethodCallHandler {
    private FlutterPlugin.FlutterPluginBinding mFlutterPluginBinding;
    private final MethodChannel mMethodChannel;
    private final EventChannel mEventChannel;
    private final BjyPlayerEventSink mEventSink = new BjyPlayerEventSink();
    private Context mContext;
    public BjyDownloader(Context context, Map<String, Object> params, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        super();
        mContext = context;
        mMethodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugin.bjy_downloader");
        mMethodChannel.setMethodCallHandler(this);
        mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "plugin.bjy_downloader_event");
        mEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                mEventSink.setEventSinkProxy(eventSink);
            }

            @Override
            public void onCancel(Object o) {
                mEventSink.setEventSinkProxy(null);
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        if(call.method.equals("download")){
            String type = call.argument("type");
            String roomId = call.argument("roomId");
            int courseType = (int)call.argument("courseType");
            String courseName = call.argument("courseName");
            String courseId = call.argument("courseId");
            String token = call.argument("token");
            String chapterId = call.argument("chapterId");
            String chapterName = call.argument("chapterName");
            String extraInfo = call.argument("extraInfo");
            DownloadRequest downloadRequest;
            if("huifang".equals(type)){
                downloadRequest = DownloadManager.downloadFile(DownloadManager.DownloadType.TYPE_PLAY_BACK);
                downloadRequest.videoId(Long.parseLong(roomId));
            } else {
                downloadRequest = DownloadManager.downloadFile(
                        courseType == 8 ? DownloadManager.DownloadType.TYPE_VIDEO_AUDIO : DownloadManager.DownloadType.TYPE_VIDEO);
                downloadRequest.videoId(Long.parseLong(roomId));
                //点播
            }
            downloadRequest
                    .setVideoDefinitions(BjyVideoPlayManager.videoDefinition)
                    .parentType(courseType)
                    .parentName(courseName)
                    .parentCover(null)
                    .parentId(courseId)
                    .itemId(chapterId)
                    .fileName(chapterName)
                    .setExtraInfo(extraInfo)
                    .token(token);
            downloadRequest.start();
        }else if(call.method.equals("getAllDownloadInfo")){
            String courseId = call.argument("courseId");
            DownloadManager.getAllDownloadInfo((LifecycleOwner) mContext,courseId).getAsFlow().subscribe((Consumer<List<DownloadItem>>) downloadItems -> {
                result.success(new Gson().toJson(downloadItems));
            });
//            DownloadManager.getPlayBackDownloadTask(downloadItem).getVideoDownloadInfo()
        }
    }
}
