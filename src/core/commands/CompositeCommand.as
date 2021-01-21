package core.commands 
{
	/**
	 * ...
	 * @author K
	 */
	public class CompositeCommand extends Command
	{
		protected var _commands:Array = new Array();
		
		public function CompositeCommand(delay:Number = 0, ... commands) 
		{
			super(delay);
			
			if (commands.length > 0) 
			{
				if (commands[0] is Array)
					_commands = commands[0];
				else
					_commands = commands;
			}
		}
		
		public function get commands():Array 
		{
			return _commands;
		}
		
		public function set commands(value:Array):void 
		{
			_commands = value;
		}
		
		override public function pause():void 
		{
			if (executing && !_paused)
			{
				for each (var command:Command in _commands)
					command.pause();
			}
			super.pause();
		}
		
		override public function resume():void 
		{
			if (executing && _paused)
			{
				for each (var command:Command in _commands)
					command.resume();
			}
			super.resume();
		}
		
		override public function stop():void 
		{
			if (executing)
			{
				for each (var command:Command in _commands)
					command.stop();
			}
			super.stop();
		}
		
		override public function get executing():Boolean 
		{
			for each (var command:Command in _commands)
			{
				if (command.executing) return true;
			}
			
			return false;
		}
		
	}

}