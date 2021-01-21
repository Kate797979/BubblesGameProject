package core.commands
{
	
	/**
	 * ...
	 * @author K
	 */
	public class ParallelCommand extends CompositeCommand
	{
		
		public function ParallelCommand(delay:Number = 0, ... commands)
		{
			super(delay, commands);
		}
		
		private var _completeCount:int;
		
		override final protected function execute():void
		{
			_completeCount = 0;
			
			if (_commands.length == 0)
			{
				complete();
				return;
			}
			
			for each (var command:Command in _commands)
			{
				command.start(onCommandComplete);
			}
		}
		
		private function onCommandComplete(cmd:ICommand):void 
		{
			_completeCount++;
			
			if (_completeCount == _commands.length)
			{
				complete();
			}
		}
	
	}

}