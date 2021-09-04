package com.sun.flutter_bjyplayer.sdk_player.manager;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.baijiayun.constant.VideoDefinition;
import com.baijiayun.videoplayer.IBJYVideoPlayer;
import com.baijiayun.videoplayer.VideoPlayerFactory;
import com.baijiayun.videoplayer.ui.event.UIEventKey;
import com.lzf.easyfloat.EasyFloat;
import com.lzf.easyfloat.anim.AppFloatDefaultAnimator;
import com.lzf.easyfloat.enums.ShowPattern;
import com.lzf.easyfloat.enums.SidePattern;
import com.lzf.easyfloat.interfaces.OnFloatCallbacks;
import com.lzf.easyfloat.permission.PermissionUtils;
import com.sun.flutter_bjyplayer.R;
import com.sun.flutter_bjyplayer.sdk_player.component.FloatControllerComponent;
import com.sun.flutter_bjyplayer.sdk_player.ui.FullScreenVideoPlayActivity;
import com.sun.flutter_bjyplayer.sdk_player.widget.NjVideoView;
import com.sun.flutter_bjyplayer.utils.DesUtils;


import java.util.ArrayList;
import java.util.List;

/**
 * @author chengang
 */
public class BjyVideoPlayManager {

    private static IBJYVideoPlayer iMediaPlayer;
    public static List<VideoDefinition> videoDefinition = new ArrayList<>();

    static {
        videoDefinition.add(VideoDefinition._1080P);
        videoDefinition.add(VideoDefinition._720P);
        videoDefinition.add(VideoDefinition.SHD);
        videoDefinition.add(VideoDefinition.HD);
        videoDefinition.add(VideoDefinition.SD);
        videoDefinition.add(VideoDefinition.Audio);
    }

    public static IBJYVideoPlayer getMediaPlayer(Context context) {
        if (iMediaPlayer == null) {
            iMediaPlayer = createPlayer(context);
        }
        return iMediaPlayer;

    }

    public static IBJYVideoPlayer getMediaPlayer() {
        return iMediaPlayer;
    }

    public static boolean isReleased() {
        return iMediaPlayer == null;
    }


    public static void releaseMedia() {

        if (iMediaPlayer != null) {
            if (iMediaPlayer.isPlaying()) {
                iMediaPlayer.pause();
            }
            iMediaPlayer.release();
        }
        iMediaPlayer = null;
        //强制关
        closeFloatingView();

    }

    public static void stopMedia() {
        if (iMediaPlayer != null) {
            if (iMediaPlayer.isPlaying()) {
                iMediaPlayer.pause();
                iMediaPlayer.stop();
            }
        }
    }

    private static IBJYVideoPlayer createPlayer(Context context) {
        return new VideoPlayerFactory.Builder()
                //开启循环播放
                .setSupportLooping(false)
                //关闭后台音频播放
                .setSupportBackgroundAudio(false)
                //开启记忆播放
                .setSupportBreakPointPlay(true)
                .setContext(context)
                .setPreferredDefinitions(videoDefinition)
                .build();
    }



    private static void closeFloatingView() {
        try {
            EasyFloat.dismissAppFloat("player");
        } catch (Exception ee) {
            ee.printStackTrace();
        }

    }


    public static void addFloatingView(Activity context, Callback callback, Class... cls) {
        EasyFloat.with(context)
                .setTag("player")
                .setSidePattern(SidePattern.RESULT_SIDE)
                .setFilter(cls)
                .setFilter(FullScreenVideoPlayActivity.class)
                .setShowPattern(ShowPattern.ALL_TIME)
                .setAppFloatAnimator(new AppFloatDefaultAnimator())
                .setLayout(R.layout.player_floating_view, floatingView -> {
                    NjVideoView mPlvVideo = floatingView.findViewById(R.id.plv_video);
                    mPlvVideo.initPlayer(BjyVideoPlayManager.getMediaPlayer(floatingView.getContext()));
                    try {
                        for (int i = 0; i < mPlvVideo.getComponentContainer().getChildCount(); i++) {
                            mPlvVideo.getComponentContainer().getChildAt(i).setVisibility(View.INVISIBLE);
                        }
                        mPlvVideo.getComponentContainer().setVisibility(View.INVISIBLE);
                        FloatControllerComponent component = new FloatControllerComponent(mPlvVideo.getContext());
                        mPlvVideo.getComponentContainer().removeAllViews();
                        mPlvVideo.getComponentContainer().addComponent(UIEventKey.KEY_CONTROLLER_COMPONENT, component);

                    } catch (Exception ee) {
                        Log.e("Sun",ee.getMessage());
                    }
//                    VideoHelper.resetRenderTypeTexture(mPlvVideo);
                    mPlvVideo.setComponentEventListener((eventCode, bundle) -> {
                        if (eventCode == UIEventKey.CUSTOM_CODE_REQUEST_BACK) {
                            BjyVideoPlayManager.releaseMedia();
                        } else if (eventCode == UIEventKey.CUSTOM_CODE_REQUEST_TOGGLE_SCREEN) {
                            Intent intent = new Intent(floatingView.getContext(), FullScreenVideoPlayActivity.class);
                            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            floatingView.getContext().startActivity(intent);
                        }
                    });

                })
                .setLocation(0, DesUtils.dip2px(context,200))
                .registerCallbacks(new OnFloatCallbacks() {
                    @Override
                    public void createdResult(boolean b, String s, View floatingView) {
                        //  获取到了权限
                        if (PermissionUtils.checkPermission(context)) {
                            if (callback != null) {
                                callback.permissionReqSuccess();
                            }
                        }

                    }

                    @Override
                    public void show(View floatingView) {
                        Object tagIsLastFromShow = floatingView.getTag(R.id.plv_video);
                        NjVideoView mPlvVideo = floatingView.findViewById(R.id.plv_video);
                        if (mPlvVideo.getPlayer() == null) {
                            return;
                        }
                        mPlvVideo.getComponentContainer().setVisibility(View.VISIBLE);
                        try {

                            if (tagIsLastFromShow == null || !(boolean) tagIsLastFromShow) {
                                BjyVideoPlayManager.getMediaPlayer(floatingView.getContext()).bindPlayerView(mPlvVideo.getBjyPlayerView());
                                //player 被释放 会导致内部的 引用为null 暂时这么解决
                                if (!mPlvVideo.getPlayer().isPlaying()) {
                                    mPlvVideo.play();
                                }
                            }
                            if (VideoHelper.checkVideoSizeIsChange(mPlvVideo.getBjyPlayerView())
                                    || tagIsLastFromShow == null
                                    || !(boolean) tagIsLastFromShow) {
                                mPlvVideo.updateVideoSize(VideoHelper.getCurrentPlayVideoInfo());
                            }

                        } catch (Exception ee) {
                            Log.d("Sun","player" + ee.getMessage());

                        }

                        floatingView.setTag(R.id.plv_video, true);
                    }

                    @Override
                    public void hide(View view) {
                        view.setTag(R.id.plv_video, false);
                    }

                    @Override
                    public void dismiss() {
                        BjyVideoPlayManager.stopMedia();
                    }

                    @Override
                    public void touchEvent(View view, MotionEvent motionEvent) {

                    }

                    @Override
                    public void drag(View view, MotionEvent motionEvent) {

                    }

                    @Override
                    public void dragEnd(View view) {

                    }
                }).show();


    }

    public interface Callback {
        void permissionReqSuccess();
    }
    
}
