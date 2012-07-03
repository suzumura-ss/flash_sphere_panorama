package  
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.GeoSphere;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class SphereMesh extends WorldMesh
	{
		public function SphereMesh(option:Dictionary = null)
		{
			super(option);
			_self = new GeoSphere(1000, 60, true);
		}
	}
}