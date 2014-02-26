package com.skitsanos.drawing
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Graphics
	{

		public function flipHorizontal(dsp:DisplayObject):void
		{
			var matrix:Matrix = dsp.transform.matrix;
			matrix.a = -1;
			matrix.tx = dsp.width + dsp.x;
			dsp.transform.matrix = matrix;
		}

		public function flipVertical(dsp:DisplayObject):void
		{
			var matrix:Matrix = dsp.transform.matrix;
			matrix.d = -1;
			matrix.ty = dsp.height + dsp.y;
			dsp.transform.matrix = matrix;
		}

		public function copyPixels(source:BitmapData, startX:int, startY:int, width:int, height:int, flipV:Boolean = false, flipH:Boolean = false):BitmapData
		{
			var nbd:BitmapData = new BitmapData(width, height, false, 0xFFFFFF);
			source.lock();
			nbd.lock();

			var hy:int = 0;
			var hx:int = 0;

			var sx:int = 0;
			for (var i:int = startX; i < startX + width; i++)
			{
				var sy:int = 0;
				for (var j:int = startY; j < startY + height; j++)
				{
					if (flipV)
					{
						hy = height - sy - 1;
					}
					else
					{
						hy = sy;
					}
					if (flipH)
					{
						hx = width - sx - 1;
					}
					else
					{
						hx = sx;
					}
					nbd.setPixel32(hx, hy, source.getPixel32(i, j));
					sy++;
				}
				sx++;
			}
			source.unlock();
			nbd.unlock();

			return nbd;
		}

		//interesting color manipulation methods
		//http://blog.soulwire.co.uk/flash/actionscript-3/colourutils-bitmapdata-extract-colour-palette/
		public static function indexColours(source:BitmapData, sort:Boolean = true):Array
		{
			var n:Object = {};
			var a:Array = [];
			var p:int;

			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					p = source.getPixel(x, y);
					n[p] ? n[p]++ : n[p] = 1;
				}
			}

			for (var c:String in n)
			{
				a.push({ colour:c, count:n[c] });
			}

			function byCount(a:Object, b:Object):int
			{
				if (a.count > b.count) return 1;
				if (a.count < b.count) return -1;
				return 0;
			}

			return a.sort(byCount, Array.DESCENDING);
		}

		public static function reduceColours(source:BitmapData, colours:int = 16):void
		{
			var Ra:Array = new Array(256);
			var Ga:Array = new Array(256);
			var Ba:Array = new Array(256);

			var n:Number = 256 / ( colours / 3 );

			for (var i:int = 0; i < 256; i++)
			{
				Ba[i] = Math.floor(i / n) * n;
				Ga[i] = Ba[i] << 8;
				Ra[i] = Ga[i] << 8;
			}

			source.paletteMap(source, source.rect, new Point(), Ra, Ga, Ba);
		}

		/**
		 * Creates BitmapData out of given Display Object
		 */
		public static function makeBitmap(object:DisplayObject):BitmapData
		{
			var myBD:BitmapData = new BitmapData(object.width, object.height);
			myBD.draw(object);
			return myBD;
		}

		public function getDisplayObjectCenter(child:DisplayObject, x:Number = 0, y:Number = 0):Point
		{
			var center:Point = new Point();
			center.x = child.x + child.width / 2 + x;
			center.y = child.y + child.height / 2 + y;
			return center;
		}

		public static function isWideScreen(stage:Stage):Boolean
		{
			//Math.round(stage.fullScreenWidth/stage.fullScreenHeight) returns 1 for 4:3 screens and 2 for 16:9			
			return Math.round(stage.fullScreenWidth / stage.fullScreenHeight) != 1;
		}
	}
}