package  
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class WorldMesh
	{
		protected var _self:Mesh;
		protected var _option:Dictionary;
		
		public function WorldMesh(option:Dictionary = null) 
		{
			_option = option || new Dictionary();
		}
		
		public function applyTexture(bitmapData:BitmapData, stage3D:Stage3D, index:int = 0):void
		{
			var t:ImageTextureResource = new ImageTextureResource(bitmapData, true);
			var m:TextureMaterial = new TextureMaterial(t);
			if (stage3D && stage3D.context3D) {
				t.upload(stage3D.context3D);
			}
			_self.setMaterialToAllSurfaces(m);
		}
		
		public function mesh():Mesh
		{
			return _self;
		}
	}
}