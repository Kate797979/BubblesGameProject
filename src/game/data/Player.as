package game.data 
{
	import core.BaseObject;
	/**
	 * ...
	 * @author K
	 */
	public class Player extends BaseObject
	{
		public function Player() 
		{
			
		}
	
		public var score:int = 0;
				
		public var bestScore:int = 0;
		
		override public function reset():void 
		{
			score = 0;
		}
		
	}

}