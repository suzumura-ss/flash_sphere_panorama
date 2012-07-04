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
			var w:int = bitmapData.width / 3, h:int = bitmapData.height / 2, i:int;
			var b:BitmapData;
			var mat:Matrix;
			
			// 3x2
			const X:Array = [2, 1, 2, 0, 0, 1];
			const Y:Array = [1, 1, 0, 0, 1, 0];
			for (i = 0; i < 6; i++) {
				b = new BitmapData(w, h);
				mat = new Matrix(1, 0, 0, 1, -w * X[i], -h * Y[i]);
				b.draw(bitmapData, mat);
				if (i == 1) {
					var c:BitmapData = new BitmapData(w, h);
					mat = new Matrix();
					mat.translate( -w / 2.0, -h / 2.0);
					mat.rotate(Math.PI);
					mat.translate( w / 2.0, h / 2.0);
					c.draw(b, mat);
					bits.push(c);
				} else {
					bits.push(b);
				}
			}
			i = 0;
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