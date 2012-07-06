package  
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class LookAt3D extends Vector3D 
	{
		protected var _yaw:Number = 0.0;	// = rH
		protected var _pitch:Number = 0.0;	// = rV
		
		public function LookAt3D(yaw:Number = 0.0, pitch:Number = 0.0)
		{
			super();
			_yaw = yaw;
			_pitch = pitch;
			update();
		}
		
		public function set yaw(v:Number):void
		{
			_yaw = v;
			update();
		}
		public function get yaw():Number { return _yaw; }
		
		public function set pitch(v:Number):void
		{
			_pitch = v;
			update();
		}
		public function get pitch():Number { return _pitch; }
		
		protected function update():void
		{
			this.x = Math.cos(_yaw) * Math.cos(_pitch);
			this.y = Math.sin(_yaw) * Math.cos(_pitch);
			this.z = Math.sin(_pitch);
		}
		
		public function lookAt(v:Vector3D):void
		{
			_yaw = Math.atan2(v.y, v.x);
			var r:Number = Math.sqrt(v.x * v.x + v.y * v.y);
			_pitch = Math.atan2(v.z, r);
			update();
		}
	}
}