package 
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.hurlant.util.Base64;
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import jp.nium.utils.URLUtil;
	
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	
	[SWF(width = "500", height = "380", frameRate = "30", backgroundColor = "#000000")]
	
	public class Main extends Sprite 
	{
		private var _player:EquirectangularPlayer;
		
		private static const IMAGES:Array = new Array("jpg", "png");
		private static const VIDEOS:Array = new Array("mp4");
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var htmlParams:Object = LoaderInfo(root.loaderInfo).parameters;
			var sourceUrl:String = htmlParams["source"] || "forest.jpg";
			var opt:Dictionary = new Dictionary();
			opt["showDiagram"] = (htmlParams["showDiagram"]=="true") || false;
			opt["hideLogo"] = (htmlParams["hideLogo"] == "true") || false;
			opt["cubic"] = htmlParams["cubic"] || false;
			opt["wheelControl"] = (htmlParams["wheelControl"] == "true") || false;
			opt["angle"] = Number(htmlParams["angle"]) || 60;
			opt["angleMax"] = Number(htmlParams["angleMax"]) || 120;
			opt["angleMin"] = Number(htmlParams["angleMin"]) || 30;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (sourceUrl) {
				trace("Loading: " + sourceUrl);
				
				var ext:String = URLUtil.getExtension(sourceUrl).toLowerCase();
				if (IMAGES.indexOf(ext) >= 0) {
					_player = new EquirectangularPlayer(stage.stageWidth, stage.stageHeight, this, opt);
				} else if (VIDEOS.indexOf(ext) >= 0) {
					_player = new EquirectangularVideoPlayer(stage.stageWidth, stage.stageHeight, this, opt);
				}
			}
			if (_player) {
				_player.load(sourceUrl);
				if (ExternalInterface.available) {
					try {
						ExternalInterface.addCallback("snapshot", function():String {
							try {
								var bmp:BitmapData = _player.snapshot();
								if (bmp) return Base64.encodeByteArray(PNGEncoder.encode(bmp));
							} catch (x:Error) {
								return x.message;
							}
							return null;
						});
						ExternalInterface.addCallback("mousewheel", function(delta:Number):void {
							var e:MouseEvent = new MouseEvent(MouseEvent.MOUSE_WHEEL, false, false, 0, 0, null, false, false, false, false, delta);
							_player.onMouseWheel(e);
						});
					} catch (x:SecurityError) {
						trace(x);
					} catch (x:Error) {
						trace(x);
					}
				}
			} else {
				trace("No source is specified or " + sourceUrl + " is not supported.");
			}
		}
	}
}
