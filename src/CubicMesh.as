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
	 * @author Toshiyuki Terashita
	 */
	
	public class CubicMesh extends WorldMesh
	{
		public function CubicMesh(option:Dictionary = null)
		{
			super(option);
			_self = new Box(1000, 1000, 1000, 1, 1, 1, true);
		}
		
		public override function applyTexture(bitmapData:BitmapData, stage3D:Stage3D):void
		{
			var bits:Vector.<BitmapData> = new Vector.<BitmapData>;
			var w:int = bitmapData.width, h:int = bitmapData.height, x:int, y:int;
			var b:BitmapData;
			var mat:Matrix;
			if (w / 6 == h) {
				// 6x1
				w /= 6;
				for (x = 0; x < 6; x++) {
					b = new BitmapData(w, h);
					mat = new Matrix(1, 1, 1, 1, w * x, 0);
					b.draw(bitmapData, mat);
					bits.push(b);
				}
			} else {
				// 3x2
				w /= 3;
				h /= 2;
				for (y = 0; y < 2; y++) {
					for (x = 0; x < 3; x++) {
						b = new BitmapData(w, h);
						mat = new Matrix(1, 0, 0, 1, -w * x, -h * y);
						b.draw(bitmapData, mat);
						bits.push(b);
					}
				}
			}
			var i:int = 0;
			for each(b in bits) {
				var t:ImageTextureResource = new ImageTextureResource(b, true);
				var m:TextureMaterial = new TextureMaterial(t);
				if(stage3D && stage3D.context3D) {
					t.upload(stage3D.context3D);
				}
				_self.addSurface(m, i * 6, 2);
				i++;
			}
		}
	}
}