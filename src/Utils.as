package  
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Toshiyuki Suzumura  / Twitter:@suzumura_ss
	 */
	public class Utils 
	{
		public function Utils() { }
		
		// radian - degree conversion
		static internal function to_deg(rad:Number):Number
		{
			return 360.0 * rad / (2.0 * Math.PI);
		}
		
		static internal function to_rad(deg:Number):Number
		{
			return 2.0 * Math.PI * deg / 360.0;
		}
		
		// JavaScript callback wrapper
		static internal function jsCallback(jsFunction:String, data:Object):void
		{
			if (ExternalInterface.available) {
				try {
					if (jsFunction) ExternalInterface.call(jsFunction, data);
				} catch (x:SecurityError) {
					trace(x);
				} catch (x:Error) {
					trace(x);
				}
			}
		}
	}
}