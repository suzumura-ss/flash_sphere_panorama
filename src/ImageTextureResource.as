package  
{
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class ImageTextureResource extends BitmapTextureResource
	{
		
		public function ImageTextureResource(bitmapData:BitmapData, flip:Boolean = false)
		{
			bitmapData = resizeImage(bitmapData);
			if (flip) bitmapData = flipImage(bitmapData);
			super(bitmapData);
		}
		
		private function getResizedPix(pix:Number):Number
		{
			for (var i:Number = 1; i <= 2048; i <<= 1) {
				if (pix <= i) return i;
			}
			return 2048;
		}
		
		private function getResizedRect(size:Point):Point
		{
			size.x = getResizedPix(size.x);
			size.y = getResizedPix(size.y);
			return size;
		}
		
		private function resizeImage(source:BitmapData):BitmapData
		{
			var size:Point = getResizedRect(new Point(source.width, source.height));
			if ((size.x == source.width) && (size.y == source.height)) {
				return source;
			}
			var bitmap:BitmapData = new BitmapData(size.x, size.y);
			var mat:Matrix = new Matrix();
			mat.scale(size.x / source.width, size.y / source.height);
			bitmap.draw(source, mat);
			return bitmap;
		}
		
		private function flipImage(source:BitmapData):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(source.width, source.height);
			var mat:Matrix = new Matrix( -1, 0, 0, 1, source.width, 0);
			bitmap.draw(source, mat);
			return bitmap;
		}
	}
}