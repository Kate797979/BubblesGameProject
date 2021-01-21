package game.visual 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class VisualManager 
	{
		
		[Embed(source = "../../lib/textures/back.png")]
		public static const backTexture:Class;
		
		[Embed(source = "../../lib/textures/button.png")]
		public static const buttonTexture:Class;
		
		[Embed(source = "../../lib/textures/fish.png")]
		public static const fishTexture:Class;
		
		[Embed(source = "../../lib/textures/tile.png")]
		public static const tileTexture:Class;
		
		[Embed(source = "../../lib/textures/bubble.png")]
		public static const bubbleTexture:Class;
		
		[Embed(source = "../../lib/textures/dangerousBubble.png")]
		public static const dangerousBubbleTexture:Class; 
		
		[Embed(source = "../../lib/textures/dangerousBubbleMark.png")]
		public static const dangerousBubbleMarkTexture:Class;
		
		public function VisualManager() 
		{
			
		}
		
		private static var _textures:Dictionary = new Dictionary();
		public static function getTexture(className:String, scale:Number = 1, repeat:Boolean = false):Texture
		{
			var texture:Texture = _textures[className];
			if (texture) return texture;
			
			var classRef:Class = VisualManager[className];
			if (classRef)
			{
				var bitmap:Bitmap = new classRef();
				texture = Texture.fromBitmap(bitmap, true, false, scale == 0 ? 1 : 1 / scale, "bgra", repeat);
				_textures[className] = texture;
				
				return texture;
			}
			
			return Texture.empty(2, 2);
		}
		
		public static function getImage(className:String, scale:Number = 1):Image
		{
			var texture:Texture = VisualManager.getTexture(className, scale);
			
			return new Image(texture);
		}
		
		public static function getTiledImage(tileClass:String, imgWidth:Number, imgHeight:Number):Image
		{
			var texture:Texture = getTexture(tileClass, 1, true);
			var result:Image = new Image(texture);

			var hRepeatCount:int = Math.ceil(imgWidth / texture.width);
			var vRepeatCount:int = Math.ceil(imgHeight / texture.height);
			
			result.width = imgWidth;
			result.height = imgHeight;
			
			tile(result, hRepeatCount, vRepeatCount);
			
			return result;
		}
		
		private static function tile(image:Image, horizontally:int, vertically:int):void
		{
			image.setTexCoords(1, new Point(horizontally, 0));
			image.setTexCoords(2, new Point(0, vertically));
			image.setTexCoords(3, new Point(horizontally, vertically));
		}

	}

}