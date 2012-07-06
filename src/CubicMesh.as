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
	
	public class CubicMesh extends CubicMesh6
	{
		public function CubicMesh(option:Dictionary = null)
		{
			super(option);
		}
		
		override public function applyTexture(bitmapData:BitmapData, stage3D:Stage3D, index:int = 0):void
		{
			var bits:Vector.<BitmapData> = new Vector.<BitmapData>;
			var w:int = bitmapData.width / 3, h:int = bitmapData.height / 2;
			
			// 3x2
			for (var y:int = 0; y < 2; y++) {
				for (var x:int = 0; x < 3; x++) {
					var b:BitmapData = new BitmapData(w, h);
					var mat:Matrix = new Matrix(1, 0, 0, 1, -w * x, -h * y);
					b.draw(bitmapData, mat);
					bits.push(b);
				}
			}
			var i:int = 0;
			for each(b in bits) {
				super.applyTexture(b, stage3D, i);
				i++;
			}
		}
	}
}