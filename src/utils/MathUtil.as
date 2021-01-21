package utils 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author K
	 */
	public class MathUtil 
	{
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;	
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
	}

}