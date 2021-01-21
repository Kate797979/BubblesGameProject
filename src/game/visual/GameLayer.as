package game.visual 
{
	import core.commands.ParallelCommand;
	import core.commands.SerialCommand;
	import flash.geom.Point;
	import game.commands.TweenToCommand;
	import game.data.Level;
	import game.visual.bubble.Bubble;
	import game.visual.bubble.Bubbles;
	import game.visual.dangerousBubble.DangerousBubble;
	import game.visual.dangerousBubble.DangerousBubbles;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import utils.MathUtil;
	/**
	 * ...
	 * @author K
	 */
	public class GameLayer extends Sprite
	{
		private var _instance:GameLayer;
		
		private var _gameWidth:Number;
		private var _gameHight:Number;
	
		private var _backLayer:Sprite;
		private var _fishLayer:Sprite;
		private var _netLayer:Sprite;
		private var _dangerousBubblesLayer:Sprite;
		private var _bubblesLayer:Sprite;
		private var _dangerousBubbleMarkLayer:Sprite;
		
		public function GameLayer(gameWidth:Number, gameHight:Number) 
		{
			_instance = this;
			
			_gameWidth = gameWidth;
			_gameHight = gameHight;
			
			_backLayer = new Sprite();
			addChild(_backLayer);
			
			_fishLayer = new Sprite();
			addChild(_fishLayer);
			
			_netLayer = new Sprite();
			addChild(_netLayer);
			
			_dangerousBubblesLayer = new Sprite();
			addChild(_dangerousBubblesLayer);
			
			_bubblesLayer = new Sprite();
			addChild(_bubblesLayer);
			
			_dangerousBubbleMarkLayer = new Sprite();
			addChild(_dangerousBubbleMarkLayer);
			
			createBack();
		}
		
		private var _dangerousBubbleMark:Image;
		private function createDangerousBubbleMark():void
		{
			_dangerousBubbleMark = VisualManager.getImage(_level.dangerousBubbleMarkTextureClassName, _level.dangerousBubbleMarkTextureScale);
			
			_dangerousBubbleMark.alignPivot();
			_dangerousBubbleMark.alpha = 0.25;
			_dangerousBubbleMark.visible = false;
			
			_dangerousBubbleMarkLayer.addChild(_dangerousBubbleMark);
		}
		
		private function showDangerousBubbleMark():void
		{
			_dangerousBubbleMark.useHandCursor = true;
			_dangerousBubbleMark.scaleX = _dangerousBubbleMark.scaleY = 0.1;
			_dangerousBubbleMark.visible = true;
			
			(new TweenToCommand(_dangerousBubbleMark, 0.3, { scaleX:1, scaleY:1 } )).start();
		}
		
		private function hideDangerousBubbleMark():void
		{
			_dangerousBubbleMark.removeFromParent();
		}
		
		private var _netImage:Image;
		private var _fishImage:Image;
		private function createBack():void
		{
			_backLayer.addChild(VisualManager.getImage("backTexture"));
			
			//////
			_fishImage = VisualManager.getImage("fishTexture");
			
			_fishImage.alignPivot();
			_fishImage.scaleX = _fishImage.scaleY = 1 / 3;
			_fishImage.alpha = 0.75;
			_fishImage.visible = false;
			
			_fishLayer.addChild(_fishImage);
			//////
			
			///////
			_netImage = VisualManager.getTiledImage("tileTexture", _gameWidth, _gameHight);
			
			_netLayer.addChild(_netImage);
			_netLayer.alpha = 0;
			////////
		}
		
		private var _playing:Boolean = false;
		private var _level:Level;
		private var _bubbles:Bubbles;
		private var _dangerousBubbles:DangerousBubbles;
		public function startGame(level:Level, onComplete:Function):void
		{
			_playing = true;
			
			_level = level;
			
			_bubbles = new Bubbles(_level, _bubblesLayer);
			_dangerousBubbles = new DangerousBubbles(_level, _dangerousBubblesLayer);
			
			createDangerousBubbleMark();
			
			showNet(function ():void
			{
				startFish();
				
				showBubbles(function ():void
				{
					subscribeEvents();
					
					if (onComplete != null)
						onComplete();
				});
				
			});
		}
		
		private function subscribeEvents():void
		{
			addEventListener(TouchEvent.TOUCH, touchEventHandler);
					
			_bubbles.addEventListener(Event.COMPLETE, onGameComplete);
			_dangerousBubbles.addEventListener(Event.COMPLETE, onGameComplete);
		}
		
		private function unsubscribeEvents():void
		{
			removeEventListener(TouchEvent.TOUCH, touchEventHandler);
					
			_bubbles.removeEventListener(Event.COMPLETE, onGameComplete);
			_dangerousBubbles.removeEventListener(Event.COMPLETE, onGameComplete);
		}
		
		private function onGameComplete(e:Event):void 
		{
			stop();
			
			clearAll(function ():void
			{
				dispatchEvent(new Event(Event.COMPLETE));
			});
		}
		
		private function touchEventHandler(e:TouchEvent):void 
		{
			var targetDO:DisplayObject = e.target as DisplayObject;
			var localMousePos:Point;
			
			var hoverTouch:Touch = e.getTouch(targetDO, TouchPhase.HOVER);
			if (hoverTouch)
			{
				localMousePos = hoverTouch.getLocation(_instance);
					
				if (_dangerousBubbleMark.visible == false)
				{
					showDangerousBubbleMark();
				}
				_dangerousBubbleMark.x = localMousePos.x;
				_dangerousBubbleMark.y = localMousePos.y;
			}
			
			var touch:Touch = e.getTouch(targetDO);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				if (targetDO.hitTest(touch.getLocation(targetDO)))
				{
					hideDangerousBubbleMark();
					removeEventListener(TouchEvent.TOUCH, touchEventHandler);
					
					_dangerousBubblesLayer.alpha = 1;
					_dangerousBubbles.addBubble(_dangerousBubbleMark.x, _dangerousBubbleMark.y);
				}
			}
		}
		
		private function showBubbles(onComplete:Function = null):void
		{
			_bubblesLayer.alpha = 1;
			
			_bubbles.createBubbles();
			
			_bubbles.showBubbles();
			
			if (onComplete != null)
				onComplete();
		}
		
		private function showNet(onComplete:Function = null):void
		{
			(new TweenToCommand(_netLayer, 0.5, { alpha:0.25 }, 0, onComplete)).start();
		}
		
		private var _fishTween:TweenToCommand;
		private function startFish():void
		{
			_fishLayer.alpha = 1;
			
			_fishImage.visible = true;
			
			_fishImage.scaleX = Math.abs(_fishImage.scaleX);
			_fishImage.scaleY = Math.abs(_fishImage.scaleY);
			
			_fishImage.y = _gameHight / 4;
			_fishImage.x = _gameWidth + _fishImage.width;
			
			_fishTween = new TweenToCommand(_fishImage, 15, { x: -_fishImage.width }, 0, null, null, 0,
			function ():void
			{
				_fishImage.scaleX *= -1;
				_fishImage.y = _gameHight - _fishImage.y;
			}, true);
			_fishTween.start();
		}
		
		public function update(deltaTime:Number):void
		{
			if (_playing)
			{
				//Делаем копии, т.к. в процессе проверки могут меняться списки
				var bubbles:Vector.<Bubble> = _bubbles.bubbles.slice();
				var dangerousBubbles:Vector.<DangerousBubble> = _dangerousBubbles.bubbles.slice();
				///
				
				////Проверяем столкновение точек с кругом
				var needToBlow:Boolean;
				var dist:Number;
				for each (var bubble:Bubble in bubbles)
				{
					if (bubble.blowing) 
						continue;
					for each (var dangerousBubble:DangerousBubble in dangerousBubbles)
					{
						dist = MathUtil.getDistance(bubble.x, bubble.y, dangerousBubble.x, dangerousBubble.y);
						needToBlow = dist - bubble.radius - dangerousBubble.radius <= 0;
						
						if (needToBlow)
						{
							blowBubble(bubble);
							break;
						}
					}
				}
				/////////////////////////////////////////
			}
		}
		
		private function blowBubble(bubble:Bubble):void
		{
			if (bubble.blowing)
				return;
			
			var bubblePosX:Number = bubble.x;
			var bubblePosY:Number = bubble.y;
				
			bubble.blow(function ():void
			{
				_dangerousBubbles.addBubble(bubblePosX, bubblePosY);
			});
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function stop():void
		{
			_playing = false;
			
			_fishTween.stop();
			_bubbles.stop();
		}		
		
		private function clearAll(onComplete:Function):void
		{
			unsubscribeEvents();
			
			var duration:Number = 0.3;
			
			var layers:Vector.<Sprite> = new Vector.<Sprite>();
			layers.push(_fishLayer, _netLayer, _bubblesLayer, _dangerousBubblesLayer);
			
			var parallelCommand:ParallelCommand = new ParallelCommand();
			for each (var layer:Sprite in layers)
				parallelCommand.commands.push(new TweenToCommand(layer, duration, { alpha:0 } ));
				
			parallelCommand.start(function ():void
			{
				_bubbles.release();
				_dangerousBubbles.release();
				
				if (onComplete != null)
					onComplete();
			});
			
			
		}
		
	}

}