--about：已经被丢弃的库文件，备用
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
require "import"
import "android.widget.*"
import "android.view.*"



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
--http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kw=v&lp=5011&lm=&pinf=1_2_80&pn=40
--http://tieba.baidu.com/mo/q---9CC3CD881B0FE2BA30F4559A6AF8A941%3AFG%3D1-sz%40320_240%2C-1-3-0--2--wapp_1531379582221_177/m?kz=7727522468&is_bakan=0&lp=5010&pinf=1_2_40
function request_api(endpns)
  import"run.api"
  tieba = Tieba:new()
  for i=0,endpns do
    tieba:connect("v吧",i,function(con,is)
      if is then
        nolist.setVisibility(View.GONE)
        loadbar.setVisibility(View.GONE)
        doc = Jsoup.parse(tostring(con))--使用jsoup解析网页
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
       else
        snack_bar("通信失败"..con)
      end
    end)
  end
end


function request_item(kz,endpns)
  import"run.api"
  tieba = Tieba:new()
  for i=0,endpns-1 do
    if i==0 then
      activity.getGlobalData()["num"]=0
    end
    tieba:getpost(tostring(kz),i,function(con,is)
      if is then
        activity.getGlobalData()[tostring(i)]=true
        nolist.setVisibility(View.GONE)
        loadbar.setVisibility(View.GONE)
        doc = Jsoup.parse(con)--使用jsoup解析网页
        classification = doc.select('div.i')--查找到所有class为text-gray的网页元素
        classification = luajava.astable(classification)--将其转换成table表
        for k,v in pairs(classification) do--循环打印输出
          rs=tostring(v.getElementsByTag("a").text())
          con=v.ownText()
          floor=(v.text():match('(%d+)[楼.]'))
          name=v.getElementsByClass("g").text()
          time=(v.getElementsByClass("b").text())
          if tonumber(floor)<=tonumber(activity.getGlobalData()["num"]) then
            break
          end
          activity.getGlobalData()["num"]=floor
          adp.add{__type=5,name=name,content=v.ownText(),date=time,floor=tostring(floor).."楼"}
        end
       else
        snack_bar("通信失败"..con)
      end
    end)
  end
end

function request_page(kind,kz)
  total=nil
  import"run.api"
  tieba = Tieba:new()
  tieba:getpage(kind,kz,function(con,is)
    if is then
      --  print(1)
      --print(con)
      doc = Jsoup.parse(con)--使用jsoup解析网页
      classification = doc.select('input')--查找到所有class为text-gray的网页元素
      classification = luajava.astable(classification)--将其转换成table表
      for k,v in pairs(classification) do--循环打印输出
        if (v.attr("name"))=="pnum" then
          total=(v.attr("size"))
          if total then;else
            total=1
          end
          for i=1,tonumber(total) do
            request_item(kz,i)
          end
        end
        --print(v.getElementsByClass("g").text())
      end
      if total then;else
        total=1
        for i=1,tonumber(total) do
          request_item(kz,i)
        end
      end
    end
  end)

end
