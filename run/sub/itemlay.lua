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

loadbar.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(to0x(draw.strong),PorterDuff.Mode.SRC_ATOP))
txt=activity.getGlobalData()["title"]
if utf8.len(txt)>12 then
  su=SubStringUTF8(txt,1,10).."..."
 else
  su=txt
end

title.setText("������ "..su)
title.textSize=16
title.getPaint().setFakeBoldText(true)
--Laykit.ripples(search,to0x(sancolor))
Laykit.ripples(exit,to0x(sancolor))
sett.setVisibility(4)
exit.onClick=function()
  activity.finish()
end
--隐藏ActionBar

--snack_bar("您现在使用的是 未开发完全的测试版本!","OK",function() end)

import "layout.item"
import "android.view.animation.LayoutAnimationController"
import "android.view.animation.AnimationUtils"
mainlays.addView(loadlayout(
{
  LinearLayout;
  orientation="vertical";
  background=draw.back;
  layout_width="fill";
  layout_height="fill";
  {
    ListView;
    dividerHeight="0";
    layout_width="fill";
    background=draw.back;
    layout_height="fill";
    id="notelist";
  };
}
))

datas={}
adp=LuaMultiAdapter(activity,subitems) --创建列表适配器
--adp=LuaAdapter(activity,datas,subitems)
notelist.Adapter=adp
animation = AnimationUtils.loadAnimation(activity,android.R.anim.fade_in)
lac = LayoutAnimationController(animation)
lac.setOrder(LayoutAnimationController.ORDER_NORMAL)
lac.setDelay(0.7)--单位是秒
--listView.setAdapter(adp)
notelist.setLayoutAnimation(lac)

--import"run.arrange"
nolist.onClick=function()
  --request_mess("STUDY_mys","main/homes.md")
end

kz=...
--kz=activity.getGlobalData()["id"]
--request_page(2,kz)
--运行与回调函数，拆分模块，更好组合，线程同步方案请求数据回调
import"run.api"
--调用构造器
key,pagelist=Tieba:commentGet(kz,0)
--传入数据参数，与标识
header = ({
  ['Host']= 'tieba.baidu.com',
  ['Connection']= 'keep-alive',
  ['Cache-Control']= 'max-age=0',
  ['Upgrade-Insecure-Requests']= '1',
  ['User-Agent']= 'Mozilla/5.0 (Linux; Android 6.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36',
  ['Accept']= 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
  ['Accept-Encoding']= 'gzip, deflate',
  ['Accept-Language']= 'zh-CN,zh;q=0.9',
})

Http.get(tostring(URLs),"COOKIE=ss;","utf8",header,function(code,content,cookie,header)
  star(content)
end)
--data=thread(Tieba.datasocket,pagelist,1,key)



star=function(content)
  import'org.jsoup.*'
  doc = Jsoup.parse(content)--使用jsoup解析网页
  classification = doc.select('input')--查找到所有class为text-gray的网页元素
  classification = luajava.astable(classification)--将其转换成table表
  for k,v in pairs(classification) do--循环打印输出
    if (v.attr("name"))=="pnum" then
      total=(v.attr("size"))
    end
  end
  if total then;else
    total=1
  end
  import "libs.SnackerBar"
  snack_bar(tostring(total).."页","OK",function() end)
  data=thread(Tieba.datasocket,pagelist,total,key)
end



--回调处理数据
function callbk(dat,kind)
  import "android.content.Context"
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
    if i==1 then
      activity.getGlobalData()["num"]=0
    end
    import "run.base"
    function addimg()
      lay={
        LinearLayout,
        layout_height="30%w";
        layout_width="44%w";
        {
          CardView,
          elevation="4dp",
          radius="3dp",
          layout_margin="4dp",
          --layout_marginRight="4dp",
          {
            LinearLayout,
            {
              ImageView,
              id="imgs",
              layout_height="30%w";
              layout_width="44%w";
              scaleType="centerCrop";
              -- src="",
            },
            {
              TextView;
              textSize="0";
              id="imgid";
            };
          },
        },
      }
      return lay
    end
    item=addimg()

    import "run.base"
    NCH(function(is,msg)
      --print(is,msg)
      if msg==1 then
        --snack_bar( "注意流量","OK",function() end)
        NOphoto=true
      end
    end)

    doc = Jsoup.parse(out64(k["data"]))--使用jsoup解析网页
    classification = doc.select('div.i')--查找到所有class为text-gray的网页元素
    classification = luajava.astable(classification)--将其转换成table表
    for k,v in pairs(classification) do--循环打印输出
      imghtml=v.getElementsByClass("BDE_Image")
      rs=tostring(v.getElementsByTag("a").text())
      --con=v.ownText()
      --print(v)
      floor=(v.text():match('(%d+)[楼.]'))
      con=(v.ownText():match("楼.(.+)"))
      if con==nil then con="" end
      imgt={}
      for i,k in pairs(luajava.astable(imghtml)) do
        if k.hasAttr("src") then
          img=k.attr("src")
          imgurl=outURL(img:match("src=(.+)"))
          --con=con.." [图片]"..imgurl
          if NOphoto then tarurl=img else tarurl=imgurl end
          table.insert(imgt,{imgs={src=tarurl},imgid={text=imgurl}})
        end
      end
      name=v.getElementsByClass("g").text()
      time=(v.getElementsByClass("b").text())
      if tonumber(floor)<=tonumber(activity.getGlobalData()["num"]) then
        --break
      end
      activity.getGlobalData()["num"]=floor
      adp.add{__type=5,name=name,content=con,date=time,floor=tostring(floor).."楼",imglist={Adapter=LuaAdapter(activity,imgt,item),onItemClick=function(parent,v,pos,id)
            url=v.Tag.imgid.text --v.Tag.username.text取要回复的人的昵称
            this.newActivity("run/photoView.lua",android.R.anim.fade_in,android.R.anim.fade_out,{url})
            --print(b)
            -- activity.getGlobalData()["id"]=u
            -- activity.getGlobalData()["title"]=i
            -- activity.newActivity("run/sub/itemlay",{kz=u})
      end}}
    end
  end
end


notelist.onItemClick=function(parent,v,pos,id)
  b=v.Tag.name.text --v.Tag.username.text取要回复的人的昵称
  print(b)
end


function onDestroy()
  --glideget.clearMemory()
  collectgarbage("collect")
  System.gc()
  activity.finishAndRemoveTask()
end
