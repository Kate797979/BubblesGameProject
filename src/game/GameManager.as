package game 
{
	import game.data.Level;
	import game.data.Player;
	import utils.TextLoaderUtil;
	/**
	 * ...
	 * @author K
	 */
	public class GameManager 
	{
		
		private static var _player:Player = new Player();
		
		public function GameManager() 
		{
			
		}

		private static var _initialized:Boolean = false;
		public static function init(onComplete:Function):void
		{
			if (_initialized) return;
			
			TextLoaderUtil.loadJson("input.txt", function (data:Object):void
			{
				_level = new Level(gameWidth, gameHeight);
				_level.load(data);
				
				if (onComplete != null)
					onComplete();
			});
			
		}

		public static var gameWidth:Number = 800;
		public static var gameHeight:Number = 600;
		
		private static var _level:Level;
		static public function get level():Level 
		{
			return _level;
		}
		
		static public function get player():Player 
		{
			return _player;
		}
		
	}

}