package game.commands 
{
	import core.commands.Command;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author K
	 */
	public class TweenToCommand extends Command
	{
		/**
		 * 
		 * @param	target
		 * @param	duration - время в секундах
		 * @param	values
		 * @param	delay
		 */
		public function TweenToCommand(target:Object, duration:Number, values:Object, delay:Number = 0, onComplete:Function = null, onTweenChange:Function = null, repeatCount:int = 1, onRepeat:Function = null, reverse:Boolean = false)
		{
			super(delay);
			
			_duration = duration;
			
			_target = target;
			_values = values;
			_repeatCount = repeatCount;
			_reverse = reverse;
			
			this.onComplete = onComplete;
			this.onTweenChange = onTweenChange;
			this.onRepeat = onRepeat;
		}
		
		private var _tween:Tween;
		private var _target:Object;
		private var _values:Object;
		private var _duration:Number = 1;
		private var _repeatCount:int = 1;
		private var _reverse:Boolean = false;
		
		private function onTweenComplete():void
		{
			if (onComplete != null) 
				onComplete();
			
			complete();
		}
		
		protected override function execute():void 
		{
			_tween = new Tween(_target, _duration);
			
			_tween.onComplete = onTweenComplete;
			_tween.onUpdate = onTweenChange;
			
			_tween.repeatCount = _repeatCount;
			_tween.onRepeat = onRepeat;
			_tween.reverse = _reverse;
			
			for (var key:String in _values)
				_tween.animate(key, _values[key]);
			
			Starling.juggler.add(_tween);
		}
		
		public function get target():Object 
		{
			return _target;
		}
		
		public function get values():Object 
		{
			return _values;
		}
		
		override public function stop():void 
		{
			super.stop();
			
			if (_tween && !_tween.isComplete)
				Starling.juggler.remove(_tween);
			
			complete();
		}
		
		public var onTweenChange:Function;
		public var onComplete:Function;
		public var onRepeat:Function;
		
	}

}