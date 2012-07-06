package  
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class CubicMesh6 extends WorldMesh 
	{
		public function CubicMesh6(option:Dictionary = null)
		{
			super(option);
			_self = new Box(1000, 1000, 1000, 1, 1, 1, true);
		}
		
		private static const indexMap:Array = [2, 4, 3, 5, 1, 0];
		override public function applyTexture(bitmapData:BitmapData, stage3D:Stage3D, index:int = 0):void
		{
			if (index == 5) {
				var w:Number = bitmapData.width;
				var h:Number = bitmapData.height;
				var c:BitmapData = new BitmapData(w, h);
				var mat:Matrix = new Matrix();
				mat.translate( -w / 2.0, -h / 2.0);
				mat.rotate(Math.PI);
				mat.translate( w / 2.0, h / 2.0);
				c.draw(bitmapData, mat);
				bitmapData = c;
			}			
			index = indexMap[index];
			var t:ImageTextureResource = new ImageTextureResource(bitmapData, true);
			var m:TextureMaterial = new TextureMaterial(t);
			if(stage3D && stage3D.context3D) {
				t.upload(stage3D.context3D);
			}
			_self.addSurface(m, index * 6, 2);
		}
	}
}