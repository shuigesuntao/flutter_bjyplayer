package com.sun.flutter_bjyplayer.videoplayer.bean;

/**
 * @author chengang
 * @date 2019-08-30
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.player.bean
 * @describe
 */
public class VideoSizeInfo implements Cloneable{

    private int videoWidth;
    private int videoHeight;
    private int videoSarNum;
    private int videoSarDen;

    public int getVideoWidth() {
        return videoWidth;
    }

    public void setVideoWidth(int videoWidth) {
        this.videoWidth = videoWidth;
    }

    public int getVideoHeight() {
        return videoHeight;
    }

    public void setVideoHeight(int videoHeight) {
        this.videoHeight = videoHeight;
    }

    public int getVideoSarNum() {
        return videoSarNum;
    }

    public void setVideoSarNum(int videoSarNum) {
        this.videoSarNum = videoSarNum;
    }

    public int getVideoSarDen() {
        return videoSarDen;
    }

    public void setVideoSarDen(int videoSarDen) {
        this.videoSarDen = videoSarDen;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
