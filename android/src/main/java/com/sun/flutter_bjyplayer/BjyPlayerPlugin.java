package com.sun.flutter_bjyplayer;

import android.app.Application;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.baijiayun.BJYPlayerSDK;
import com.sun.flutter_bjyplayer.sdk_player.ui.FullScreenVideoPlayActivity;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BjyPlayerPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private FlutterPluginBinding mFlutterPluginBinding;
    private ActivityPluginBinding mActivityPluginBinding;
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mFlutterPluginBinding = flutterPluginBinding;
        new BJYPlayerSDK.Builder((Application) flutterPluginBinding.getApplicationContext())
                //如果没有个性域名请注释
//                .setCustomDomain("e37089826")
//                .setEncrypt(false)
                .build();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bjy_player");
        channel.setMethodCallHandler(this);
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
        if(call.method.equals("gotoFullScreenPage")){
            String videoId = (String)call.argument("videoId");
            String token = (String)call.argument("token");
            Intent intent = new Intent(mActivityPluginBinding.getActivity(), FullScreenVideoPlayActivity.class);
            intent.putExtra("token",token);
            intent.putExtra("videoId",Long.parseLong(videoId));
            mActivityPluginBinding.getActivity().startActivity(intent);
        }

    }
}
