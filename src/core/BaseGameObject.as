package core 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author K
	 */
	public class BaseGameObject extends Sprite
	{
		
		public function BaseGameObject() 
		{
			
		}
		
		public function release():void
		{
			removeFromParent();
		}
		
	}

}