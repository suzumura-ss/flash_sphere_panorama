package  
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	public class SphereMesh extends GeoSphere
	{
		public function SphereMesh()
		{
			super(500, 10, true);
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
		
		public function applyTexture(bitmapData:BitmapData, stage3D:Stage3D):void
		{
			bitmapData = resizeImage(bitmapData);
			var t:BitmapTextureResource = new BitmapTextureResource(bitmapData);
			var m:TextureMaterial = new TextureMaterial(t);
			if(stage3D && stage3D.context3D) {
				t.upload(stage3D.context3D);
			}
			this.setMaterialToAllSurfaces(m);
		}
	}
}