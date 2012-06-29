package  
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.objects.Surface;
	import com.adobe.protocols.dict.Dict;
	import com.sitedaniel.view.components.LoadIndicator;
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	public class EquirectangularPlayer
	{
		protected var _width:Number;
		protected var _height:Number;
		protected var _parent:Sprite;
		protected var _stage3D:Stage3D;
		protected var _rootContainer:Object3D;
		protected var _camera:Camera3D;
		protected var _controller:SimpleObjectController;
		protected var _indicator:LoadIndicator;
		protected var _worldMesh:SphereMesh;
		private var _options:Dictionary;
		
		public function EquirectangularPlayer(width_:Number, height_:Number, parent:Sprite, options:Dictionary = null):void
		{
			_width = width_;
			_height = height_;
			_parent = parent;
			_options = options || new Dictionary();
			_indicator = new LoadIndicator(parent, width_ / 2.0, height_ / 2.0, 50, 30, 30, 4, 0xffffff, 2);
		}
		
		public function load(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadCompleted);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void {
				trace(e);
				_indicator.destroy();
			});
			loader.load(new URLRequest(url));
		}
		
		protected function setup(bitmapData:BitmapData):void
		{
			_rootContainer = new Object3D();
			_camera = new Camera3D(1, 1000);
			_rootContainer.addChild(_camera);
			
			_camera.view = new View(_width, _height, false, 0x202020, 0, 4);
			if(_options["hideLogo"]) _camera.view.hideLogo();
			_parent.addChild(_camera.view);
			if(_options["showDiagram"]) _parent.addChild(_camera.diagram);
			
			_controller = new SimpleObjectController(_parent.stage, _camera, 200, 3, -1);
			var center:Number = -Math.PI / 2.0;
			_controller.maxPitch = center + Math.PI / 2.0;
			_controller.minPitch = center - Math.PI / 2.0;
			_controller.lookAtXYZ(0, 0, 0);
			
			_stage3D = _parent.stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void {
				for each (var resource:Resource in _rootContainer.getResources(true)) {
					resource.upload(_stage3D.context3D);
				}
				_parent.addEventListener(Event.ENTER_FRAME, onEnterFrame)
				_indicator.destroy();
			});
			
			_worldMesh = new SphereMesh();
			_worldMesh.applyTexture(bitmapData, _stage3D);
			_rootContainer.addChild(_worldMesh);
			
			_stage3D.requestContext3D();			
		}
		
		private function onImageLoadCompleted(e:Event):void
		{
			try {
				var image:Bitmap = e.target.content as Bitmap;
			} catch (x:SecurityError) {
				trace(e);
				_indicator.destroy();
				return;
			}
			setup(image.bitmapData);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_camera.view.width = _parent.stage.stageWidth;
			_camera.view.height = _parent.stage.stageHeight;
			_controller.update();
			_camera.render(_stage3D);
		}
	}
}