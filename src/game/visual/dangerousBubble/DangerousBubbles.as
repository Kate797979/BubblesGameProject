package game.visual.dangerousBubble 
{
	import game.data.Level;
	import game.visual.enums.GameObjectStates;
	import game.visual.events.GameObjectStateEvent;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author K
	 */
	public class DangerousBubbles extends EventDispatcher
	{
		
		private var _level:Level;
		private var _bubbles:Vector.<DangerousBubble> = new Vector.<DangerousBubble>();
		private var _container:Sprite;
		
		public function DangerousBubbles(level:Level, container:Sprite) 
		{
			_level = level;
			_container = container;
		}
		
		public function addBubble(x:Number, y:Number):void
		{
			var bubble:DangerousBubble = new DangerousBubble(x, y, _level);
			
			bubble.addEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
			
			_bubbles.push(bubble);
			
			_container.addChild(bubble);
			
			bubble.show();
		}
		
		private function onBubbleStateChanged(e:GameObjectStateEvent):void 
		{
			if (e.state == GameObjectStates.DEAD)
			{
				var bubble:DangerousBubble = e.gameObject as DangerousBubble;
				if (bubble)
				{
					_bubbles.splice(_bubbles.indexOf(bubble), 1);
					
					bubble.removeEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
					bubble.release();
				}
				
				if (_bubbles.length == 0)
					dispatchEvent(new Event(Event.COMPLETE));
			}

		}
		
		public function release():void
		{
			for each (var bubble:DangerousBubble in _bubbles)
			{
				bubble.stop();
				bubble.removeEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
				bubble.release();
			}
			
			_bubbles = new Vector.<DangerousBubble>();
		}
		
		public function get bubbles():Vector.<DangerousBubble> 
		{
			return _bubbles;
		}
		
	}

}