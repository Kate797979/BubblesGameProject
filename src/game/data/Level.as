package game.data 
{
	import core.BaseObject;
	/**
	 * ...
	 * @author K
	 */
	public class Level extends BaseObject
	{
		public var countPoints:int = 20;
		public var bornTime:Number = 0.5;
		public var lifeTime:Number = 1.0;
		
		/**
		 * Минимальная скорость точки (пикселей в секунду)
		 */
		public var minBubbleSpeed:Number = 20;
		
		/**
		 * Максимальная скорость точки (пикселей в секунду)
		 */
		public var maxBubbleSpeed:Number = 100;
		
		public var bubbleTextureClassName:String = "bubbleTexture";
		public var bubbleTextureScale:Number = 0.5;
		
		public var dangerousBubbleTextureClassName:String = "dangerousBubbleTexture";
		public var dangerousBubbleTextureScale:Number = 0.75;
		
		public var dangerousBubbleMarkTextureClassName:String = "dangerousBubbleMarkTexture";
		public var dangerousBubbleMarkTextureScale:Number = 0.75;
		
		public var pointScore:int = 100;

		private var _gameWidth:Number;
		private var _gameHeight:Number;
		
		public function Level(gameWidth:Number, gameHeight:Number) 
		{
			_gameWidth = gameWidth;
			_gameHeight = gameHeight;
		}
		
		public function get gameWidth():Number 
		{
			return _gameWidth;
		}
		
		public function get gameHeight():Number 
		{
			return _gameHeight;
		}
		
	}

}