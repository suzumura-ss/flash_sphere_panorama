package 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.*;
	import flash.events.*;
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
			var htmlParams:Object = LoaderInfo(root.loaderInfo).parameters;
			var sourceUrl:String = htmlParams["source"] || "forest.jpg";
			//sourceUrl = "cubicForest.jpg";
			//htmlParams["cubic"] = "true";
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (sourceUrl) {
				trace("Loading: " + sourceUrl);
				
				var ext:String = URLUtil.getExtension(sourceUrl).toLowerCase();
				var opt:Dictionary = new Dictionary();
				opt["showDiagram"] = (htmlParams["showDiagram"]=="true") || false;
				opt["hideLogo"] = (htmlParams["hideLogo"] == "true") || false;
				opt["cubic"] = htmlParams["cubic"] || false;
				if (IMAGES.indexOf(ext) >= 0) {
					_player = new EquirectangularPlayer(stage.stageWidth, stage.stageHeight, this, opt);
				} else if (VIDEOS.indexOf(ext) >= 0) {
					_player = new EquirectangularVideoPlayer(stage.stageWidth, stage.stageHeight, this, opt);
				}
			}
			if (_player) {
				_player.load(sourceUrl);
			} else {
				trace("No source is specified or " + sourceUrl + " is not supported.");
			}
		}
	}
}
