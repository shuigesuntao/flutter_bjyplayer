package com.sun.flutter_bjyplayer.videoplayer.ui.widget;

import android.app.Application;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Build;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

import com.baijiayun.constant.VideoDefinition;
import com.baijiayun.download.DownloadModel;
import com.baijiayun.glide.Glide;
import com.baijiayun.videoplayer.IBJYVideoPlayer;
import com.baijiayun.videoplayer.event.BundlePool;
import com.baijiayun.videoplayer.listeners.OnBufferingListener;
import com.baijiayun.videoplayer.log.BJLog;
import com.baijiayun.videoplayer.player.PlayerStatus;
import com.baijiayun.videoplayer.render.AspectRatio;
import com.baijiayun.videoplayer.ui.utils.NetworkUtils;
import com.baijiayun.videoplayer.ui.widget.BaseVideoView;
import com.baijiayun.videoplayer.ui.widget.ComponentContainer;
import com.baijiayun.videoplayer.util.Utils;
import com.baijiayun.videoplayer.widget.BJYPlayerView;
import com.sun.flutter_bjyplayer.R;

import java.util.ArrayList;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * @author chengang
 * @date 2020-02-05
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.sdk_player.widget
 * @describe
 */
public class NBJYVideoView extends BaseVideoView {
    private static final String TAG = "BJYVideoView";
    protected BJYPlayerView bjyPlayerView;
    private long videoId;
    private String token;
    private boolean encrypted;
    private ImageView audioCoverIv;
    private int mAspectRatio;
    private int mRenderType;
    private boolean isPlayOnlineVideo;
    private PlayerStatus videoStatus;
    private static Application application;

    public NBJYVideoView(@NonNull Context context) {
        this(context, (AttributeSet) null);
    }

