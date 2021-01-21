package  
{
	import com.junkbyte.console.Cc;
	/**
	 * ...
	 * @author K
	 */
	public class Log 
	{
		
		public function Log() 
		{
			
		}
		
		public static function add(text:String, channel:String = null, ignoreTrace:Boolean = false):void
		{
			if (!ignoreTrace)
				trace(text);
				
			if (channel)
				Cc.logch(channel, text);
			else
				Cc.add(text);
		}
		
	}

}