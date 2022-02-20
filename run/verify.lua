require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"


import "android.content.Intent"
import "android.content.res.ColorStateList"
import "android.net.Uri"
import "android.os.Environment"
import "android.widget.CardView"
import "android.widget.CheckBox"
import "android.widget.LinearLayout"
import "android.widget.TextView"
import "com.androlua.LuaWebView"
import "java.io.File"

--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
md=require "md"

import "run.base"
import "res.value"
mains={
  LinearLayout;
  orientation="vertical";
  layout_width="fill";
  layout_height="fill";
  background="#F2FDFF";
  {
    LinearLayout;
    layout_width="fill";
    layout_height="60%h";
    {
      LuaWebView;
      id="WebViewd";
      layout_margin="8dp";
      layout_height="fill";
      layout_width="fill";
      background="#F2FDFF";
    };

  };
  {
    LinearLayout;
    layout_width="fill";
    gravity="center";
    layout_height="fill";
    {
      LinearLayout;
      layout_marginBottom="10%w";
      gravity="center";
      orientation="vertical";
      {
        CheckBox;
        layout_marginBottom="20dp";
        text="继续使用即同意";
        id="isok";
      };
      {
        CardView;
        id="post";
        layout_height="10%w";
        layout_margin="18dp";
        CardElevation="1px";
        layout_width="80%w";
        radius="6dp";
        CardBackgroundColor="#2196F3";
        {
          TextView;
          id="like_text";
          layout_height="fill";
          text="确认";
          textColor="#ffffffff";
          layout_width="fill";
          textSize="16";
          gravity="center";
        };
      };
    };
  };
};
activity.setTitle('Tiebar+')
--activity.setTheme(android.R.style.Theme_Holo_Light)
--activity.ActionBar.hide()--隐藏标题栏
--After checking, start loading layout.
activity.setContentView(loadlayout(mains))

data=io.open(activity.getLuaDir().."/license.txt"):read("*a")
--print(data)
WebViewd.loadDataWithBaseURL("",md(data),"text/html","utf-8",nil)
--data:close()
colorStateList=ColorStateList({{android.R.attr.state_checked},{}},{0xff2196f3,0xffcccccc})
colorStateList2=ColorStateList({{android.R.attr.state_checked},{}},{0x662196f3,0x66cccccc})
isok.setButtonTintList(colorStateList)
isok.setBackground(activity.resources.getDrawable(activity.obtainStyledAttributes{android.R.attr.selectableItemBackgroundBorderless}.getResourceId(0,0)).setColor(colorStateList2))
Laykit.flag(to0x(maincolor))
Laykit.ripples(like_text,to0x(txtcolor))
like_text.onClick=function()
  if ok then
    Toolkit.putData("tiebar","isok","yes")
    activity.finish()
   else
    Toolkit.putData("tiebar","isok","no")
    os.exit()
  end
end

--要求复选框显示信息
if isok.isChecked()==true then
  --check.setText("我已认真阅读并同意以上协议")
 else
  --check.setText("我已认真阅读并同意以上协议")
end

isok.setOnCheckedChangeListener
{
  onCheckedChanged=function(g,c)
    if c==true then
      ok=true
     else
      ok=false
    end
  end
}


function checkPermission(jdpuk)return 0==this.getSystemService("appops").checkOp("android:"..jdpuk:lower(),Binder.callingUid,this.packageName)end

if not checkPermission("READ_EXTERNAL_STORAGE")then
  print"请授予文件权限"
  this.startActivity(Intent("android.settings.APPLICATION_DETAILS_SETTINGS",
  Uri.fromParts("package",this.packageName,nil)))
end
import "java.io.File"
import "android.os.Environment"

