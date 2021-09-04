package com.sun.flutter_bjyplayer.videoplayer.ui.widget;

import android.content.Context;
import android.util.AttributeSet;

import com.baijiayun.videoplayer.widget.BJYPlayerView;
import com.sun.flutter_bjyplayer.videoplayer.bean.VideoSizeInfo;

/**
 * @author chengang
 * @date 2019-08-30
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.player.widget
 * @describe
 */
public class NPlayerView extends BJYPlayerView {
    private VideoSizeInfo mVideoSizeInfo;
    private VideoSizeInfo mLastUpdateVideoSizeInfo;

    public NPlayerView(Context context) {
        this(context, null);
    }

    public NPlayerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public NPlayerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);

    }

    private boolean needCallBack = true;

    @Override
    public void onVideoSizeChange(int i, int i1, int i2, int i3) {
        getVideoSizeInfo().setVideoWidth(i);
        getVideoSizeInfo().setVideoHeight(i1);
        getVideoSizeInfo().setVideoSarNum(i2);
        getVideoSizeInfo().setVideoSarDen(i3);
        super.onVideoSizeChange(i, i1, i2, i3);
        if (needCallBack && videoSizeCallBack != null) {
            videoSizeCallBack.call(getVideoSizeInfo());
        }
    }


    public void updateVideoSize(VideoSizeInfo videoSizeInfo) {
        if (videoSizeInfo == null) {
            return;
        }
        this.mVideoSizeInfo = videoSizeInfo;
        if (mVideoSizeInfo.getVideoWidth() != 0 && mVideoSizeInfo.getVideoHeight() != 0) {
            needCallBack = false;
            onVideoSizeChange(mVideoSizeInfo.getVideoWidth(), mVideoSizeInfo.getVideoHeight(), mVideoSizeInfo.getVideoSarNum(), mVideoSizeInfo.getVideoSarDen());
            needCallBack = true;
        }
        try {
            this.mLastUpdateVideoSizeInfo = (VideoSizeInfo) videoSizeInfo.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
    }

    public VideoSizeInfo getVideoSizeInfo() {
        if (mVideoSizeInfo == null) {
            mVideoSizeInfo = new VideoSizeInfo();
        }
        return mVideoSizeInfo;
    }

    public VideoSizeInfo getLastVideoSizeInfo() {
        if (mLastUpdateVideoSizeInfo == null) {
            mLastUpdateVideoSizeInfo = new VideoSizeInfo();
        }
        return mLastUpdateVideoSizeInfo;
    }

    VideoSizeCallBack videoSizeCallBack;

    public void setVideoSizeCallBack(VideoSizeCallBack videoSizeCallBack) {
        this.videoSizeCallBack = videoSizeCallBack;
    }

    public interface VideoSizeCallBack {
        void call(VideoSizeInfo videoSizeInfo);
    }

}
