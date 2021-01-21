package core.commands
{
	
	/**
	 * ...
	 * @author K
	 */
	public class SerialCommand extends CompositeCommand
	{
		public function SerialCommand(delay:Number = 0, ... commands)
		{
			super(delay, commands);
		}
		
		private var _completeCount:int = 0;
		
		override final protected function execute():void
		{
			_completeCount = 0;
			if (_commands.length != 0)
			{
				_commands[0].start(onCommandComplete);
			}
			else
			{
				complete();
			}
		}
		
		private function onCommandComplete(cmd:ICommand):void
		{
			_completeCount++;
			
			if (_completeCount == _commands.length)
			{
				complete();
			}
			else
			{
				_commands[_completeCount].start(onCommandComplete);
			}
		}
	
	}

}