package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import jp.nium.utils.ObjectUtil;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	public class EquirectangularVideoPlayer extends EquirectangularPlayer
	{
		protected var _video:Video;
		//protected var _frame:Sprite;
		
		public function EquirectangularVideoPlayer(width_:Number, height_:Number, parent:Sprite, options:Dictionary = null)
		{
			super(width_, height_, parent, options);
		}
		
		public override function load(url:String):void
		{
			setup(new BitmapData(1, 1));
			
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			connection.addEventListener(NetStatusEvent.NET_STATUS, function(e:NetStatusEvent):void {
				trace("connection.NetStatusEvent: " + ObjectUtil.toString(e.info));
			});
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				trace("connection.SecurityErrorEvent: " + e.text);
			});
			
			var stream:NetStream = new NetStream(connection);
			stream.client = this;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			_video = new Video();
			_video.attachNetStream(stream);
			_video.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				var v:Video = e.target as Video;
				var bitmap:BitmapData = new BitmapData(v.width, v.height);
				bitmap.draw(v);
				_worldMesh.applyTexture(bitmap, _stage3D);
				/*
				_frame.graphics.clear();
				_frame.graphics.beginBitmapFill(bitmap);
				_frame.graphics.drawRect(0, 0, v.width, v.height);
				_frame.graphics.endFill();
				*/
			});
			
			/*
			_frame = new Sprite();
			_frame.alpha = 0.5;
			_frame.visible = false;
			_parent.addChild(_frame);
			*/
			
			stream.play(url);
		}
		
		public function onMetaData(e:Object):void
		{
			trace("video.onMetaData width: " + e.width +", height:" + e.height + ", duration:" + Math.floor(e.duration) + "sec");
		}
		
		public function onPlayStatus(e:Object):void
		{
			trace("onPlayStatus: " + ObjectUtil.toString(e));
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			switch(e.info.level) {
			case "error":
				trace("netStatusHandler:[error] " + ObjectUtil.toString(e.info));
				break;
			case "status":
				if (e.info.code == "NetStream.Play.Stop") {
					e.target.seek(0);
				} else {
					trace("netStatusHandler:[status] " + ObjectUtil.toString(e.info));
				}
				break;
			default:
				trace("netStatusHandler: " + e + ", " + ObjectUtil.toString(e.info));
				break;
			}
		}
	}
}