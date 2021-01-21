package core 
{
	import flash.utils.getQualifiedClassName;
	import starling.events.EventDispatcher;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class BaseObject extends EventDispatcher
	{
		
		public function BaseObject() 
		{
			
		}
		
		protected var _loadedData:Object;
		public function load(data:Object):void 
		{
			_loadedData = data;
			
			for (var key:String in data)
			{
				try
				{
					if (this[key] is Boolean)
						this[key] = data[key] == "True" ? true : false;
					else
						this[key] = data[key];
				}
				catch (e:Error)
				{
					Log.add(formatString("{0}::Error load '{1}': {2}", getQualifiedClassName(this), key, e.message));
				}
			}
		}
		
		public function reset():void
		{
			load(_loadedData);
		}
		
	}

}