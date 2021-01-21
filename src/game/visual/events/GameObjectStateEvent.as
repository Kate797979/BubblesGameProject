package game.visual.events 
{
	import core.BaseGameObject;
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	/// @eventType	game.visual.events.GameObjectStateEvent
	[Event(name = "changed", type = "game.visual.events.GameObjectStateEvent")]  
	public class GameObjectStateEvent extends Event
	{
		public static const CHANGED:String = "changed";
		
		private var _gameObject:BaseGameObject;
		private var _state:String;
		
		public function GameObjectStateEvent(type:String, gameObject:BaseGameObject, state:String) 
		{
			super(type);
			
			_gameObject = gameObject;
			_state = state;
		}
		
		public function get gameObject():BaseGameObject 
		{
			return _gameObject;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
	}

}