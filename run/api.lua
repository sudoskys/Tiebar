require "import"
import "android.util.Base64"
--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
info =function(strs)
  con = strs:gmatch("[>|;](.-)[&|<]")
  i=0;tables=[]
  for k in (con) do
    i=i+1
    -- print(i)
    tables[i]=k
  end
  return tables
end
--发起队列 ，请求队列
Tieba = {}
function Tieba:new(domain,p)
  local funt = {}
  setmetatable(funt, self)
  self.__index = self
  self.domain=domain
  self.HOME = activity.getLuaDir()
  self.sudo = ("sudoskys")
  self.header = ({
    ['Host']= 'tieba.baidu.com',
    ['Connection']= 'keep-alive',
    ['Cache-Control']= 'max-age=0',
    ['Upgrade-Insecure-Requests']= '1',
    ['User-Agent']= 'Mozilla/5.0 (Linux; Android 6.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36',
    ['Accept']= 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    ['Accept-Encoding']= 'gzip, deflate',
    ['Accept-Language']= 'zh-CN,zh;q=0.9',
  })
  return funt
end
Toolkit={}
Toolkit.putData=function(name,key,value)
  this.getApplicationContext().getSharedPreferences(name,0).edit().putString(key,value).apply()--3255-2732
  return true
end
Toolkit.getData=function(name,key)--验证
  local data=this.getApplicationContext().getSharedPreferences(name,0).getString(key,nil)--325-5273-2
  return data
end
Toolkit.StrToTable=function (str)
  return loadstring("return " .. str)()
end

import'org.jsoup.*'
--构造器[对页数要求严格，ps]
--2 http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kz=7728520202&new_word=&pinf=1_2_0&pn=30&lp=6021
--3 http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kz=7728520202&new_word=&pinf=1_2_0&pn=60&lp=6021
function Tieba:commentGet(ID,endpn)
  if ID==nil or endpn==nil or endpn<0 then print("请求格式出错") return false else
    tasks={}
    for i=0,endpn do
      url1 = 'http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kz='
      url2 = '&new_word=&pinf=1_2_0&pn='.. tostring((i)*30)
      --print(url2)
      url3 = '&lp=6021'
      URLs = url1..tostring(ID)..url2..url3
      getkey=ID..tostring(i)
      table.insert(tasks,{page=i+1,url=URLs})
    end
    --print(dump(task))
    return (ID..tostring(endpn)),dump(tasks)
  end
end


--构造器
--2 http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kw=v&lp=5011&lm=&pinf=1&pn=20
--3 http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kw=v&lp=5011&lm=&pinf=1&pn=40
function Tieba:pageGet(key,endpn)
  if key==nil or endpn==nil or endpn<0 then print("请求格式出错") return false else
    --构造队列
    tasks={}
    for i=0,endpn do
      urls ="http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kw="
      slru="&lp=5011&lm=&pn="
      URLs=urls..key..slru..tostring(i*20)
      table.insert(tasks,{page=i+1,url=URLs})
    end
    --print(dump(task))
    return (key..endpn),dump(tasks)
  end
end



--请求器，只负责存储网页源码
function Tieba.datasocket(pagelist,kind,key)
  require "import"
  function in64(con)
    local Base64=luajava.bindClass("android.util.Base64")
    return Base64.encodeToString(String(con).getBytes(),Base64.NO_WRAP);
  end
  function out64(con)
    local Base64=luajava.bindClass("android.util.Base64")
    return String(Base64.decode(con,Base64.DEFAULT)).toString()
  end
  --巡查器
  function dog(key)
    older=activity.getGlobalData()[key]
    time=os.date("%Y%m%d%H%M%S")
    if not older then
      --20220217191505
      activity.getGlobalData()[key]=tonumber(time)
      return true
     else
      if (tonumber(time)-tonumber(older))>2000 then
        return true
       else
        activity.getGlobalData()[key]=tonumber(time)
        return false
      end
    end
  end

  function reverseTable(tab)
    local tmp = {}
    for i = 1, #tab do
      local key = #tab+1-i
      tmp[i] = tab[key]
    end
    return tmp
  end
  function getPage(pagelist)
    test={}
    for i,k in pairs(pagelist) do
      --print(dump(k))
      len=#(k['url'])
      --数据请求
      require "import"
      import "http"
      body,cookie,code,headers=http.get(k['url'])
      table.insert(test,{index=k["page"],data=in64(body),code=code,cookie=in64(cookie)})
    end
    -- test=reverseTable(test)
    return test
  end
  Thread.sleep(700)--延迟1000毫秒
  --线程内不能更新UI
  pagelist=loadstring("return " .. pagelist)()
  if dog(key) or activity.getGlobalData()[key.."_sata"]==nil then
    --验证历史
    data= getPage(pagelist)
    activity.getGlobalData()[key.."_sata"]=dump(data)
    --复用数据
   else
    --print("复用")
    data=activity.getGlobalData()[key.."_sata"]
    data=loadstring("return " .. data)()
  end
  --call("getPage","v",3,"")--调用主线程的"aaa"方法来更新UI
  call("callbk",dump(data),kind)
end




--[[

--运行与回调函数，拆分模块，更好组合，线程同步方案请求数据回调

--调用构造器
key,pagelist=Tieba:pageGet("v",3)
--传入数据参数，与标识
data=thread(Tieba.datasocket,pagelist,1,key)
data=thread(Tieba.datasocket,pagelist,1,key)
--回调处理数据
function callbk(dat,kind)
  ls=(Toolkit.StrToTable(dat))
  --ls=luajava.astable(tables)
  if ls then
    table.sort(ls,function(a,b)
      return (a["index"]<b["index"])
    end)
   else
  end
  print(ls[1]["code"])
  --解析器
end


--]]
