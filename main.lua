--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

import "res.value"
import "run.base"
import "libs.SnackerBar"


import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"
import "com.androlua.LuaAdapter"
import "android.widget.ListView"
import "android.graphics.Paint"

import "layout.formal.titlebar"
--import "com.androlua.Http"

activity.setTitle('Tiebar+')
--activity.setTheme(android.R.style.Theme_Holo_Light)
--activity.ActionBar.hide()--隐藏标题栏
--After checking, start loading layout.
Laykit.flag(to0x(draw.weak))
activity.setContentView(loadlayout("layout/formal/titlebar"))
NCH(function(is,msg)
  --print(is,msg)
  if msg==1 then
    --snack_bar( "注意流量","OK",function() end)
  end
end)
--ACA()
if Toolkit.getData("tiebar","isok")=="yes" then else
  activity.newActivity("run/verify")
end


--Set the progress color
loadbar.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(to0x(draw.strong),PorterDuff.Mode.SRC_ATOP))
title.setText("Tiebar")
title.getPaint().setFakeBoldText(true)
Laykit.ripples(sett,to0x(draw.strong))
Laykit.ripples(exit,to0x(draw.strong))

exit.onClick=function()
  activity.finish()
end
sett.onClick=function()
  activity.newActivity("run/about")
end

--隐藏ActionBar

snack_bar("您现在使用的是 未开发完全的测试版本!","OK",function() end)

import "layout.item"
import "android.view.animation.LayoutAnimationController"
import "android.view.animation.AnimationUtils"
mainlays.addView(loadlayout(
{
  ListView;
  dividerHeight="0";
  layout_width="fill";
  background=draw.back;
  layout_height="fill";
  id="notelist";
}
))
sett.setVisibility(0)
datas={}
adp=LuaMultiAdapter(activity,subitems) --创建列表适配器
--adp=LuaAdapter(activity,datas,subitems)
notelist.Adapter=adp
animation = AnimationUtils.loadAnimation(activity,android.R.anim.fade_in)
lac = LayoutAnimationController(animation)
lac.setOrder(LayoutAnimationController.ORDER_NORMAL)
lac.setDelay(0.2)--单位是秒
--listView.setAdapter(adp)
notelist.setLayoutAnimation(lac)



--运行与回调函数，拆分模块，更好组合，线程同步方案请求数据回调
import"run.api"
--调用构造器
key,pagelist=Tieba:pageGet("v",3)
--传入数据参数，与标识
data=thread(Tieba.datasocket,pagelist,1,key)
--data=thread(Tieba.datasocket,pagelist,1,key)
--回调处理数据
function callbk(dat,kind)
  ls=(Toolkit.StrToTable(dat))
  --ls=luajava.astable(tables)
  if ls then
    --排序
    table.sort(ls,function(a,b)
      return (tonumber(a["index"])>tonumber(b["index"]))
    end)
   else
  end
  --print(ls[1]["code"])
  --解析器

  nolist.setVisibility(View.GONE)
  loadbar.setVisibility(View.GONE)
  for i,k in pairs(ls) do
    function out64(con)
      local Base64=luajava.bindClass("android.util.Base64")
      return String(Base64.decode(con,Base64.DEFAULT)).toString()
    end
    doc = Jsoup.parse(out64(k["data"]))--使用jsoup解析网页
    classification = doc.select('div.i')--查找到所有class为text-gray的网页元素
    classification = luajava.astable(classification)--将其转换成table表
    for k,v in pairs(classification) do--循环打印输出
      data=(v.html():match('href="(.-)"'))
      --m?kz=7724785578&amp;is_bakan=0&amp;lp=5010&amp;pinf=1_2_1
      kz=data:match('kz=(.-)&amp;')
      is_bakan=data:match('is_bakan=(.-)&amp;')
      lp=data:match('lp=(.-)&amp;')
      data=info(tostring(v.getElementsByTag("p")))
      cons=tostring(v.getElementsByTag("a")):match('&nbsp;(.-)</a>')
      cons=cons:gsub("&nbsp;","")
      like=data[1];unlike=data[2];author=data[3];datet=data[4]
      if author==nil or author=="" then author="贴吧" end
      adp.add{__type=4,name=author,content=cons,img=nil,date=datet,comment=unlike,lp=lp,is_bakan=is_bakan,kz=kz}
      --adp.add{lp=lp,name=v.text(),is_bakan=is_bakan,kz=kz}
    end
  end
end

function onDestroy()
  --glideget.clearMemory()
  collectgarbage("collect")
  System.gc()
  activity.finishAndRemoveTask()
end


notelist.onItemClick=function(parent,v,pos,id)
  b=v.Tag.name.text --v.Tag.username.text取要回复的人的昵称
  u=v.Tag.kz.text
  i=v.Tag.content.text
  -- print(u)
  --print(b)
  activity.getGlobalData()["id"]=u
  activity.getGlobalData()["title"]=i
  activity.newActivity("run/sub/itemlay",android.R.anim.fade_in,android.R.anim.fade_out ,{u})
end


