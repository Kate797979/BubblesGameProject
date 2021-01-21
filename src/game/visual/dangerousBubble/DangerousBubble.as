package game.visual.dangerousBubble 
{
	import core.BaseGameObject;
	import game.commands.TweenToCommand;
	import game.data.Level;
	import game.visual.enums.GameObjectStates;
	import game.visual.events.GameObjectStateEvent;
	import game.visual.VisualManager;
	import starling.display.Image;
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	public class DangerousBubble extends BaseGameObject
	{
		private var _instance:DangerousBubble;
		
		private var _dangerousBubbleImage:Image;
		private var _level:Level;
		
		public function DangerousBubble(x:Number, y:Number, level:Level) 
		{
			_instance = this;
			
			_level = level;
			
			this.x = x;
			this.y = y;
			
			_dangerousBubbleImage = VisualManager.getImage(_level.dangerousBubbleTextureClassName, _level.dangerousBubbleTextureScale);
			_dangerousBubbleImage.alignPivot();
			
			addChild(_dangerousBubbleImage);
			
			alpha = 0;
			scaleX = scaleY = 0.1;
		}
		
		private var _showTweenCommand:TweenToCommand;
		private var _hideTweenCommand:TweenToCommand;
		public function show():void
		{
			_showTweenCommand =	new TweenToCommand(this, _level.bornTime, { alpha:1, scaleX:1, scaleY:1 });
			_hideTweenCommand = new TweenToCommand(this, 0.2, { alpha:0, scaleX:0.1, scaleY:0.1 }, _level.lifeTime);
			
			_showTweenCommand.onComplete = function ():void
			{
				_hideTweenCommand.start(function ():void
				{
					dispatchEvent(new GameObjectStateEvent(GameObjectStateEvent.CHANGED, _instance, GameObjectStates.DEAD));
				});
			};
			
			_showTweenCommand.start();
		}
		
		public function stop():void
		{
			if (_showTweenCommand && _showTweenCommand.executing)
				_showTweenCommand.stop();
				
			if (_hideTweenCommand && _hideTweenCommand.executing)
				_hideTweenCommand.stop();
		}
		
		public function get radius():Number
		{
			return width / 2;
		}
	}

}