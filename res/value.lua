maincolor="#ff51A8DD"
subcolor="#FF74AAFF"
txtcolor="#efffffff"
backcolor="#FFA5DEE4"
sancolor="#efffffff"
imagecolor="#efffffff"
--A1EAFB  FFCEF3 CABBE9

--DBE0E0 B7C3C5 BEBCBA 8F9EA5 F68657 383A3F 1F2124
--色卡配置
--[[
draw.bright="#F9F7F7"
draw.strong="#8CD790"
draw.weak="#77AF9C"
draw.dead="#285943"

draw.bright="#EEEEEE"
draw.strong="#00ADB5"
draw.weak="#393E46"
draw.dead="#222831"
]]
--[[

draw={}
draw.back="#FFECECEE"
draw.ink="#8F9EA5"
draw.pureday="#efffffff"
draw.bright="#F9F7F7"
draw.strong="#DBE2EF"
draw.weak="#3F72AF"
draw.dead="#112D4E"
]]
--创建对象
import "run.Yamlkit"
import "java.io.File"
yaml = YAML:new()
path=activity.getLuaDir().."/res/color.yaml"
File(path).createNewFile()
draw=yaml:loadf(path)


--print(dump(con))
--print(dump(yaml))
--me=yaml["dump"](path)
--print((me))
--print(dump(draw))


import "android.os.*"
import "java.io.File"
root_path=Environment.getExternalStorageDirectory().toString().."/Pictures"
downpath=root_path.."/Downfile/"
File(downpath).mkdirs()

