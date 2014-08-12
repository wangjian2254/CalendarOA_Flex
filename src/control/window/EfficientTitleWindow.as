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

public class EfficientTitleWindow extends TitleWindow{

    private var mve:Move = new Move();

    public function EfficientTitleWindow() {
        super();
        mve.target = this;
        preinit();
    }
    private function preinit():void {
        addEventListener(FlexEvent.CREATION_COMPLETE, showAnimation);
        addEventListener(FlexEvent.SHOW, showAnimation);
        addEventListener(CloseEvent.CLOSE, closeAnimation);

    }
    public function closeWin():void {
        var e:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
        dispatchEvent(e);
    }

    public function showAnimation(e:FlexEvent):void {
        if(mve.isPlaying){
            return;
        }
        mve.xFrom = 0 - this.width;
        mve.yFrom = (FlexGlobals.topLevelApplication.height - this.height) / 2;
        mve.xTo = (FlexGlobals.topLevelApplication.width - this.width) / 2;
        mve.yTo = (FlexGlobals.topLevelApplication.height - this.height) / 2;
        var pa:Point = new Point(mve.xFrom, mve.yFrom);
        var pb:Point = new Point(mve.xTo, mve.yTo);
        mve.duration = int(Point.distance(pa, pb)) / 100 * 70;
        mve.play();
    }

    public function closeAnimation(e:*=null):void {
        if(mve.isPlaying){
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
