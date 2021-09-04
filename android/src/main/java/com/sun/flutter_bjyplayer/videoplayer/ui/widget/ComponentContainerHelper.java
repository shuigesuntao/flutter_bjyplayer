package com.sun.flutter_bjyplayer.videoplayer.ui.widget;

import android.os.Bundle;


import com.baijiayun.videoplayer.ui.component.ControllerComponent;
import com.baijiayun.videoplayer.ui.widget.ComponentContainer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author chengang
 * @date 2021/3/8
 * @email chenganghonor@gmail.com
 * @QQ 1410488687
 * @package_name com.nj.baijiayun.videoplayer.ui.widget
 * @describe
 */
public class ComponentContainerHelper {
    private static volatile ComponentContainerHelper singleton = null;
    private List<ComponentContainer> componentContainerList = new ArrayList<>();
    private Map<ComponentContainer, ControllerComponent> map = new HashMap<>(2);
    private Bundle rateBundle;

    public ComponentContainerHelper() {
    }

    public static ComponentContainerHelper getInstance() {
        if (singleton == null) {
            synchronized (ComponentContainerHelper.class) {
                if (singleton == null) {
                    singleton = new ComponentContainerHelper();
                }
            }
        }
        return singleton;
    }


    void addContainer(ComponentContainer componentContainer) {
        this.componentContainerList.add(componentContainer);
    }

    void addControllerComponent(ComponentContainer componentContainer, ControllerComponent controllerComponent) {
        this.map.put(componentContainer, controllerComponent);
    }

    void removeContainer(ComponentContainer componentContainer) {
        if (componentContainer != null) {
            this.componentContainerList.remove(componentContainer);
            this.map.remove(componentContainer);
        }
    }

    public List<ComponentContainer> getComponentContainerList() {
        return componentContainerList;
    }

    public ComponentContainer getOtherControllerComponent() {
        if (this.componentContainerList.size() > 1) {
            return this.componentContainerList.get(0);
        }
        return null;
    }

    public ComponentContainer getCurrentControllerComponent() {
        if (this.componentContainerList.size() > 0) {
            return this.componentContainerList.get(this.componentContainerList.size() - 1);
        }
        return null;
    }

    public Bundle getRateBundle() {
        return rateBundle;
    }
    public void clearRateBundle(){
        this.rateBundle=new Bundle();
    }

    /**
     * 参考ControllerComponent
     */
    public void setRateBundle(Bundle rateBundle) {
        if (rateBundle != null) {
            int type = rateBundle.getInt("type", -1);
            if (type == 1) {
                //copy下来 sdk可能发送完消息clear bundle
                this.rateBundle = (Bundle) rateBundle.clone();
            }
        }
    }
}
