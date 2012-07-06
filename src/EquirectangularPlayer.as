package  
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import com.sitedaniel.view.components.LoadIndicator;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
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
		protected var _camera:Camera3D;
		protected var _rootContainer:Object3D;
		protected var _controller:PanoramaController;
		protected var _indicator:LoadIndicator;
		protected var _worldMesh:WorldMesh;
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
			
			_camera = new Camera3D(1, 2000);
			_rootContainer.addChild(_camera);
			_camera.view = new View(_width, _height, false, 0x202020, 0, 4);
			if(_options["hideLogo"]) _camera.view.hideLogo();
			_parent.addChild(_camera.view);
			if(_options["showDiagram"]) _parent.addChild(_camera.diagram);
			
			_controller = new PanoramaController(_parent.stage, _camera, 200, 3, -1, _options);
			
			_stage3D = _parent.stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void {
				for each (var resource:Resource in _rootContainer.getResources(true)) {
					resource.upload(_stage3D.context3D);
				}
				_parent.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_indicator.destroy();
			});
			
			if (_options["cubic"]) {
				_worldMesh = new CubicMesh(_options);
			} else {
				_worldMesh = new SphereMesh(_options);
			}
			_worldMesh.applyTexture(bitmapData, _stage3D);
			_rootContainer.addChild(_worldMesh.mesh());
			
			_stage3D.requestContext3D();
			
			_worldMesh.mesh().doubleClickEnabled = true;
			_worldMesh.mesh().addEventListener(MouseEvent3D.DOUBLE_CLICK, function(e:MouseEvent3D):void {
				_controller.lookAt(new Vector3D(e.localX, e.localY, e.localZ));
			});
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
			_width = _camera.view.width = _parent.stage.stageWidth;
			_height = _camera.view.height = _parent.stage.stageHeight;
			_controller.update();
			_camera.render(_stage3D);
		}
		
		public function onMouseWheel(e:MouseEvent):void
		{
			_controller.onMouseWheel(e);
		}
		
		public function rotate(yaw:Number, pitch:Number):void
		{
			_controller.rotate(yaw, pitch);
		}
		
		public function snapshot():BitmapData
		{
			_camera.view.renderToBitmap = true;
			_camera.render(_stage3D);
			var bmp:BitmapData = new BitmapData(_width, _height);
			bmp.draw(_camera.view.canvas);
			_camera.view.renderToBitmap = false;
			return bmp;
		}
	}
}