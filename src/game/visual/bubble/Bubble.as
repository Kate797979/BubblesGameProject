package game.visual.bubble 
{
	import core.BaseGameObject;
	import flash.geom.Point;
	import game.commands.TweenToCommand;
	import game.data.BubbleModel;
	import game.visual.enums.GameObjectStates;
	import game.visual.events.GameObjectStateEvent;
	import game.visual.VisualManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	/**
	 * ...
	 * @author K
	 */
	public class Bubble extends BaseGameObject
	{
		[Embed(source = "particleEffects/Tail.pex", mimeType = "application/octet-stream")]
		private var _bubbleTailEffect:Class;
		
		[Embed(source = "particleEffects/Blow.pex", mimeType = "application/octet-stream")]
		private var _bubbleBlowEffect:Class;
		
		private var _instance:Bubble;
		
		private var _bubbleImage:Image;
		private var _bubbleModel:BubbleModel;
		
		private var _radius:Number;
		
		public var id:int;
		
		public function Bubble(bubbleModel:BubbleModel) 
		{
			_instance = this;
			
			_bubbleModel = bubbleModel;
			
			_bubbleImage = VisualManager.getImage(_bubbleModel.level.bubbleTextureClassName, _bubbleModel.level.bubbleTextureScale);
			_bubbleImage.alignPivot();
			
			addChild(_bubbleImage);
			
			_radius = width / 2;
			
			_bubbleModel.bubbleSize = new Point(width, height);
			_bubbleModel.init();
			
			x = _bubbleModel.x;
			y = _bubbleModel.y;
			
			alpha = 0;
			scaleX = scaleY = 0.1;
		}
		
		public function show(onComplete:Function):void
		{
			(new TweenToCommand(this, 0.3, { alpha:1, scaleX:1, scaleY:1 }, 0, onComplete)).start();
		}
		
		private var _moveCommand:TweenToCommand;
		private var _tailEffect:PDParticleSystem;
		private var _tailEffectLayer:Sprite;
		public function move():void
		{
			moveNextTween();
			startTailEffect();
		}
		
		private function startTailEffect():void
		{
			_tailEffectLayer = new Sprite();
			addChild(_tailEffectLayer);
			
			_tailEffect = new PDParticleSystem(XML(new _bubbleTailEffect()), VisualManager.getTexture(_bubbleModel.level.bubbleTextureClassName/*"particleTexture"*/));
			
			_tailEffectLayer.addChild(_tailEffect);

			updateTail();
			_tailEffect.speed = _bubbleModel.speed;
			
			_tailEffect.start();
			Starling.juggler.add(_tailEffect);
		}
		
		private function moveNextTween():void
		{
			var duration:Number = _bubbleModel.getDistance() / _bubbleModel.speed;
			_moveCommand = new TweenToCommand(this, duration, { x:_bubbleModel.moveToX, y:_bubbleModel.moveToY }, 0,
				function ():void
				{
					if (!_blowing)
					{
						_bubbleModel.onStageEdgeHit();
						
						updateTail();
						
						moveNextTween();
					}
				});
				
			_moveCommand.start();
		}
		
		private function updateTail():void
		{
			_tailEffectLayer.rotation = Math.PI - _bubbleModel.angle;
			
			_tailEffectLayer.x = _radius * Math.cos(_tailEffectLayer.rotation);
			_tailEffectLayer.y = _radius * Math.sin(_tailEffectLayer.rotation);
		}
		
		private var _blowing:Boolean = false;
		public function blow(onComplete:Function = null):void
		{
			_blowing = true;
			
			stop(false);
			
			dispatchEvent(new GameObjectStateEvent(GameObjectStateEvent.CHANGED, _instance, GameObjectStates.DEAD));
			
			startBlowEffect();
			
			if (onComplete != null)
				onComplete();
		}
		
		private var _blowEffect:PDParticleSystem;
		private var _blowEffectLayer:Sprite;
		private function startBlowEffect():void
		{
			_blowEffectLayer = new Sprite();
			addChild(_blowEffectLayer);
			
			_blowEffect = new PDParticleSystem(XML(new _bubbleBlowEffect()), VisualManager.getTexture(_bubbleModel.level.bubbleTextureClassName/*"particleTexture"*/));
			
			_blowEffectLayer.addChild(_blowEffect);

			_blowEffect.addEventListener(Event.COMPLETE, function (e:*):void
			{
				release();
			});
			
			_blowEffect.start(0.1);
			Starling.juggler.add(_blowEffect);
			
			removeChild(_bubbleImage);
		}
		
		public function stop(clearEffects:Boolean = true):void
		{
			if (_moveCommand && _moveCommand.executing)
				_moveCommand.stop();
			if (_tailEffect != null)
				_tailEffect.stop(clearEffects);
			if (_blowEffect != null)
				_blowEffect.stop(clearEffects);
		}
		
		public function get bubbleModel():BubbleModel 
		{
			return _bubbleModel;
		}
		
		public function get blowing():Boolean 
		{
			return _blowing;
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
	}

}