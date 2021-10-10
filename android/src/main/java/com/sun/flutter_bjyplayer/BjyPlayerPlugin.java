package com.sun.flutter_bjyplayer;

import android.app.Application;
import android.content.Intent;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleOwner;

import com.baijiayun.BJYPlayerSDK;
import com.google.gson.Gson;
import com.lzf.easyfloat.EasyFloat;
import com.nj.baijiayun.downloader.DownloadManager;
import com.nj.baijiayun.downloader.config.DownConfig;
import com.nj.baijiayun.downloader.realmbean.DownloadItem;
import com.nj.baijiayun.downloader.request.DownloadRequest;
import com.nj.baijiayun.logger.log.Logger;
import com.sun.flutter_bjyplayer.sdk_player.manager.BjyVideoPlayManager;
import com.sun.flutter_bjyplayer.sdk_player.ui.FullScreenVideoPlayActivity;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.functions.Consumer;

public class BjyPlayerPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private EventChannel mEventChannel;
    private FlutterPluginBinding mFlutterPluginBinding;
    private ActivityPluginBinding mActivityPluginBinding;
    private final BjyPlayerEventSink mEventSink = new BjyPlayerEventSink();
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mFlutterPluginBinding = flutterPluginBinding;

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bjy_player");
        channel.setMethodCallHandler(this);
        mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "bjy_player_event");
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
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel.setMethodCallHandler(null);

        mFlutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivityPluginBinding = binding;
        mFlutterPluginBinding.getPlatformViewRegistry().registerViewFactory("bjy_player_view", new BjyPlayerViewFactory(mFlutterPluginBinding, binding.getActivity()));

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if(call.method.equals("initBjyPlayer")){
            Logger.setEnable(true);
            Logger.setPriority(Logger.MIN_LOG_PRIORITY);
            Logger.setTag("Sun");
            Logger.init(mFlutterPluginBinding.getApplicationContext());
            EasyFloat.init((Application) mFlutterPluginBinding.getApplicationContext(),false);

            DownConfig.Builder builder = new DownConfig
                    .Builder(mFlutterPluginBinding.getApplicationContext());
            DownConfig downConfig = builder.setFilePath(getVideoDownLoadPath()).builder();
            DownloadManager.init(downConfig);
            new BJYPlayerSDK.Builder((Application) mFlutterPluginBinding.getApplicationContext())
                    //如果没有个性域名请注释
//                .setCustomDomain("e37089826")
//                .setEncrypt(false)
                    .build();
        } else if(call.method.equals("gotoFullScreenPage")){
            String videoId = (String)call.argument("videoId");
            String token = (String)call.argument("token");
            String path = (String)call.argument("path");
            Intent intent = new Intent(mActivityPluginBinding.getActivity(), FullScreenVideoPlayActivity.class);
            intent.putExtra("token",token);
            intent.putExtra("videoId",Long.parseLong(videoId));
            intent.putExtra("videoPath",path);
            mActivityPluginBinding.getActivity().startActivity(intent);
        }else if(call.method.equals("download")){
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
            DownloadManager.getAllDownloadInfo((LifecycleOwner) mActivityPluginBinding.getActivity(), courseId)
                    .getAsFlow().subscribe((Consumer<List<DownloadItem>>) downloadItems -> {

                for (int i = 0; i < downloadItems.size(); i++) {
                    if (downloadItems.get(i) == null) {
                        continue;
                    }
                    DownloadItem item = downloadItems.get(i);
                    Map data = new HashMap<String,Object>();
                    data.put("itemId",item.getItemId());
                    data.put("downloadStatus",item.getDownloadStatus());
                    data.put("filePath",item.getFilePath());
                    mEventSink.success(data);
                }
            });
//            DownloadManager.getAllDownloadInfo((LifecycleOwner) mActivityPluginBinding.getActivity(),courseId).getAsFlow().subscribe((Consumer<List<DownloadItem>>) downloadItems -> {
//                Log.d("Sun",new Gson().toJson(downloadItems));
////                result.success(new Gson().toJson(downloadItems));
//            });
//            DownloadManager.getPlayBackDownloadTask(downloadItem).getVideoDownloadInfo()
        }
    }

    public String getVideoDownLoadPath() {
        String mCacheDirPath = null;
        File cacheDir = mFlutterPluginBinding.getApplicationContext().getExternalFilesDir("FileDownload");
        if (null != cacheDir) {
            mCacheDirPath = cacheDir.getAbsolutePath();
        }
        if (TextUtils.isEmpty(mCacheDirPath)) {
            if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {
                mCacheDirPath = Environment.getExternalStorageDirectory().getPath() + "/Android/data/com.baijiayun.dainixue/files/";
            }
        }
        return mCacheDirPath;
    }
}
