package com.sun.flutter_bjyplayer.utils;

import android.app.Activity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

public class PadAdapterHelper {
    public static void hideBottomBar(Activity activity) {
        Window window = activity.getWindow();
        WindowManager.LayoutParams params = window.getAttributes();
        params.systemUiVisibility = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION|View.SYSTEM_UI_FLAG_IMMERSIVE;
        window.setAttributes(params);
    }
}
