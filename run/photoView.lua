--about
--author = 'tumeng'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar
require "import"
import "android.widget.*"
import "android.view.*"

import "run.base"
import "res.value"
import "com.coolapk.market.widget.photoview.PhotoView"
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
import "libs.bitmaptool"

--import "uk.co.senab.photoview.PhotoView"
--酷安的photoview太好用了

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
Laykit.flag(0xff000000)

pic=...

layout = {
  LinearLayout,
  orientation = "vertical",
  layout_width = "fill",
  layout_height = "fill",
  gravity = "center",
  background = "#ff000000",
  {
    FrameLayout,
    layout_width = "fill",
    layout_height = "fill",
    {
      LinearLayout,
      layout_height = "fill",
      layout_width = "fill",
      gravity = "center",
      background = "#ff000000",
      id = "_PhotoView",
      Visibility=0;
      {
        PhotoView,
        layout_width = "fill",
        layout_height = "fill",
        background = "#000000",
        id = "mPhotoView",
      },
    },
    {
      LinearLayout,
      layout_height = "fill",
      layout_width = "fill",
      gravity = "center",
      background = "#ff000000",
      id = "_Progress",
      Visibility=0;
      {
        ProgressBar,
        id = "Progress",
        layout_gravity = "center"
      },
    },
  },
}

activity.setContentView(loadlayout(layout))

--Progress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
--[
mPhotoView.enable()
mPhotoView.enableRotate()
mPhotoView.setAnimaDuring(500)
mPhotoView.setAdjustViewBounds(true)
--]]
function Sharing(path)
  import "android.webkit.MimeTypeMap"
  import "android.content.Intent"
  import "android.net.Uri"
  import "java.io.File"
  FileName=tostring(File(path).Name)
  ExtensionName=FileName:match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  intent = Intent()
  intent.setAction(Intent.ACTION_SEND)
  intent.setType(Mime)
  file = File(path)
  uri = Uri.fromFile(file)
  intent.putExtra(Intent.EXTRA_STREAM,uri)
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
  activity.startActivity(Intent.createChooser(intent, "分享到:"))
end

Glide.with(this)
.load(pic)
.listener({
  onResourceReady=function()
    _PhotoView.Visibility=0
    _Progress.Visibility=8
    return false
  end,
})
.fitCenter()
.skipMemoryCache(true)
.diskCacheStrategy(DiskCacheStrategy.NONE)
.into(mPhotoView)

mPhotoView.onClick=function()
  activity.finish()
end


import "libs.SnackerBar"
items={}
table.insert(items,"分享")
table.insert(items,"保存")
table.insert(items,"关闭")
mPhotoView.onLongClick=function()
  AlertDialog.Builder(this)
  -- .setTitle("")
  .setItems(items,{onClick=function(l,v)
      if(items[v+1])~="关闭" then
        some=bitmaptool.getViewBitmap(mPhotoView)
        if some then
          local dir=Environment.getExternalStorageDirectory().toString().."/Pictures/tiebar/"
          local name="share_"..os.date("%Y-%m-%d-%H-%M-%S")..".png"
          pathss=bitmaptool.savePicToAlbum(some,dir,name,function(dirs)
            snack_bar("已保存至"..dirs,"OK",function() end)
          end)
          if (items[v+1])=="分享" then
            Sharing(pathss)
          end
        end
      end
  end})
  .show()
end
