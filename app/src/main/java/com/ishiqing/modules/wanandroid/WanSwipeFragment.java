package com.ishiqing.modules.wanandroid;

import android.view.View;

import com.alibaba.android.arouter.launcher.ARouter;
import com.ishiqing.R;
import com.ishiqing.base.fragment.BaseSwipeFragment;

import butterknife.OnClick;

/**
 * 玩Android组件化客户端
 * <p>
 * ARouter
 * https://github.com/alibaba/ARouter/blob/master/README_CN.md
 * <p>
 * Created by javakam on 2018-7-3 .
 */
public class WanSwipeFragment extends BaseSwipeFragment {

    @Override
    protected int getLayoutResId() {
        return R.layout.fragment_wan_android;
    }

    @Override
    protected void initViews(View v) {
        initTopBar("玩Android", true);
    }

    @OnClick(R.id.btWanAndroid)
    void wan(View v) {
        if (v.getId() == R.id.btWanAndroid) {
            ARouter.getInstance().build("/sq/mainactivity")
                    .withLong("key1", 666L)
                    .withString("key3", "888")
//                    .withObject("key4", new Object())
                    .navigation();
        }
    }
}