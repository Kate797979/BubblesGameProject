package core.commands
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author K
	 */
	public class Command implements ICommand
	{
		private var _onComplete:Function;
		
		protected var _executing:Boolean = false;
		
		public function Command(delay:Number = 0)
		{
			_timer = new Timer(int(1000 * delay), 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		private var _timer:Timer;
		private var _timerComplete:Boolean = false;
		private function onTimerComplete(e:TimerEvent):void 
		{
			_timerComplete = true;
			execute();
		}
		
		public function start(onComplete:Function = null):void
		{
			_onComplete = onComplete;
			_executing = true;
			
			if (_timer.delay == 0)
				execute();
			else
				_timer.start();
		}
		
		protected var _paused:Boolean = false;
		public function pause():void
		{
			if (_executing)
			{
				_paused = true;
				
				if (_timer.running) 
					_timer.stop();
			}
		}
		
		public function resume():void
		{
			if (_executing && _paused)
			{
				if (_timer.delay > 0 && !_timerComplete)
					_timer.start();
					
				_paused = false;
			}
		}
		
		public function stop():void 
		{
			_executing = false;
			_paused = false;
			_timer.stop();
		}
		
		protected function execute():void
		{
			
		}
		
		protected final function complete():void
		{
			_executing = false;
			
			if (_onComplete != null)
				_onComplete(this);
			_onComplete = null;
		}
		
		public function get executing():Boolean 
		{
			return _executing;
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		
	}

}