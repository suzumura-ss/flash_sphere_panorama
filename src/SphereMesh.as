package  
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.GeoSphere;
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
			super(1000, 60, true);
		}
		
		public function applyTexture(bitmapData:BitmapData, stage3D:Stage3D):void
		{
			var t:ImageTextureResource = new ImageTextureResource(bitmapData, true);
			var m:TextureMaterial = new TextureMaterial(t);
			if(stage3D && stage3D.context3D) {
				t.upload(stage3D.context3D);
			}
			this.setMaterialToAllSurfaces(m);
		}
	}
}