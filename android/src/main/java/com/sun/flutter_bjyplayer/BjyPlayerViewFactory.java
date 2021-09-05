package com.sun.flutter_bjyplayer;

import android.app.Activity;
import android.content.Context;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BjyPlayerViewFactory extends PlatformViewFactory {
    private FlutterPlugin.FlutterPluginBinding mFlutterPluginBinding;
    private Activity mActivity;

    public BjyPlayerViewFactory(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        mFlutterPluginBinding = flutterPluginBinding;
        mActivity = activity;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        if (mActivity == null) {
            return null;
        }

        if (args instanceof Map) {
            if((Boolean) ((Map)args).get("isFloat")){
                return new BjyFloatPlayerView(mActivity, ((Map) args), viewId, mFlutterPluginBinding);
            }else{
                return new BjyPlayerView(mActivity, ((Map) args), viewId, mFlutterPluginBinding);
            }
        }
        return null;
    }
}
