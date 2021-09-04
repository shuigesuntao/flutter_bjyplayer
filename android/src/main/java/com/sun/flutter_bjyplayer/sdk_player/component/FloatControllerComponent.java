package com.sun.flutter_bjyplayer.sdk_player.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;
import android.os.Message;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.SeekBar;

import com.baijiayun.videoplayer.ui.component.ControllerComponent;
import com.baijiayun.videoplayer.ui.listener.OnTouchGestureListener;
import com.sun.flutter_bjyplayer.R;


/**
 * Created by yongjiaming on 2018/8/7
 */

public class FloatControllerComponent extends ControllerComponent implements OnTouchGestureListener {

    public FloatControllerComponent(Context context) {
        super(context);
    }

    private SeekBar seekBar;
    private ProgressBar mProgressBar;
    private android.os.Handler handler;

    @SuppressLint("HandlerLeak")
    public android.os.Handler getHandler() {
        if (handler == null) {
            handler = new android.os.Handler() {
                @Override
                public void handleMessage(Message msg) {
                    super.handleMessage(msg);
                    handler.sendEmptyMessageDelayed(1, 1000 / 60);
                    if (mProgressBar != null && seekBar != null) {
                        mProgressBar.setProgress(seekBar.getProgress());
                        mProgressBar.setMax(seekBar.getMax());
                        mProgressBar.setSecondaryProgress(seekBar.getSecondaryProgress());
                    }

                }
            };
        }
        return handler;

    }

    @Override
    public void onViewDetachedFromWindow(View v) {
        super.onViewDetachedFromWindow(v);
        if (handler != null) {
            handler.removeMessages(1);
        }
    }

    @Override
    public void onCustomEvent(int eventCode, Bundle bundle) {
        super.onCustomEvent(eventCode, bundle);
        this.seekBar = this.findViewById(R.id.cover_player_controller_seek_bar);
        hideAll();
    }

    void hideAll() {
        try {
            hideView(R.id.cover_player_controller_rate_top);
            hideView(R.id.cover_player_controller_text_view_video_title);
            hideView(R.id.cover_player_controller_text_view_curr_time);
            hideView(R.id.cover_player_controller_text_view_total_time);
            hideView(R.id.cover_player_controller_seek_bar);
            hideView(R.id.cover_player_controller_subtitle);
            hideView(R.id.cover_player_controller_subtitle_top);
            hideView(R.id.cover_player_controller_subtitle_view);
            hideView(R.id.cover_player_controller_rate);
            hideView(R.id.cover_player_controller_room_outline);
            hideView(R.id.cover_player_controller_frame);
        } catch (Exception ee) {
            ee.printStackTrace();
        }
    }

    void hideView(int resId) {
        this.findViewById(resId).setVisibility(View.GONE);
    }

    @Override
    public void onComponentEvent(int eventCode, Bundle bundle) {
        super.onComponentEvent(eventCode, bundle);
        hideAll();
    }

    @Override
    protected void onInitView() {
        super.onInitView();
        hideAll();
        this.seekBar = this.findViewById(R.id.cover_player_controller_seek_bar);
        this.mProgressBar = this.findViewById(R.id.pgr);
        getHandler().sendEmptyMessageDelayed(1, 1000 / 60);

    }

    @Override
    protected View onCreateComponentView(Context context) {

        //注意这个布局里面的id跟ControllerComponent 里面的id保持一致
        return View.inflate(context, R.layout.layout_float_controller_component_lib_cp, null);
    }


}
