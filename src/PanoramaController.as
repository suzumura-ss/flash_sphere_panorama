package  
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class PanoramaController extends SimpleObjectController 
	{
		protected var _camera:Camera3D;
		protected var _lookAtWithRotation:LookAt3D = new LookAt3D();
		protected var _angle:Number;
		protected var _angleMax:Number;
		protected var _angleMin:Number;

		public function PanoramaController(eventSource:InteractiveObject, camera:Camera3D, speed:Number, speedMultiplier:Number=3, mouseSensitivity:Number=1, options:Dictionary = null) 
		{
			super(eventSource, camera, speed, speedMultiplier, mouseSensitivity);
			var center:Number = -Math.PI / 2.0;
			this.maxPitch = center + Math.PI / 2.0;
			this.minPitch = center - Math.PI / 2.0;
			this.lookAt(_lookAtWithRotation);
			unbindAll();
			
			_camera = camera;
			_angle = options["angle"] || 60;
			_angleMax = options["angleMax"] || 120;
			_angleMin = options["angleMin"] || 30;
			if (options["wheelControl"]) {
				eventSource.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			_camera.fov = Utils.to_rad(_angle);
		}
		
		public function onMouseWheel(e:MouseEvent):void
		{
			_angle += (e.delta > 0) ? 1: -1;
			_angle = Math.max(Math.min(_angle, _angleMax), _angleMin);
			_camera.fov = Utils.to_rad(_angle);
		}
		
		public function rotate(yaw:Number, pitch:Number):void
		{
			_lookAtWithRotation.yaw = yaw;
			_lookAtWithRotation.pitch = pitch;
			lookAt(_lookAtWithRotation);
		}
		
		override public function lookAt(point:Vector3D):void 
		{
			_lookAtWithRotation.lookAt(point);
			super.lookAt(_lookAtWithRotation);
		}
	}
}