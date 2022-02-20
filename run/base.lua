--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
--写入数据函数

Toolkit={}
Toolkit.putData=function(name,key,value)
  this.getApplicationContext().getSharedPreferences(name,0).edit().putString(key,value).apply()--3255-2732
  return true
end
Toolkit.getData=function(name,key)--验证
  local data=this.getApplicationContext().getSharedPreferences(name,0).getString(key,nil)--325-5273-2
  return data
end
function out64(con)
  local Base64=luajava.bindClass("android.util.Base64")
  return String(Base64.decode(con,Base64.DEFAULT)).toString()
end
function outURL(s)
  local s = string.gsub(s,'%%(%x%x)',function(h) return string.char(tonumber(h,16)) end)
  return s
end

if LuaApplication ~= LuaApplication.getInstance().getClass() then
  print(":( LuaApplication.class_error")
  activity.finish()
end

NCH=function(func)
  import "android.content.Context"
  import "android.net.ConnectivityManager"
  manager = activity.getSystemService(Context.CONNECTIVITY_SERVICE);
  gprs = manager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState();
  if tostring(gprs)== "CONNECTED" then
    func(true,1)
   else
    connManager = activity.getSystemService(Context.CONNECTIVITY_SERVICE)
    mWifi = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
    if tostring(mWifi):find("none") then
      func(false,0)
     else
      func(true,2)
    end
  end
end


Laykit={}
Laykit.ripples=function(id,colors)
--author-pretend
  import "android.content.res.ColorStateList"
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  Pretend=activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{colors}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{colors})))
end


Laykit.flag=function(n)
  window=activity.getWindow()
  window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
  window.setStatusBarColor(n)
  if n==0x3f000000 then
    import "android.os.Build"
    if Build.VERSION.SDK_INT>=23 then
      window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
      window.setStatusBarColor(0xffffffff)
    end
  end
end

function to0x(n)
  if #n==7 then
    nn=n:match("#(.+)")
    nnn=tonumber("0xff"..nn)
   else
    nn=n:match("#(.+)")
    nnn=tonumber("0x"..nn)
  end
  return nnn
end



--copyright © 1999-2020, CSDN.NET, All Rights Reserved
--截取中英混合的UTF8字符串，endIndex可缺省
function SubStringUTF8(str, startIndex, endIndex)
  if startIndex < 0 then
    startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
  end

  if endIndex ~= nil and endIndex < 0 then
    endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
  end

  if endIndex == nil then
    return string.sub(str, SubStringGetTrueIndex(str, startIndex));
   else
    return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
  end
end

--获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
  local curIndex = 0;
  local i = 1;
  local lastCount = 1;
  repeat
    lastCount = SubStringGetByteCount(str, i)
    i = i + lastCount;
    curIndex = curIndex + 1;
  until(lastCount == 0);
  return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
  local curIndex = 0;
  local i = 1;
  local lastCount = 1;
  repeat
    lastCount = SubStringGetByteCount(str, i)
    i = i + lastCount;
    curIndex = curIndex + 1;
  until(curIndex >= index);
  return i - lastCount;
end

--返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
  local curByte = string.byte(str, index)
  local byteCount = 1;
  if curByte == nil then
    byteCount = 0
   elseif curByte > 0 and curByte <= 127 then
    byteCount = 1
   elseif curByte>=192 and curByte<=223 then
    byteCount = 2
   elseif curByte>=224 and curByte<=239 then
    byteCount = 3
   elseif curByte>=240 and curByte<=247 then
    byteCount = 4
  end
  return byteCount;
end


function SubStringUTF8(str, startIndex, endIndex)
  if startIndex < 0 then
    startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
  end

  if endIndex ~= nil and endIndex < 0 then
    endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
  end

  if endIndex == nil then
    return string.sub(str, SubStringGetTrueIndex(str, startIndex));
   else
    return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
  end
end



