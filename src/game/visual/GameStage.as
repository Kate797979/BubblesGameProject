package game.visual 
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import game.commands.TweenToCommand;
	import game.GameManager;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author K
	 */
	public class GameStage extends Sprite
	{
		private static var _instance:GameStage;
		
		private var _gameLayer:GameLayer;
		private var _interfaceLayer:Sprite;
		private var _startGameLayer:Sprite;
		
		private var _gamePlaing:Boolean = false;
		private var _restartGame:Boolean = false;

		private var _bubblesCountValueTextField:TextField;
		private var _scoreValueTextField:TextField;
		
		public function GameStage() 
		{
			if (_instance != null)
				throw new Error("multiply instances GameStage");
				
			_instance = this;
		}
		
		public function init():void
		{
			this.clipRect = new Rectangle(0, 0, GameManager.gameWidth, GameManager.gameHeight);
			
			_gameLayer = new GameLayer(GameManager.gameWidth, GameManager.gameHeight);
			addChild(_gameLayer);
			
			_interfaceLayer = new Sprite();
			addChild(_interfaceLayer);
			
			createInfoTextFields();
			
			createStartGameLayer();
			
			showStartGameLayer();
		}
		
		private function createInfoTextFields():void 
		{
			var textX:Number = 30;
			var textY:Number = 10;
			var textHeight:Number = 25;
			
			//////////Количество живых точек
			var bubblesCountTextField:TextField = createTextField("Bubbles:", Color.WHITE, 80, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(bubblesCountTextField);
			
			_bubblesCountValueTextField = createTextField("", Color.BLUE, 50, textHeight, bubblesCountTextField.x + bubblesCountTextField.width, textY, 20);
			_interfaceLayer.addChild(_bubblesCountValueTextField);
			////////////////////////////////////////
			
			//////////Количество очков
			textX = _bubblesCountValueTextField.x + _bubblesCountValueTextField.width + 10;
			
			var scoreTextField:TextField = createTextField("Score:", Color.WHITE, 70, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(scoreTextField);
			
			_scoreValueTextField = createTextField("", Color.BLUE, 50, textHeight, scoreTextField.x + scoreTextField.width, textY, 20);
			_interfaceLayer.addChild(_scoreValueTextField);
			////////////////////////////////////////
			
			_interfaceLayer.visible = false;
		}
		
		private function createTextField(text:String, color:uint, width:Number, height:Number, x:Number, y:Number, fontSize:Number = 18, hAlign:String = HAlign.LEFT):TextField
		{
			var tField:TextField = new TextField(width, height, text, "Times New Roman", fontSize, color, true);
			
			tField.x = x;
			tField.y = y;
			tField.hAlign = hAlign;
			
			return tField;
		}
		
		private var _startGameInfoTextsLayer:Sprite;
		private var _startGameButton:Button;
		private var _gameScoreValueTextField:TextField;
		private var _bestScoreValueTextField:TextField;
		private function createStartGameLayer():void 
		{
			_startGameLayer = new Sprite();
			addChild(_startGameLayer);
			
			/////Формируем бэк
			var fadeQuadr:Quad = new Quad(GameManager.gameWidth, GameManager.gameHeight, 0x00063c);
			fadeQuadr.alpha = 0.65;
			_startGameLayer.addChild(fadeQuadr);
			
			var fishImage:Image = VisualManager.getImage("fishTexture");
			_startGameLayer.addChild(fishImage);
			fishImage.x = (GameManager.gameWidth - fishImage.width) / 2;
			fishImage.y = 130;
			//////////
			
			////*******Формируем информационные поля
			_startGameInfoTextsLayer = new Sprite();
			_startGameLayer.addChild(_startGameInfoTextsLayer);
			
			var textX:Number = 190;
			var textY:Number = 20;
			var textHeight:Number = 30;
			
			//Очки за игру
			var gameScoreValueTextField:TextField = createTextField("Your score:", Color.WHITE, 120, textHeight, textX, textY, 22, HAlign.RIGHT);
			_startGameInfoTextsLayer.addChild(gameScoreValueTextField);
			
			_gameScoreValueTextField = createTextField("", Color.BLUE, 70, textHeight, gameScoreValueTextField.x + gameScoreValueTextField.width, textY, 24);
			_startGameInfoTextsLayer.addChild(_gameScoreValueTextField);
			////////////////////////////////////////
			
			//Лучший результат
			textX = _gameScoreValueTextField.x + _gameScoreValueTextField.width + 50;
			
			var bestScoreTextField:TextField = createTextField("Best score:", Color.WHITE, 120, textHeight, textX, textY, 22, HAlign.RIGHT);
			_startGameInfoTextsLayer.addChild(bestScoreTextField);
			
			_bestScoreValueTextField = createTextField("", Color.BLUE, 70, textHeight, bestScoreTextField.x + bestScoreTextField.width, textY, 24);
			_startGameInfoTextsLayer.addChild(_bestScoreValueTextField);
			////////////////////////////////////////
			////**********
			
			/////////////Формируем кнопку для старта игры
			_startGameButton = new Button(VisualManager.getTexture("buttonTexture"), "Start Game");
			
			_startGameButton.alignPivot();
			
			_startGameButton.x = GameManager.gameWidth / 2;
			_startGameButton.y = GameManager.gameHeight * 8 / 9;
			
			_startGameButton.fontBold = true;
			_startGameButton.fontSize = 16;
			_startGameButton.fontColor = 0xffffff;
			
			_startGameLayer.addChild(_startGameButton);
			
			_startGameButton.addEventListener(Event.TRIGGERED, startGameButtonTrigged);
			////////////////////////////////////
			
			_startGameLayer.visible = false;
		}
		
		private function showStartGameLayer(onComplete:Function = null):void 
		{
			_startGameInfoTextsLayer.visible = _restartGame;
			if (_restartGame)
			{
				_gameScoreValueTextField.text = GameManager.player.score.toString();
				_bestScoreValueTextField.text = GameManager.player.bestScore.toString();
			}
			
			_startGameButton.text = _restartGame ? "Restart" : "Start game";
			
			_startGameLayer.alpha = 0;
			_startGameLayer.visible = true;
			
			(new TweenToCommand(_startGameLayer, 0.75, { alpha:1 }, 0, onComplete)).start();
		}
		
		private function startGameButtonTrigged(e:Event):void 
		{
			hideStartGameLayer(function ():void
			{
				startGame()
			});
		}
		
		private function hideStartGameLayer(onComplete:Function = null):void
		{
			(new TweenToCommand(_startGameLayer, 0.75, { alpha:0 }, 0,
			function ():void
			{
				_startGameLayer.visible = false;
				
				if (onComplete != null)
					onComplete();
			})).start();
		}
		
		private var _bubblesCount:int;
		private var _score:int;
		private function startGame():void
		{
			resetGame();
			
			_gamePlaing = true;
			
			initDeltaTime();
			
			subscribeEvents();
			
			_gameLayer.startGame(GameManager.level, function ():void
			{
				updateTextFilds();
				_interfaceLayer.visible = true;
			});
		}
		
		private function updateTextFilds():void
		{
			_bubblesCountValueTextField.text = _bubblesCount.toString();
			_scoreValueTextField.text = _score.toString();
		}
		
		private function resetGame():void 
		{
			_bubblesCount = GameManager.level.countPoints;
			
			GameManager.player.reset();
			_score = GameManager.player.score;
		}
		
		private function subscribeEvents():void
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
			_gameLayer.addEventListener(Event.COMPLETE, onGameComplete);
			_gameLayer.addEventListener(Event.CHANGE, onBubbleBlow);
		}
		
		private function unsubscribeEvents():void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
			_gameLayer.removeEventListener(Event.COMPLETE, onGameComplete);
			_gameLayer.removeEventListener(Event.CHANGE, onBubbleBlow);
		}
		
		private function onBubbleBlow(e:Event):void 
		{
			_bubblesCount -= 1;
			
			GameManager.player.score += GameManager.level.pointScore;
			_score = GameManager.player.score;
			
			updateTextFilds();
		}
		
		private function onGameComplete(e:Event):void 
		{
			unsubscribeEvents();
			
			_restartGame = true;
			
			_interfaceLayer.visible = false;
			
			GameManager.player.bestScore = Math.max(GameManager.player.bestScore, GameManager.player.score);
			showStartGameLayer();
		}
		
		private function enterFrameEventHandler(e:EnterFrameEvent):void 
		{
			if (_gamePlaing)
			{
				var dTime:Number = getDeltaTime();
				
				_gameLayer.update(dTime);
			}
		}
		
		private function initDeltaTime():void
		{
			_lastTime = getTimer() / 1000;
			_currentTime = _lastTime;
		}
		
		private var _lastTime:Number = 0;
		private var _currentTime:Number = 0;
		private function getDeltaTime():Number
		{
			_lastTime = _currentTime;
			_currentTime = getTimer() / 1000;
			
			return _currentTime - _lastTime; 
		}
		
		public static function getInstance():GameStage
		{
			if (_instance == null)
				throw new Error("GameStage instance does not exists");

			return _instance;
		}
		
	}

}