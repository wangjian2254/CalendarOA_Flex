package airwindow.tools
{
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.NativeProcessExitEvent;
import flash.filesystem.File;
import flash.system.Capabilities;

public class ScreenShot extends EventDispatcher
	{
		public static const SHOT_COMPLETE:String = "shot_complete";
		private var _shotCompleteEvent:Event = null;
		private var _file:File = null;
		private var _nativeProcessStartupInfo:NativeProcessStartupInfo = null;
		private var _process:NativeProcess = null;
		private var _bitmapData:BitmapData = null;
		protected var os:String = Capabilities.os.toLowerCase();
		
		public function ScreenShot()
		{
			if (os.indexOf("mac") > -1)
			{
				_file = File.applicationDirectory.resolvePath("capture.app/Contents/MacOS/applet");
				//			_file = File.applicationDirectory.resolvePath("capture.scpt");
				
			}
			if (os.indexOf("win") > -1)
			{
				_file = File.applicationDirectory.resolvePath("SnapShot.exe");
			}
			_nativeProcessStartupInfo = new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = _file;
			_process = new NativeProcess();
			_shotCompleteEvent = new Event(SHOT_COMPLETE);
			
		}
		
		
		public function shot():void
		{
//			_file.openWithDefaultApplication();
			_process.start(_nativeProcessStartupInfo);
			_process.addEventListener(NativeProcessExitEvent.EXIT,onExit); 
		}
		
		private function onExit(e:NativeProcessExitEvent):void
		{
			if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT))
			{
				_bitmapData = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
				dispatchEvent(_shotCompleteEvent);
			}
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData ? _bitmapData as BitmapData : null;
		}
	}
}