    public NBJYVideoView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public NBJYVideoView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        application = (Application) context.getApplicationContext();
        this.mAspectRatio = AspectRatio.AspectRatio_FILL_PARENT.ordinal();
        this.mRenderType = 1;
        this.isPlayOnlineVideo = false;
        TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.BJVideoView, 0, 0);
        if (a.hasValue( R.styleable.BJVideoView_bjy_aspect_ratio)) {
            this.mAspectRatio = a.getInt( R.styleable.BJVideoView_bjy_aspect_ratio, AspectRatio.AspectRatio_FILL_PARENT.ordinal());
        }

        if (a.hasValue( R.styleable.BJVideoView_bjy_render_type)) {
            this.mRenderType = a.getInt( R.styleable.BJVideoView_bjy_render_type, 1);
            if (Build.VERSION.SDK_INT < 21) {
                this.mRenderType = 1;
            }
        }

    }

    @Override
    protected void init(Context context, AttributeSet attrs, int defStyleAttr) {
        this.bjyPlayerView = new NPlayerView(context, attrs);
        this.addView(this.bjyPlayerView);
        this.audioCoverIv = new ImageView(context);
        this.audioCoverIv.setScaleType(ImageView.ScaleType.FIT_XY);
        this.audioCoverIv.setVisibility(GONE);
        this.audioCoverIv.setLayoutParams(new LayoutParams(-1, -1));
        this.addView(this.audioCoverIv);
    }

    public void initPlayer(IBJYVideoPlayer videoPlayer, boolean shouldRenderCustomComponent) {
        this.bjyVideoPlayer = videoPlayer;
        this.bjyVideoPlayer.bindPlayerView(this.bjyPlayerView);
        this.bjyPlayerView.setRenderType(this.mRenderType);
        this.bjyPlayerView.setAspectRatio(AspectRatio.values()[this.mAspectRatio]);
        this.bjyPlayerView.setOnVideoSizeListener((width, height) -> {
            Log.d("bjy", "onVideoSizeChange invoke " + width + ", " + height);
        });
        if (shouldRenderCustomComponent) {
            this.initComponentContainer();
            this.bjyVideoPlayer.addOnPlayerErrorListener((error) -> {
                Bundle bundle = BundlePool.obtain();
                bundle.putString("string_data", error.getMessage());
                this.componentContainer.dispatchErrorEvent(error.getCode(), bundle);
            });
            this.bjyVideoPlayer.addOnPlayingTimeChangeListener((currentTime, duration) -> {
                Bundle bundle = BundlePool.obtainPrivate("controller_component", currentTime);
                this.componentContainer.dispatchPlayEvent(-99019, bundle);
            });
            this.bjyVideoPlayer.addOnBufferUpdateListener((bufferedPercentage) -> {
                Bundle bundle = BundlePool.obtainPrivate("controller_component", bufferedPercentage);
                this.componentContainer.dispatchPlayEvent(-99012, bundle);
            });
            this.bjyVideoPlayer.addOnBufferingListener(new OnBufferingListener() {
                @Override
                public void onBufferingStart() {
                    BJLog.d("bjy", "onBufferingStart invoke");
                    NBJYVideoView.this.componentContainer.dispatchPlayEvent(-80010, (Bundle) null);
                }

                @Override
                public void onBufferingEnd() {
                    BJLog.d("bjy", "onBufferingEnd invoke");
                    NBJYVideoView.this.componentContainer.dispatchPlayEvent(-80011, (Bundle) null);
                }
            });
            this.bjyVideoPlayer.addCubChangeListener((cues) -> {
                Bundle bundle = BundlePool.obtain();
                bundle.putParcelableArrayList("subtitle", (ArrayList) cues);
                this.componentContainer.dispatchCustomEvent((component) -> {
                    return component.getKey().equals("controller_component");
                }, -80019, bundle);
            });
        } else {
            this.useDefaultNetworkListener = false;
        }

        this.bjyVideoPlayer.addOnPlayerStatusChangeListener((status) -> {
            if (status == PlayerStatus.STATE_PREPARED) {
                this.updateAudioCoverStatus(this.bjyVideoPlayer.getVideoInfo() != null && this.bjyVideoPlayer.getVideoInfo().getDefinition() == VideoDefinition.Audio);
                if (this.componentContainer != null && Utils.isEmptyList(this.bjyVideoPlayer.getVideoInfo().getSubtitleItemList())) {
                    this.componentContainer.removeComponent("subtitle_menu_component");
                }
            }

            if (this.componentContainer != null) {
                Bundle bundle = BundlePool.obtain(status);
                this.componentContainer.dispatchPlayEvent(-99031, bundle);
            }

            this.videoStatus = status;
        });
    }

    public void initPlayer(IBJYVideoPlayer videoPlayer) {
        this.initPlayer(videoPlayer, true);
    }

    private void initComponentContainer() {

        if (this.componentContainer == null) {
            this.componentContainer = new ComponentContainer(this.getContext());
            ComponentContainerHelper.getInstance().addContainer(this.componentContainer);
        }
        if (this.componentContainer.getParent() != null) {
            return;
        }
        this.componentContainer.init(this);


        this.componentContainer.setOnComponentEventListener(this.internalComponentEventListener);
        this.addView(this.componentContainer, new android.view.ViewGroup.LayoutParams(-1, -1));
    }

    @Override
    protected void requestPlayAction() {
        super.requestPlayAction();
        if (!this.isPlayOnlineVideo || this.getVideoInfo() != null && this.getVideoInfo().getVideoId() != 0L) {
            this.play();
        } else {
            this.setupOnlineVideoWithId(this.videoId, this.token, this.encrypted);
            this.sendCustomEvent(-80017, (Bundle) null);
        }

    }

    public void setupOnlineVideoWithId(long videoId, String token) {
        this.setupOnlineVideoWithId(videoId, token, true);
    }

    public void setupOnlineVideoWithId(long videoId, String token, boolean encrypted) {
        this.videoId = videoId;
        this.token = token;
        this.encrypted = encrypted;
        if (this.useDefaultNetworkListener) {
            this.registerNetChangeReceiver();
        }

        if (!this.enablePlayWithMobileNetwork && NetworkUtils.isMobile(NetworkUtils.getNetworkState(this.getContext()))) {
            this.sendCustomEvent(-80012, (Bundle) null);
        } else {
            this.bjyVideoPlayer.setupOnlineVideoWithId(videoId, token);
        }

        this.isPlayOnlineVideo = true;
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        ComponentContainerHelper.getInstance().removeContainer(this.componentContainer);

    }

    /**
     * @deprecated
     */
    @Deprecated
    public void setupLocalVideoWithFilePath(String path) {
        this.bjyVideoPlayer.setupLocalVideoWithFilePath(path);
        this.isPlayOnlineVideo = false;
    }

    public void setupLocalVideoWithDownloadModel(DownloadModel downloadModel) {
        this.bjyVideoPlayer.setupLocalVideoWithDownloadModel(downloadModel);
        this.isPlayOnlineVideo = false;
    }

    @Override
    public void updateAudioCoverStatus(boolean isAudio) {
        BJLog.d("updateAudioCoverStatus " + isAudio + ", videoStatus=" + this.videoStatus);
        if (this.videoStatus != PlayerStatus.STATE_PLAYBACK_COMPLETED) {
            if (isAudio) {
                this.audioCoverIv.setVisibility(VISIBLE);
                if (application != null) {
                    Glide.with(application).load(R.drawable.ic_audio_only).into(this.audioCoverIv);
                }
            } else {
                this.audioCoverIv.setVisibility(GONE);
            }

        }
    }
}
