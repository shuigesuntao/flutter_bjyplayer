package com.sun.flutter_bjyplayer.utils;


import android.app.Dialog;
import android.content.Context;
import android.text.Html;
import android.text.TextUtils;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.sun.flutter_bjyplayer.R;

import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.StringRes;


/**
 * @project zywx_android
 * @class name：com.baijiayun.baselib.widget.dialog
 * @describe
 * @anthor houyi QQ:1007362137
 * @time 18/11/21 下午5:49
 * @change
 * @time
 * @describe
 */
public class CommonMDDialog extends Dialog {
    private String mContent;
    private String mTitle;
    private String mPositive;
    private String mNegative;
    private TextView mTitleTxt;
    private TextView mContentTxt;
    private TextView mPositiveTxt;
    private TextView mNegativeTxt;
    private View mDividerView;
    private LinearLayout mContainerLayout;
    private View.OnClickListener mPositiveClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (mPositiveListener != null) {
                mPositiveListener.positiveClick();
            } else {
                dismiss();
            }
        }
    };
    private View.OnClickListener mNegativeClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (mNegativeListener != null) {
                mNegativeListener.negativeClick();
            } else {
                dismiss();
            }
        }
    };
    private OnPositiveClickListener mPositiveListener;
    private OnNegativeClickListener mNegativeListener;

    public CommonMDDialog(@NonNull Context context) {
        this(context, R.style.BasicCommonDialog);
    }

    public CommonMDDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId);
        setContentView(R.layout.common_dialog);
        mNegativeTxt = findViewById(R.id.negative_txt);
        mPositiveTxt = findViewById(R.id.positive_txt);
        mTitleTxt = findViewById(R.id.tv_title);
        mDividerView = findViewById(R.id.divider_view);
        mContentTxt = findViewById(R.id.content_txt);
        mContainerLayout = findViewById(R.id.container_layout);
        mPositiveTxt.setOnClickListener(mPositiveClickListener);
        mNegativeTxt.setOnClickListener(mNegativeClickListener);
//        mContentTxt.setMovementMethod(ScrollingMovementMethod.getInstance());

    }

    public CommonMDDialog setCustomView(@LayoutRes int layoutIds) {
        return setCustomView(View.inflate(getContext(), layoutIds, null));
    }

    public CommonMDDialog setCustomView(View view) {
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        mContainerLayout.addView(view, 1, params);
        return this;
    }

    public CommonMDDialog setContentTxt(@StringRes int strIds) {
        return setContentTxt(getContext().getString(strIds));
    }


    public CommonMDDialog setContentTxt(String content) {
        this.mContent = content;
        mContentTxt.setVisibility(View.VISIBLE);
        mContentTxt.setText(Html.fromHtml(mContent));
        return this;
    }

    public TextView getContentTxt() {
        return mContentTxt;
    }

    public CommonMDDialog setTitleTxt(@StringRes int strIds) {
        return setTitleTxt(getContext().getString(strIds));
    }

    public CommonMDDialog setTitleTxt(String title) {
        this.mTitle = title;
        mTitleTxt.setText(mTitle);
        return this;
    }

    public CommonMDDialog hideTitle() {
        mTitleTxt.setVisibility(View.GONE);
        mContentTxt.setBackgroundResource(R.drawable.common_dialog_no_title_content_bg);
        return this;
    }

    public CommonMDDialog setPositiveTxt(@StringRes int strIds) {
        return setPositiveTxt(getContext().getString(strIds));
    }

    public CommonMDDialog setPositiveTxt(String title) {
        this.mPositive = title;
        mPositiveTxt.setVisibility(View.VISIBLE);
        mPositiveTxt.setText(mPositive);
        if (!TextUtils.isEmpty(mNegative)) {
            mDividerView.setVisibility(View.VISIBLE);
        }
        return this;
    }

    public CommonMDDialog setNegativeTxt(@StringRes int strIds) {
        return setNegativeTxt(getContext().getString(strIds));
    }

    public CommonMDDialog setNegativeTxt(String title) {
        this.mNegative = title;
        mNegativeTxt.setVisibility(View.VISIBLE);
        mNegativeTxt.setText(mNegative);
        if (!TextUtils.isEmpty(mPositive)) {
            mDividerView.setVisibility(View.VISIBLE);
        }
        return this;
    }

    @Override
    public void show() {
        super.show();
        Window window = getWindow();
        Display display = window.getWindowManager().getDefaultDisplay();
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = (int) (display.getWidth() * 0.8);
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        window.setAttributes(params);
    }


    public CommonMDDialog setOnPositiveClickListener(OnPositiveClickListener positiveClickListener) {
        this.mPositiveListener = positiveClickListener;
        return this;
    }

    public CommonMDDialog setOnNegativeClickListener(OnNegativeClickListener negativeClickListener) {
        this.mNegativeListener = negativeClickListener;
        return this;
    }

    public CommonMDDialog setOnClickListener(OnClickListener clickListener) {
        this.mNegativeListener = clickListener;
        this.mPositiveListener = clickListener;
        return this;
    }

    public interface OnNegativeClickListener {
        void negativeClick();
    }

    public interface OnPositiveClickListener {
        void positiveClick();
    }

    public interface OnClickListener extends OnNegativeClickListener, OnPositiveClickListener {
    }
}

