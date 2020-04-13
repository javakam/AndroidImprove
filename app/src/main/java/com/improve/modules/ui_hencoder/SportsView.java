package com.improve.modules.ui_hencoder;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Build;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;


// github https://github.com/rengwuxian/HenCoderPlus
// video https://ke.qq.com/webcourse/index.html#cid=334710&term_id=100397234&taid=2798467546422134&vid=5285890786251677089

public class SportsView extends View {

    private static final float RING_WIDTH = dp2px(20);
    private static final float RADIUS = dp2px(150);
    private static final int CIRCLE_COLOR = Color.parseColor("#90A4AE");
    private static final int HIGHLIGHT_COLOR = Color.parseColor("#FF4081");

    Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    Rect rect = new Rect();
    Paint.FontMetrics fontMetrics = new Paint.FontMetrics();

    public SportsView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    {
        paint.setTextSize(dp2px(100));
        paint.setTypeface(Typeface.createFromAsset(getContext().getAssets(), "Quicksand-Regular.ttf"));
        paint.getFontMetrics(fontMetrics);
        paint.setTextAlign(Paint.Align.CENTER);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        // 绘制环
        paint.setStyle(Paint.Style.STROKE);
        paint.setColor(CIRCLE_COLOR);
        paint.setStrokeWidth(RING_WIDTH);
        canvas.drawCircle(getWidth() / 2, getHeight() / 2, RADIUS, paint);

        // 绘制进度条
        paint.setColor(HIGHLIGHT_COLOR);
        paint.setStrokeCap(Paint.Cap.ROUND);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            canvas.drawArc(getWidth() / 2 - RADIUS, getHeight() / 2 - RADIUS, getWidth() / 2 + RADIUS, getHeight() / 2 + RADIUS, -90, 225, false, paint);
        }

        // 绘制文字
        paint.setTextSize(dp2px(100));
        paint.setStyle(Paint.Style.FILL);
        paint.setTextAlign(Paint.Align.CENTER);
//        paint.getTextBounds("abab", 0, "abab".length(), rect);
        float offset = (fontMetrics.ascent + fontMetrics.descent) / 2;
        canvas.drawText("abab", getWidth() / 2, getHeight() / 2 - offset, paint);
    }

    private static float dp2px(float dp) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, Resources.getSystem().getDisplayMetrics());
    }
}