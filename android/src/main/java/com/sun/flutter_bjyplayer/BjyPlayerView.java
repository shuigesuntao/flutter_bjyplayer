package com.sun.flutter_bjyplayer;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.baijiayun.videoplayer.listeners.OnPlayerStatusChangeListener;
import com.baijiayun.videoplayer.listeners.OnPlayingTimeChangeListener;
import com.baijiayun.videoplayer.player.PlayerStatus;
import com.baijiayun.videoplayer.ui.event.UIEventKey;
import com.baijiayun.videoplayer.ui.listener.IComponentEventListener;
import com.lzf.easyfloat.permission.PermissionUtils;
import com.sun.flutter_bjyplayer.sdk_player.component.FloatControllerComponent;
import com.sun.flutter_bjyplayer.sdk_player.manager.BjyVideoPlayManager;
import com.sun.flutter_bjyplayer.sdk_player.manager.VideoHelper;
import com.sun.flutter_bjyplayer.sdk_player.ui.FullScreenVideoPlayActivity;
import com.sun.flutter_bjyplayer.sdk_player.widget.NjVideoView;
import com.sun.flutter_bjyplayer.utils.CommonMDDialog;
import com.sun.flutter_bjyplayer.videoplayer.ui.widget.ComponentContainerHelper;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class BjyPlayerView implements PlatformView, MethodChannel.MethodCallHandler, IComponentEventListener, OnPlayingTimeChangeListener, OnPlayerStatusChangeListener {
    private View mContainerView;
    private NjVideoView mVideoView;
    private FlutterPlugin.FlutterPluginBinding mFlutterPluginBinding;
    private final MethodChannel mMethodChannel;
    private final EventChannel mEventChannel;
    private final BjyPlayerEventSink mEventSink = new BjyPlayerEventSink();
    private Context mContext;
    public BjyPlayerView(Context context, Map<String, Object> params, int viewId, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        super();
        mContext = context;
        mFlutterPluginBinding = flutterPluginBinding;
        mContainerView = LayoutInflater.from(context).inflate(R.layout.layout_video, null, false);
        mVideoView = mContainerView.findViewById(R.id.plv_video);
        mVideoView.initPlayer(BjyVideoPlayManager.getMediaPlayer(mFlutterPluginBinding.getApplicationContext()));
        VideoHelper.resetRenderTypeTexture(mVideoView);
        mVideoView.setComponentEventListener(this);
        mVideoView.getPlayer().addOnPlayingTimeChangeListener(this);
        mVideoView.getPlayer().addOnPlayerStatusChangeListener(this);
        mVideoView.setVideoSizeCallBack(VideoHelper::setCurrentPlayVideoInfo);
        mMethodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugin.bjyPlayer_" + viewId);
        mMethodChannel.setMethodCallHandler(this);
        mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "plugin.bjyPlayer_event_" + viewId);
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
        switch (call.method){
            case "init":
                mVideoView.initPlayer(BjyVideoPlayManager.getMediaPlayer(mFlutterPluginBinding.getApplicationContext()));
                VideoHelper.resetRenderTypeTexture(mVideoView);
                break;
            case "isReleased":
                Boolean isReleased = BjyVideoPlayManager.isReleased();
                result.success(isReleased);
                break;
            case "bindPlayerView":
                BjyVideoPlayManager.getMediaPlayer(mFlutterPluginBinding.getApplicationContext()).bindPlayerView(mVideoView.getBjyPlayerView());
                VideoHelper.resetRenderTypeTexture(mVideoView);
                break;
            case "play":
                mVideoView.getPlayer().play();
                break;
            case "pause":
                mVideoView.getPlayer().pause();
                break;
            case "stop":
                mVideoView.getPlayer().stop();
                break;
            case "released":
                BjyVideoPlayManager.releaseMedia();
                break;
            case "rePlay":
                mVideoView.getPlayer().rePlay();
                break;
            case "seek":
                int time = call.argument("time");
                mVideoView.getPlayer().seek(time);
                break;
            case "isPlaying":
                Boolean isPlaying = mVideoView.getPlayer().isPlaying();
                result.success(isPlaying);
                break;
            case "hideBackIcon":
                mVideoView.hideBackIcon();
                break;
            case "setUserInfo":
                mVideoView.getPlayer().setUserInfo(call.argument("username"),call.argument("userId"));
                break;
            case "tryOpenFloatViewPlay":
                tryOpenFloatViewPlay(needReleasePlayer -> {
                    if (needReleasePlayer) {
                        BjyVideoPlayManager.releaseMedia();
                    }
                    result.success(null);
                });
                break;
            case "setupOnlineVideoWithId":
                String videoId = "";
                String token = "";
                if (call.hasArgument("videoId"))
                    videoId = call.argument("videoId");
                if (call.hasArgument("token"))
                    token =  call.argument("token");
                if(!TextUtils.isEmpty(token) && !TextUtils.isEmpty(videoId)){
                    mVideoView.getPlayer().setupOnlineVideoWithId(Long.parseLong(videoId),token);
                }
                break;
        }
    }
    public interface ActionCallBack {
        void call(boolean needStopPlayer);
    }
    private void tryOpenFloatViewPlay(final ActionCallBack actionCallBack) {
        if (mVideoView.getPlayer() == null || !mVideoView.getPlayer().isPlaying()) {
            actionCallBack.call(true);
            return;
        }
        if (PermissionUtils.checkPermission(mContext)) {
            BjyVideoPlayManager.addFloatingView((Activity) mContext, () -> actionCallBack.call(false));
        } else {
            final CommonMDDialog commonmddialog = new CommonMDDialog(mContext);
            commonmddialog.setContentTxt("开启浮窗播放功能，需要您授权悬浮窗权限。")
                    .setNegativeTxt("暂不开启")
                    .setOnNegativeClickListener(() -> {
                        commonmddialog.dismiss();
                        actionCallBack.call(true);
                    })
                    .setPositiveTxt("去开启")
                    .setOnPositiveClickListener(() -> {
                        commonmddialog.dismiss();
                        BjyVideoPlayManager.addFloatingView((Activity) mContext, () -> actionCallBack.call(false));
                    }).show();

        }
    }

    @Override
    public View getView() {
        return mContainerView;
    }


    @Override
    public void dispose() {
//        BjyVideoPlayManager.releaseMedia();
    }


    @Override
    public void onReceiverEvent(int eventCode, Bundle bundle) {
        if (eventCode == UIEventKey.CUSTOM_CODE_REQUEST_TOGGLE_SCREEN) {
            final Map<String, Object> eventData = new HashMap<>();
            eventData.put("listener", "BjyPlayerListener");
            eventData.put("method", "onToggleScreen");
            mEventSink.success(eventData);
            mContext.startActivity(new Intent(mContext, FullScreenVideoPlayActivity.class));
        } else if (eventCode == UIEventKey.CUSTOM_CODE_REQUEST_BACK) {
            final Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("isFloat", false);
            final Map<String, Object> eventData = new HashMap<>();
            eventData.put("listener", "BjyPlayerListener");
            eventData.put("method", "onBack");
            eventData.put("data", dataMap);
            mEventSink.success(eventData);
//            onBackPressedSupport();
        } else if (eventCode == UIEventKey.CUSTOM_CODE_MENU_DONE) {
            ComponentContainerHelper.getInstance().setRateBundle(bundle);
        }
    }


    @Override
    public void onPlayingTimeChange(int cur, int dur) {
        final Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("cur", cur);
        dataMap.put("dur", dur);

        final Map<String, Object> eventData = new HashMap<>();
        eventData.put("listener", "BjyPlayerListener");
        eventData.put("method", "onPlayingTimeChange");
        eventData.put("data", dataMap);

        mEventSink.success(eventData);
//        if (cur >= dur && !isFinishing()) {
//            handlePlayEnd();
//        }
    }

    @Override
    public void onStatusChange(PlayerStatus playerStatus) {
        final Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("playerStatus", playerStatus.name());

        final Map<String, Object> eventData = new HashMap<>();
        eventData.put("listener", "BjyPlayerListener");
        eventData.put("method", "onStatusChange");
        eventData.put("data", dataMap);
        mEventSink.success(eventData);
    }
}
