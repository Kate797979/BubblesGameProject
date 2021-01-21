package core.commands 
{
	
	/**
	 * ...
	 * @author K
	 */
	public interface ICommand 
	{
		function start(onComplete:Function = null):void;
		
		function stop():void;
		
		function pause():void;
		
		function resume():void;
		
		function get executing():Boolean;
	}
	
}