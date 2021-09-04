package com.sun.flutter_bjyplayer.utils;


import android.content.Context;

public class DesUtils {
    public static int dip2px(Context context, float dpValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int)(dpValue * scale + 0.5F);
    }
}
