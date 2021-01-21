package game.data 
{
	import flash.geom.Point;
	import game.visual.enums.StageEdgeLineType;
	import utils.MathUtil;
	/**
	 * ...
	 * @author K
	 */
	public class BubbleModel 
	{
		
		private var _gameWidth:Number;
		private var _gameHeight:Number;
		
		private var _bubbleSize:Point;
		private var _linesOffset:Point;
		
		/**
		 * Координата X точки, из которой начинается движение
		 */
		private var _x:Number;
		/**
		 * Координата Y точки, из которой начинается движение
		 */
		private var _y:Number;
		
		private var _moveToX:Number;
		private var _moveToY:Number;

		private var _moveToLine:String;
		
		/**
		 * Скорость движения точки (пикселей в секунду, в диапазоне [MIN_SPEED, MAX_SPEED] )
		 */
		private var _speed:Number;
		
		private var _angle:Number;
		
		private var _level:Level;
		
		public function BubbleModel(level:Level) 
		{
			_level = level;
			
			_gameWidth = _level.gameWidth;
			_gameHeight = _level.gameHeight;
		}
		
		public function init():void
		{
			var xOffset:Number = 150;
			var yOffset:Number = 100;
			
			_x = xOffset + Math.random() * (_gameWidth - 2 * xOffset);
			_y = yOffset + Math.random() * (_gameHeight - 2 * yOffset);
			
			_angle = Math.random() * 2 * Math.PI;
			
			_speed = _level.minBubbleSpeed + Math.random() * (_level.maxBubbleSpeed - _level.minBubbleSpeed);
			
			calcNextMoveDirection();
		}
		
		public function onStageEdgeHit():void
		{
			_x = _moveToX;
			_y = _moveToY;
			
			_angle = _moveToLine == StageEdgeLineType.TOP_LINE || _moveToLine == StageEdgeLineType.BOTTOM_LINE ?
				2 * Math.PI - _angle : Math.PI - _angle;
			if (_angle < 0) _angle += 2 * Math.PI;
			
			calcNextMoveDirection();
		}
		
		private function calcNextMoveDirection():void
		{
			var point:Point;
			
			if (_angle >= 0 && _angle < Math.PI / 2)
			{
				if (_angle > 0)
					point = getLinesCrossPoint(StageEdgeLineType.TOP_LINE);
				if (_angle > 0 && point.x <= _gameWidth - _linesOffset.x - _x)
				{
					point = new Point(point.x + _x, _linesOffset.y);
					_moveToLine = StageEdgeLineType.TOP_LINE;
				}
				else
				{
					point = getLinesCrossPoint(StageEdgeLineType.RIGHT_LINE);
					point = new Point(_gameWidth - _linesOffset.x, _y - point.y);
					_moveToLine = StageEdgeLineType.RIGHT_LINE;
				}
			}
			else if (_angle >= Math.PI / 2 && _angle < Math.PI)
			{
				point = getLinesCrossPoint(StageEdgeLineType.TOP_LINE);
				if (point.x >= -_x + _linesOffset.x)
				{
					point = new Point( _x - Math.abs(point.x), _linesOffset.y);
					_moveToLine = StageEdgeLineType.TOP_LINE;
				}
				else
				{
					point = getLinesCrossPoint(StageEdgeLineType.LEFT_LINE);
					point = new Point(_linesOffset.x, _y - point.y);
					_moveToLine = StageEdgeLineType.LEFT_LINE;
				}
			}
			else if (_angle >= Math.PI && _angle < Math.PI * 3 / 2)
			{
				if (_angle > Math.PI)
					point = getLinesCrossPoint(StageEdgeLineType.BOTTOM_LINE);
				if (_angle > Math.PI && point.x >= -_x + _linesOffset.x)
				{
					point = new Point( _x - Math.abs(point.x), _gameHeight - _linesOffset.y);
					_moveToLine = StageEdgeLineType.BOTTOM_LINE;
				}
				else
				{
					point = getLinesCrossPoint(StageEdgeLineType.LEFT_LINE);
					point = new Point(_linesOffset.x, _y + Math.abs(point.y));
					_moveToLine = StageEdgeLineType.LEFT_LINE;
				}
			}
			else// if(_angle >= Math.PI * 3 / 2 && _angle < Math.PI * 2)
			{
				point = getLinesCrossPoint(StageEdgeLineType.BOTTOM_LINE);
				if (point.x <= _gameWidth - _linesOffset.x - _x)
				{
					point = new Point(point.x + _x, _gameHeight - _linesOffset.y);
					_moveToLine = StageEdgeLineType.BOTTOM_LINE;
				}
				else
				{
					point = getLinesCrossPoint(StageEdgeLineType.RIGHT_LINE);
					point = new Point(_gameWidth - _linesOffset.x, _y + Math.abs(point.y));
					_moveToLine = StageEdgeLineType.RIGHT_LINE;
				}
			}
			
			_moveToX = point.x;
			_moveToY = point.y;
		}
		
		private function getLinesCrossPoint(line:String):Point
		{
			var crossX:Number;
			var crossY:Number;

			//y = tg(_angle) * (x - x0) + y0
			//y = tg(_angle) * x - уравнение в системе координат с центром (x0, y0)
			
			var tan:Number = Math.tan(_angle);
			switch (line)
			{
				case StageEdgeLineType.TOP_LINE:
					//y = _y - _linesOffset.y
					crossY = _y - _linesOffset.y;
					crossX = crossY / tan;
					break;
				case StageEdgeLineType.BOTTOM_LINE:
					//y = _y - _gameHeight + _linesOffset.y
					crossY = _y - _gameHeight + _linesOffset.y;
					crossX = crossY / tan;
					break;
				case StageEdgeLineType.LEFT_LINE:
					//x = -_x + _linesOffset.x
					crossX = -_x + _linesOffset.x;
					crossY = crossX * tan;
					break;
				case StageEdgeLineType.RIGHT_LINE:
					//x = _gameWidth - _x - _linesOffset.y
					crossX = _gameWidth - _x - _linesOffset.y;
					crossY = crossX * tan;
					break;
			}
			
			return new Point(crossX, crossY);
		}
		
		public function getDistance():Number
		{
			return MathUtil.getDistance(_x, _y, _moveToX, _moveToY);
		}
		
		/**
		 * Скорость движения точки (пикселей в секунду, в диапазоне [MIN_SPEED, MAX_SPEED] )
		 */
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function get moveToX():Number 
		{
			return _moveToX;
		}
		
		public function get moveToY():Number 
		{
			return _moveToY;
		}
		
		/**
		 * Координата X точки, из которой начинается движение
		 */
		public function get x():Number 
		{
			return _x;
		}
		
		/**
		 * Координата Y точки, из которой начинается движение
		 */
		public function get y():Number 
		{
			return _y;
		}
		
		/**
		 * Размеры объекта (x - ширина, y - высота)
		 */
		public function set bubbleSize(value:Point):void 
		{
			_bubbleSize = value;
			_linesOffset = new Point(_bubbleSize.x / 2, _bubbleSize.y / 2);
		}
		
		public function get level():Level 
		{
			return _level;
		}
		
		public function get angle():Number 
		{
			return _angle;
		}
		
	}

}