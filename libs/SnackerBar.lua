--比寒哥的更好用，更好看，更专业的SnackerBar
import "android.animation.Animator"
--支持自定义文字，按钮动作，按钮文字，
--事实上，完全自定义
--支持滑动删除，支持面向对象式调用
--触碰时不会关闭，可无期限查看
--近乎原生体验
--使用方法:
-- 1.导入模块 import "SnackerBar"
-- 2.调用：SnackerBar.build()
--        :msg("提示文字"):actionText("按钮文字")
--        :action(按钮点击事件):show()
--  （记得使用冒号哦!)


SnackerBar={shouldDismiss=true}
import "android.animation.ValueAnimator"
local w=activity.width
import "android.view.animation.AccelerateDecelerateInterpolator"

local layout={
  LinearLayout,
  Gravity="bottom",
  {
    LinearLayout,
    layout_height=-2,
    layout_width=-1,
    Gravity="center",
    BackgroundColor=0xff1C1C1C,
    {
      TextView,
      textColor=0xffFCFAF2,
      layout_weight=.8,
      paddingLeft="10dp",
      paddingTop="5dp",
      paddingBottom="5dp",
      layout_width=0,
    },
    {
      Button,
      layout_height=-2,
      style="?android:attr/buttonBarButtonStyle",
      text="DONE",
      textColor=0xFFFFFFFB,
    }
  }
}
local function addView(view)
  local mLayoutParams=ViewGroup.LayoutParams
  (-1,-1)
  activity.Window.DecorView.addView(view,mLayoutParams)
end

local function removeView(view)
  activity.Window.DecorView.removeView(view)
end
--设置提示文字
function SnackerBar:msg(textMsg)
  self.textView.text=textMsg
  return self
end
--设置按钮文字
function SnackerBar:actionText(textAction)
local ripples=function(id,colors)
  import "android.content.res.ColorStateList"
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  Pretend=activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{colors}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{colors})))
end
  ripples(self.actionView,0xFFF4F4F2)
  self.actionView.text=textAction
  return self
end
--设置按钮动作
function SnackerBar:action(func)
  self.actionView.onClick=
  function()
    func()
    self:dismiss()
  end
  return self
end

--显示
function indefiniteDismiss(snackerBar)
  task(4000,function()
    if snackerBar.shouldDismiss==true then
      snackerBar:dismiss()
     else
      indefiniteDismiss(snackerBar)
    end
  end)
end


function SnackerBar:show()
  local view=self.view
  addView(view)
  view.translationY=300
  view.animate().translationY(0)
  .setInterpolator(AccelerateDecelerateInterpolator())
  .setDuration(500).start()
 -- print(01)
  indefiniteDismiss(self)
end



--关闭
function SnackerBar:dismiss()
  local view=self.view
  view.animate().translationY(300)
  .setDuration(400)
  .setListener(Animator.AnimatorListener{
    onAnimationEnd=function()
      removeView(view)
    end
  }).start()
end

SnackerBar.__index=SnackerBar
--构建者模式
function SnackerBar.build()
  local mSnackerBar={}
  setmetatable(mSnackerBar,SnackerBar)
  mSnackerBar.view=loadlayout(layout)
  mSnackerBar.bckView=mSnackerBar.view
  .getChildAt(0)
  mSnackerBar.textView=mSnackerBar.bckView
  .getChildAt(0)
  mSnackerBar.actionView=mSnackerBar.bckView
  .getChildAt(1)
  local function animate(v,tx,dura)
    ValueAnimator().ofFloat({v.translationX,tx}).setDuration(dura)
    .addUpdateListener( ValueAnimator.AnimatorUpdateListener
    {
      onAnimationUpdate=function( p1)
        local f=p1.animatedValue
        v.translationX=f
        v.alpha=1-math.abs(v.translationX)/w
      end
      }).addListener(ValueAnimator.AnimatorListener{
      onAnimationEnd=function()
        if math.abs(tx)>=w then
          removeView(mSnackerBar.view)
        end
      end
    }).start()
  end
  local frx,p,v,fx=0,0,0,0
  mSnackerBar.bckView.setOnTouchListener(View.OnTouchListener{
    onTouch=function(view,event)
      if event.Action==event.ACTION_DOWN then
        mSnackerBar.shouldDismiss=false
        frx=event.x
        fx=event.x
       elseif event.Action==event.ACTION_MOVE then
        --高精度手指速度测量:)
        if math.abs(event.rawX-frx)>=2 then
          v=math.abs((frx-event.rawX)/(os.clock()-p)/1000)
        end
        p=os.clock()
        frx=event.rawX
        view.translationX=frx-fx
        view.alpha=1-math.abs(view.translationX)/w
       elseif event.Action==event.ACTION_UP then
        mSnackerBar.shouldDismiss=true
        local tx=view.translationX
        if tx>=w/5 then
          animate(view,w,(w-tx)/v)
         elseif tx>0 and tx<w/5 then
          animate(view,0,tx/v)
         elseif tx<=-w/5 then
          animate(view,-w,(w+tx)/v)
         else
          animate(view,0,-tx/v)
        end
        fx=0
      end
      return true
    end
  })
  return mSnackerBar
end

--二次打包类库，一行实现（sudoskys）
function snack_bar(mess,act,func)
  if mess==nil then
    mess="The content of this message is lost"
  end
  if act==nil then
    act="OK"
  end
  if func==nil then
    func=function() end
  end
  SnackerBar.build()
  :msg(tostring(mess))
  :actionText(tostring(act))
  :action(function()
    func()
  end)
  :show()
end
