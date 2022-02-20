--about
--author = 'sudoskys&tumeng'
--project = 'Tiebar'
--url = github@sudoskys-Tiebar

import "android.graphics.Canvas"
import "android.graphics.Bitmap"
import "java.io.FileOutputStream"
import "android.graphics.Rect"
import "android.graphics.Paint"
import "android.content.Intent"
import "android.os.Build"
import "android.os.Environment"
import "android.net.Uri"
import "java.io.File"
import "android.content.ContentValues"
import "android.content.Intent"
import "android.provider.MediaStore"
bitmaptool={}
function bitmaptool.getViewBitmap(view)
  if view then
    view.destroyDrawingCache()
    view.setDrawingCacheEnabled(true)
    view.buildDrawingCache()
    return view.getDrawingCache()
   else
    return false
  end
end

function bitmaptool.oldSavePicture(目录,名字,bm)

  if bm then
    local directory=File(目录)
    if not directory.exists() then
      directory.mkdirs()
    end
    local file=File(目录,名字)
    local fileOutputStream=FileOutputStream(file)
    bm.compress(Bitmap.CompressFormat.JPEG,100,fileOutputStream)
    local intent=Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
    intent.setData(Uri.fromFile(file))
    activity.sendBroadcast(intent)
    return true
   else
    return false
  end
end
--图萌开源
function bitmaptool.addBitmapToAlbum(bitmap, displayName)--api29以下用另一个方法
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

import "android.os.Build"
function bitmaptool.savePicToAlbum(bitmap,paths,name,func)
  local directory=File(paths)
  if not directory.exists() then
    directory.mkdirs()
  end
  if tonumber(Build.VERSION.SDK) <=28 then
    bitmaptool.oldSavePicture(paths,name,bitmap)
   else
    bitmaptool.addBitmapToAlbum(bitmap,name)
  end
  local dirs=paths..name
  func(dirs)
  return dirs
end
