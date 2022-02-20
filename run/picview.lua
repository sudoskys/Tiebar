--about
--author = 'sudoskys'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.widget.ImageView"
import "android.widget.LinearLayout"
import "com.squareup.picasso.Picasso"
import "com.github.chrisbanes.photoview.*"

import "run.base"
import "res.value"
activity.setTitle('Tiebar+')
--activity.setTheme(android.R.style.Theme_Holo_Light)
--activity.ActionBar.hide()--隐藏标题栏
--After checking, start loading layout.
Laykit.flag(to0x("#000000"))

url=...

me={
  RelativeLayout;
  layout_width="fill";
  layout_height="fill";
  background="#dddddd";
  {
    PhotoView;
    layout_height="100%h";
    layout_width="fill";
    id="csd";
    backgroundColor="#000000";
  };
  {
    CardView;
    layout_height="56dp";
    layout_marginRight="20dp";
    background=maincolor;
    id="bt";
    -- gravity="center";
    layout_alignParentRight="true";
    layout_width="56dp";
    layout_alignParentBottom="true";
    layout_marginBottom="20dp";
    alpha=0.5;
    {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      id="button";
      gravity="center";
      {
        ImageView;
        src="res/drawable/back.png";
        scaleType="centerCrop";
        layout_height="30dp";
        -- layout_margin="5dp";
        layout_width="30dp";
        --layout_marginRight="4%w";
        id="img";
        colorFilter="#FEFEFE";
      };
    };
  };
};


activity.setContentView(loadlayout(me))

activity.setTitle('图片查看')
import "android.view.animation.Animation$AnimationListener"
import "android.view.animation.ScaleAnimation"
import "android.view.animation.ScaleAnimation"
function CircleButton (InsideColor,radiu,...)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  for k,v in ipairs({...}) do
    v.setBackgroundDrawable(drawable)
  end
end
CircleButton(to0x("#000000"),100,bt)
Laykit.ripples(button,to0x(sancolor))

--activity.newActivity("photoView",{lj})

import "android.os.Build" 
function addBitmapToAlbum(bitmap, displayName)--api29以下用另一个方法
  values = ContentValues()
  values.put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
  values.put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
  --if Build.VERSION.SDK_INT >= 29 then
  values.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
  --else
  --values.put(MediaStore.MediaColumns.DATA, "${Environment.getExternalStorageDirectory().path}/${Environment.DIRECTORY_PICTURES}/$displayName")
  --end
  uri = activity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
  --uri="content://com.android.externalstorage.documents/tree/primary%3AAcFun"
  if uri ~= nil then
    outputStream = activity.getContentResolver().openOutputStream(uri)
    if outputStream ~= nil then
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
      outputStream.close()
    end
  end
end
function savePicToAlbum(bitmap,picName)
  if Build.VERSION.SDK_INT <=28 then
    内部存储路径=Environment.getExternalStorageDirectory().toString().."/"
    oldSavePicture(内部存储路径.."Pictures/"..picName,bitmap)
   else
    addBitmapToAlbum(bitmap, picName)
  end
  print("已保存到\nPictures/"..picName)
end
button.onClick=function(v)
  local favbitmap=csd.getDrawable().getBitmap()
  local favPicName="tiebar"..os.date("%Y-%m-%d-%H-%M-%S")..".png"
  function saveFavPic()savePicToAlbum(favbitmap,favPicName)end
  if pcall(saveFavPic) then
   else
   
    if Build.VERSION.SDK_INT <=28 then 
      
       else 提示("保存失败")end
  end
end

csd.onClick=function(v)
  activity.finish()
end
--因为之前那个版本不能向下兼容，改成了button版了，本质是一样的
--[[
{
  FrameLayout;
  layout_width='fill';
  layout_height='fill';
  backgroundColor="#000000";
  {
    PhotoView;
    layout_height="100%h";
    layout_width="fill";
    id="csd";
    backgroundColor="#000000";
  };
  {
    LinearLayout;
    gravity="end";
    layout_width="fill";
    layout_height="5%h";
    backgroundColor=0x00ffffff;
    {
      ImageView;
      src="res/drawable/back.png";
      scaleType="centerCrop";
      layout_height="30dp";
      layout_margin="5dp";
      layout_width="30dp";
      layout_marginRight="4%w";
      id="img";
      colorFilter="#FEFEFE";
    };
  };
};
--]]
--activity.setContentView(loadlayout(me))
--可以异步加载网络图片
Picasso.with(this)
.load(url)
.into(csd);
