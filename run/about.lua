require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Typeface"
import "android.text.style.*"
import "java.io.File"
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"

import "run.base"
import "res.value"

import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"


activity.setTitle('Tiebar+')
Laykit.flag(to0x(draw.weak))
activity.setContentView(loadlayout("layout/about"))
loadbar.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(to0x(draw.strong),PorterDuff.Mode.SRC_ATOP))
title.setText("设置")
title.textSize=18
title.getPaint().setFakeBoldText(true)
--Laykit.ripples(search,to0x(sancolor))
Laykit.ripples(exit,to0x(sancolor))
exit.onClick=function()
  activity.finish()
end



function putData(name,key,value)
  this.getApplicationContext().getSharedPreferences(name,0).edit().putString(key,value).apply()--3255-2732
  return true
end
function getData(name,key)
  local data=this.getApplicationContext().getSharedPreferences(name,0).getString(key,nil)--325-5273-2
  return data
end
function listenSwitch(ID,path)
  --启动模式选择监听
  if pcall(function()
      path=tostring(path)
      ID.setOnCheckedChangeListener{
        onCheckedChanged=function(g,c)
          if c==true then
            putData("switch",path,"true")
            setSwitchC(ID,to0x(draw.weak),to0x(draw.dead))
            --   io.open(path,"w+"):write("true"):close()
           else
            setSwitchC(ID,to0x(draw.strong),to0x(draw.weak))
            -- io.open(path,"w+"):write("false"):close()
            putData("switch",path,"false")
          end
      end}
      if getData("switch",path)=="true" then
        ID.setChecked(true)
        setSwitchC(ID,to0x(draw.weak),to0x(draw.dead))
       else
        ID.setChecked(false)
        setSwitchC(ID,to0x(draw.strong),to0x(draw.weak))
      end
    end) then
   else
    print("premisson need-权限")
  end
end
function setSwitchC(ID,Groove,Keys)
  if pcall(function()
      ID.ThumbDrawable.setColorFilter(PorterDuffColorFilter(Groove,PorterDuff.Mode.SRC_ATOP))
      ID.TrackDrawable.setColorFilter(PorterDuffColorFilter(Keys,PorterDuff.Mode.SRC_ATOP))
    end) then else
    print("unknown wrong")
  end
end


listenSwitch(issave,"是否保存")
listenSwitch(ispubu,"是否瀑布")
--setSwitchC(issave,to0x(draw.weak),to0x(draw.dead))
--setSwitchC(ispubu,to0x(draw.weak),to0x(draw.dead))


function ttf(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end

activity.overridePendingTransition(android.R.anim.slide_in_left,android.R.anim.fade_out)

function GetAppVer(pkg,kind)
  import "android.content.pm.PackageManager"
  local num = activity.getPackageManager().getPackageInfo(pkg, 0).versionCode
  local name = activity.getPackageManager().getPackageInfo(pkg, 0).versionName
  if kind==nil then
    return name
   else
    return num
  end
end

--
--[[
Thread(Runnable({--java线程处理耗时的网络请求，继承runnable
  run=function()
    --update()
  end
})).start()
]]

--https://api.github.com/repos/sudoskys/tiebar


import "run.Gitkit"
--cjson=require ("cjson")
Github = Git:new("api.github.com",{debug=false,filemirror="raw.githubusercontent.com"})
--回调示例
Github:User({i="sudoskys"},function(con)
  if con["login"] then
    --userimg = json["avatar_url"];
    avatar= con["avatar_url"]
    name= con["login"]
    bio=con["bio"]
    update=con["updated_at"]
    d1name.setText(name)
    d1intro.setText(bio.." "..update)
    Glide.with(this)
    .load(avatar)
    .centerCrop()
    .skipMemoryCache(true)
    .diskCacheStrategy(DiskCacheStrategy.NONE)
    .into(d1pic)
    Glide.with(this)
    .load(avatar)
    .centerCrop()
    .skipMemoryCache(true)
    .diskCacheStrategy(DiskCacheStrategy.NONE)
    .into(intropic)
  end
end)
--[[
    Picasso.with(this)
    .load(avatar)
    .into(d1pic);
    Picasso.with(this)
    .load(avatar)
    .into(intropic);

--]]

