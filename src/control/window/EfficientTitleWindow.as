/**
 * Created by WangJian on 2014/8/12.
 */
package control.window {

import flash.geom.Point;

import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

import spark.components.TitleWindow;
import spark.effects.Move;
import spark.effects.Rotate;

public class EfficientTitleWindow extends TitleWindow{

    private var mve:Move = new Move();
    private var rotate:Rotate = new Rotate();
    private var firstPoint:Object = null;

    public function EfficientTitleWindow() {
        super();
        mve.target = this;
        rotate.target = this;
        rotate.autoCenterTransform = true;
        preinit();
    }
    private function preinit():void {
        addEventListener(FlexEvent.CREATION_COMPLETE, showAnimation);
        addEventListener(FlexEvent.SHOW, showAnimation);
        addEventListener(CloseEvent.CLOSE, releaseListener);
        addEventListener(CloseEvent.CLOSE, closeAnimation);


    }

    public function releaseListener(e:CloseEvent):void{
        throw new Error("EfficientTitleWindow 的子类必须重写 releaseListener(e:CloseEvent) 方法。在方法中移除监听外界对象的事件。");
    }

    public function closeWin():void {
        var e:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
        dispatchEvent(e);
    }

    public function showAnimation(e:FlexEvent):void {
        if(mve.isPlaying || rotate.isPlaying){
            return;
        }
        mve.xFrom = 0 - this.width;
        mve.yFrom = (FlexGlobals.topLevelApplication.height - this.height) / 2;
        mve.xTo = (FlexGlobals.topLevelApplication.width - this.width) / 2;
        mve.yTo = (FlexGlobals.topLevelApplication.height - this.height) / 2;
        var pa:Point = new Point(mve.xFrom, mve.yFrom);
        var pb:Point = new Point(mve.xTo, mve.yTo);
        mve.duration = int(Point.distance(pa, pb)) / 100 * 70;
        mve.addEventListener(EffectEvent.EFFECT_END,showAnimation2);

        mve.play();
        firstPoint = {x:mve.xTo,y:mve.yTo};
    }

    public function showAnimation2(e:EffectEvent):void{
        mve.removeEventListener(EffectEvent.EFFECT_END,showAnimation2);
        if(mve.isPlaying || rotate.isPlaying){
            return;
        }
        if (firstPoint!=null && Math.abs((FlexGlobals.topLevelApplication.width - this.width) / 2-firstPoint.x) < 10 && Math.abs((FlexGlobals.topLevelApplication.height - this.height) / 2 - firstPoint.y) < 10){
            return;
        }
        mve.xFrom = this.x;
        mve.yFrom = this.y;
        mve.xTo = (FlexGlobals.topLevelApplication.width - this.width) / 2;
        mve.yTo = (FlexGlobals.topLevelApplication.height - this.height) / 2;
        if (Math.abs(mve.xFrom-mve.xTo) < 10 && Math.abs(mve.yFrom - mve.yTo) < 10){
            rotate.angleFrom = 0;
            rotate.angleTo = 360*3;
            rotate.duration = 1000;
            rotate.play();
        }else{
            var pa:Point = new Point(mve.xFrom, mve.yFrom);
            var pb:Point = new Point(mve.xTo, mve.yTo);
            mve.duration = int(Point.distance(pa, pb)) / 100 * 70;
            mve.play();
        }

    }

    public function closeAnimation(e:*=null):void {
        if(mve.isPlaying || rotate.isPlaying){
            return;
        }
        mve.xFrom = this.x;
        mve.yFrom = this.y;
        mve.xTo = FlexGlobals.topLevelApplication.width;
        mve.yTo = FlexGlobals.topLevelApplication.height;
        var pa:Point = new Point(mve.xFrom, mve.yFrom);
        var pb:Point = new Point(mve.xTo, mve.yTo);
        mve.duration = int(Point.distance(pa, pb)) / 100 * 70;
        mve.addEventListener(EffectEvent.EFFECT_END,closeAnimationEnd);
        mve.play();
    }

    private function closeAnimationEnd(e:EffectEvent):void{
        mve.removeEventListener(EffectEvent.EFFECT_END,closeAnimationEnd);
        PopUpManager.removePopUp(this);
    }
}
}
