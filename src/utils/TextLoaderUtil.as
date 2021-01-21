package utils 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class TextLoaderUtil 
	{
		
		public function TextLoaderUtil() 
		{
			
		}
		
		public static function loadJson(url:String, onLoaded:Function):void
		{
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void
			{
				Log.add(formatString("{0}:: File '{1}' not found", getQualifiedClassName(this), url));
				
				onLoaded(null);
			});
			
			loader.addEventListener(Event.COMPLETE, function completeHandler(event:Event):void
			{
				var loader:URLLoader = URLLoader(event.target);
				
				var str:String = loader.data;
				var obj:Object = JSON.parse(str);
				
				onLoaded(obj);
			});
			
			loader.load(new URLRequest(url));			
		}

		
	}

}