package game.visual.bubble 
{
	import core.commands.ParallelCommand;
	import game.data.BubbleModel;
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
	public class Bubbles extends EventDispatcher
	{
		private var _level:Level;
		private var _bubbles:Vector.<Bubble> = new Vector.<Bubble>();
		private var _container:Sprite;
		
		public function Bubbles(level:Level, container:Sprite) 
		{
			_level = level;
			_container = container;
		}
		
		public function createBubbles():void
		{
			var bubble:Bubble;
			for (var i:int = 0; i < _level.countPoints; i++)
			{
				bubble = createBubble();
				bubble.addEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
				
				_bubbles.push(bubble);
				bubble.id = _bubbles.length - 1;
			}
		}
		
		private function onBubbleStateChanged(e:GameObjectStateEvent):void 
		{
			if (e.state == GameObjectStates.DEAD)
			{
				var bubble:Bubble = e.gameObject as Bubble;
				if (bubble)
				{
					_bubbles.splice(_bubbles.indexOf(bubble), 1);
					
					bubble.removeEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
				}
				
				if (_bubbles.length == 0)
					dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function showBubbles():void 
		{
			for each (var bubble:Bubble in _bubbles)
			{
				showBubble(bubble);
			}
		}
		
		private function showBubble(bubble:Bubble):void
		{
			bubble.show(function ():void
			{
				bubble.move();
			});
		}
		
		private function createBubble():Bubble
		{
			var bModel:BubbleModel = new BubbleModel(_level);
			var bubble:Bubble = new Bubble(bModel);
			
			_container.addChild(bubble);
			
			return bubble;
		}
		
		public function stop():void
		{
			for each (var bubble:Bubble in _bubbles)
				bubble.stop();
		}
		
		public function release():void
		{
			for each (var bubble:Bubble in _bubbles)
			{
				bubble.removeEventListener(GameObjectStateEvent.CHANGED, onBubbleStateChanged);
				bubble.release();
			}
			
			_bubbles = new Vector.<Bubble>();
		}
		
		public function get bubbles():Vector.<Bubble> 
		{
			return _bubbles;
		}
	}

}