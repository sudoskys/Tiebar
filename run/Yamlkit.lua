--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
YAML = {}
function YAML:new()
  local funt = {}
  setmetatable(funt, self)
  self.__index = self
  --self.debuging = p["debug"]
  self.HOME = activity.getLuaDir()
  self.author= ("sudoskys")
  self.libyaml=require"yaml"
  self.road=function(path)
    import "java.io.File"
    if path then
      path=File(path).getAbsolutePath()
      if File(path).isFile() then
        return path
       else
        path=activity.getLuaDir()..path
        if File(path).isFile() then
          return path
         else
          return false
        end
      end
     else
      print("miss path")
    end
  end
  return funt
end
--定义类的方法



function YAML:loadf(path)
  reads=function(path)
    local content=io.open(path):read("*a")
    return content
  end
  if self.road(path) then
    as=reads(self.road(path))
    dcon=self.libyaml.load(as)
    return dcon
   else
    print("NO file  "..path)
    return false
  end
end

function YAML:dumpf(tables,path)
  save=function(content,path)
    import "java.io.File"
    local f=File(tostring(File(tostring(path)).getParentFile())).mkdirs()
    io.open(tostring(path),"w"):write(tostring(content)):close()
  end
  if type(tables) == type({}) or type(tables) == type(["x"]) then
    dcon=self.libyaml.dump(tables)
    return save(dcon,self.road(path))
   else
    print("STOP, Not table")
    return false
  end
end

function YAML:load(str)
  if type(str) == type("x") then
    dcon=self.libyaml.load(str)
    return dcon
   else
    print("Not string....CANT load")
    return false
  end
end


function YAML:dump(tables)
  if type(tables) == type({}) or type(tables) == type(["x"]) then
    dcon=self.libyaml.dump(tables)
    return dcon
   else
    print("Not table....CANT dump")
    return false
  end
end



--[[
path="/values/color/setting.yaml"
con=yaml:loadf(path)
--print(dump(con))
--]]



