package com.sun.flutter_bjyplayer.sdk_player.widget;


import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;

import com.baijiayun.videoplayer.IBJYVideoPlayer;
import com.baijiayun.videoplayer.bean.CDNInfo;
import com.baijiayun.videoplayer.bean.PlayItem;
import com.baijiayun.videoplayer.bean.SectionItem;
import com.baijiayun.videoplayer.bean.VideoItem;
import com.baijiayun.videoplayer.ui.widget.ComponentContainer;
import com.sun.flutter_bjyplayer.R;
import com.sun.flutter_bjyplayer.utils.DesUtils;
import com.sun.flutter_bjyplayer.videoplayer.bean.VideoSizeInfo;
import com.sun.flutter_bjyplayer.videoplayer.ui.widget.NBJYVideoView;
import com.sun.flutter_bjyplayer.videoplayer.ui.widget.NPlayerView;

import java.util.ArrayList;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


/**
 * @author chengang
 * @date 2019-08-20
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.sdk_player.widget
 * @describen 为了解决bjyvideoview的不符合需求的一些扩展
 */
public class NjVideoView extends NBJYVideoView {


    public NjVideoView(@NonNull Context context) {
        this(context, null);
    }

    public NjVideoView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public NjVideoView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

    }


    public NPlayerView getBjyPlayerView() {
        return (NPlayerView) bjyPlayerView;
    }

    public IBJYVideoPlayer getPlayer() {
        return this.bjyVideoPlayer;
    }

    public void updateVideoSize(VideoSizeInfo currentPlayVideoInfo) {
        if (getBjyPlayerView() != null) {
            getBjyPlayerView().updateVideoSize(currentPlayVideoInfo);
        }
    }

    public void setUpOnlineVideoUrl(String videoUrl, String title) {
        VideoItem videoItem = new VideoItem();
        videoItem.url = videoUrl;
        videoItem.definition = new ArrayList<>();
        videoItem.definition.add(new VideoItem.DefinitionItem());
        videoItem.vodDefaultDefinition = "720p";
        videoItem.playInfo = new VideoItem.PlayInfo();
        videoItem.playInfo._720p = new PlayItem();
        videoItem.playInfo._720p.cdnList = new CDNInfo[1];
        videoItem.playInfo._720p.cdnList[0] = new CDNInfo();
        videoItem.playInfo._720p.cdnList[0].url = videoUrl;
        videoItem.reportInterval = 120;
        SectionItem sectionItem = new SectionItem();
        sectionItem.partnerId = 0;
        sectionItem.title = title;
        videoItem.videoInfo = sectionItem;
        bjyVideoPlayer.setupOnlineVideoWithVideoItem(videoItem);
    }

    public ComponentContainer getComponentContainer() {
        return componentContainer;
    }

    public void setVideoSizeCallBack(NPlayerView.VideoSizeCallBack videoSizeCallBack) {
        if (bjyPlayerView instanceof NPlayerView) {
            ((NPlayerView) bjyPlayerView).setVideoSizeCallBack(videoSizeCallBack);
        }
    }

    public void hideBackIcon() {
        ComponentContainer componentContainer = getComponentContainer();
        for (int i = 0; i < componentContainer.getChildCount(); i++) {
            View view = componentContainer.getChildAt(i).findViewById(R.id.cover_player_controller_image_view_back_icon);
            if (view != null) {
                ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
                layoutParams.width= DesUtils.dip2px(getContext(),15);
                view.setLayoutParams(layoutParams);
                view.setVisibility(INVISIBLE);
                break;
            }
        }
    }

}
