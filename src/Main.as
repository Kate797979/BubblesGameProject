package 
{
	import com.junkbyte.console.Cc;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import game.GameManager;
	import game.visual.GameStage;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author K
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var _starling:Starling;
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			////////Панелька для логирования в игровом окне
			Cc.start(stage, "q");
			Cc.visible = false;
			///////////////////
			
			////////////////
			Starling.handleLostContext = true;
			
			_starling = new Starling(GameStage, stage);
			_starling.antiAliasing = 1;
			_starling.start();
			
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			//////////////////////
		}
		
		private function onContextCreated(e:Event):void 
		{
			_starling.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			GameManager.init(function ():void
			{
				GameStage.getInstance().init();
			});
		}
		
	}
	
}