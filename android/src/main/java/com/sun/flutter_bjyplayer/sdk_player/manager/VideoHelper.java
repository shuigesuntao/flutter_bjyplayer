package com.sun.flutter_bjyplayer.sdk_player.manager;

import android.util.Log;
import android.view.View;

import com.baijiayun.videoplayer.IBJYVideoPlayer;
import com.baijiayun.videoplayer.bean.CDNInfo;
import com.baijiayun.videoplayer.bean.PlayItem;
import com.baijiayun.videoplayer.bean.SectionItem;
import com.baijiayun.videoplayer.bean.VideoItem;
import com.baijiayun.videoplayer.render.AspectRatio;
import com.baijiayun.videoplayer.render.IRender;
import com.baijiayun.videoplayer.ui.widget.BaseVideoView;
import com.baijiayun.videoplayer.widget.BJYPlayerView;
import com.sun.flutter_bjyplayer.videoplayer.bean.VideoSizeInfo;
import com.sun.flutter_bjyplayer.videoplayer.ui.widget.NPlayerView;

import java.lang.reflect.Field;
import java.util.ArrayList;


/**
 * @author chengang
 * @date 2019-08-30
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.android_lib_player
 * @describe
 */
public class VideoHelper {
    public static VideoSizeInfo mCurrentPlayVideoInfo;

    public static void setCurrentPlayVideoInfo(VideoSizeInfo mCurrentPlayVideoInfo) {
        VideoHelper.mCurrentPlayVideoInfo = mCurrentPlayVideoInfo;
    }

    public static VideoSizeInfo getCurrentPlayVideoInfo() {
        if (mCurrentPlayVideoInfo == null) {
            mCurrentPlayVideoInfo = new VideoSizeInfo();
        }
        return mCurrentPlayVideoInfo;
    }

    public static boolean checkVideoSizeIsChange(NPlayerView njPlayerView) {

        Log.d("checkVideoSizeIsChange1","w:"+njPlayerView.getLastVideoSizeInfo().getVideoWidth()+"--"+getCurrentPlayVideoInfo().getVideoWidth());
        Log.d("checkVideoSizeIsChange2","h:"+njPlayerView.getLastVideoSizeInfo().getVideoHeight()+"--"+getCurrentPlayVideoInfo().getVideoHeight());
        return njPlayerView.getLastVideoSizeInfo().getVideoWidth() != getCurrentPlayVideoInfo().getVideoWidth() || njPlayerView.getLastVideoSizeInfo().getVideoHeight() != getCurrentPlayVideoInfo().getVideoHeight();
    }
    //  解决播放变形的问题，sdk一直没解决
    public static void resetRenderTypeTexture(BaseVideoView njBjyVideoView) {
        for (int i = 0; i < njBjyVideoView.getChildCount(); i++) {
            View childAt = njBjyVideoView.getChildAt(i);
            if (childAt instanceof BJYPlayerView) {
                BJYPlayerView bjyPlayerView = (BJYPlayerView) childAt;
                bjyPlayerView.setAspectRatio(AspectRatio.AspectRatio_16_9);
                Log.d("TAG", "BJYPlayerView--->" + bjyPlayerView);
                try {
                    Class<? extends BJYPlayerView> aClass = bjyPlayerView.getClass();
                    Field mRenderType = aClass.getDeclaredField("mRenderType");
                    mRenderType.setAccessible(true);
                    mRenderType.set(bjyPlayerView,IRender.RENDER_TYPE_SURFACE_VIEW);
                    bjyPlayerView.setRenderType(IRender.RENDER_TYPE_TEXTURE_VIEW);
                } catch (Exception e) {
                    Log.e("Sun","resetRenderTypeTexture"+e.getMessage());
                    try {
                        bjyPlayerView.setRenderType(IRender.RENDER_TYPE_SURFACE_VIEW);
                        bjyPlayerView.setRenderType(IRender.RENDER_TYPE_TEXTURE_VIEW);
                    }catch (Exception ee){
                        Log.e("Sun","resetRenderTypeTexture reset"+ee.getMessage());
                    }
                }
                break;
            }
        }

    }

    public static void setUpOnlineVideoUrl(IBJYVideoPlayer ibjyVideoPlayer,String videoUrl, String title) {
        VideoItem videoItem = new VideoItem();
        videoItem.url = videoUrl;
        videoItem.definition = new ArrayList<>();
        videoItem.definition.add(new VideoItem.DefinitionItem());
        videoItem.vodDefaultDefinition = "high";
        videoItem.playInfo = new VideoItem.PlayInfo();
        videoItem.playInfo.high = new PlayItem();
        videoItem.playInfo.high.cdnList = new CDNInfo[1];
        videoItem.playInfo.high.cdnList[0] = new CDNInfo();
        videoItem.playInfo.high.cdnList[0].url = videoUrl;
        videoItem.reportInterval = 120;
        SectionItem sectionItem = new SectionItem();
        sectionItem.partnerId = 0;
        sectionItem.title = title;
        videoItem.videoInfo = sectionItem;
        ibjyVideoPlayer.setupOnlineVideoWithVideoItem(videoItem);
    }

}
