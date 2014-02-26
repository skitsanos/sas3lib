/**
 * XML Deserialization Engine
 * @author Skitsanos, http://skitsanos.com/
 */
package com.skitsanos.xml
{
	public class XmlDeserializer
	{

		public static function XmlToObject(xml:*):Object
		{
			var o:Object = new Object();
			o[XML(xml).localName()] = {};
			parseAttributes(o[XML(xml).localName()], xml);
			parseElements(o[XML(xml).localName()], xml);

			return o;
		}

		private static function parseElements(obj:Object, x:*):void
		{
			for each (var el:XML in XML(x).children())
			{
				if (el.hasComplexContent())
				{
					parseComplexContent(obj, el);
				}
				else
				{
					parseSimpleContent(obj, el);
				}
			}
		}

		private static function parseComplexContent(obj:Object, el:XML):void
		{
			//trace("--complex: " + el.localName());

			if (obj[el.localName()] == null)
			{
				obj[el.localName()] = {};
				parseAttributes(obj[el.localName()], el);
				parseElements(obj[el.localName()], el);
			}
			else
			{
				//trace(">exists :" + el.localName());
				if (obj[el.localName()][0] == null)
				{
					var zeroObj:Object = obj[el.localName()];

					obj[el.localName()] = new Array();
					obj[el.localName()].push(zeroObj);
				}
				var tempobj:Object = new Object();
				parseAttributes(tempobj, el);
				obj[el.localName()][obj[el.localName()].length] = tempobj;
			}
		}

		private static function parseSimpleContent(obj:Object, el:XML):void
		{
			if (obj[el.localName()] == null)
			{
				//trace("--simple: " + el.localName());

				if (el.toString() != "" && el.children()[0] != null)
				{
					if (el.attributes().length() > 0)
					{
						obj[el.localName()] = {};
						parseAttributes(obj[el.localName()], el);
						obj[el.localName()]["text"] = el.children()[0].toString()
					}
					else
					{
						obj[el.localName()] = el.children()[0].toString();
					}
				}
				else
				{
					obj[el.localName()] = {};

					if (el.attributes().length() > 0)
					{
						parseAttributes(obj[el.localName()], el);
					}
				}
			}
			else
			{
				//trace("--simple (exists): " + el.localName());

				if (el.toString() != "")
				{
					if (el.attributes().length() > 0)
					{
						if (obj[el.localName()][0] == null)
						{
							var zeroObj:Object = obj[el.localName()];

							obj[el.localName()] = new Array();
							obj[el.localName()].push(zeroObj);
						}
						var tempobj:Object = new Object();
						parseAttributes(tempobj, el);
						tempobj["text"] = el.children()[0].toString()
						obj[el.localName()][obj[el.localName()].length] = tempobj;
					}
					else
					{
						obj[el.localName()] += el.children()[0].toString();
					}
				}
				else
				{
					if (obj[el.localName()][0] == null)
					{
						var zeroObj2:Object = obj[el.localName()];

						obj[el.localName()] = new Array();
						obj[el.localName()].push(zeroObj2);
					}
					var tempobj2:Object = new Object();
					parseAttributes(tempobj2, el);
					obj[el.localName()][obj[el.localName()].length] = tempobj2;
				}
			}
		}

		private static function parseAttributes(obj:Object, x:XML):void
		{
			//for (var attndx:Number = 0; attndx < XML(x).attributes().length(); attndx ++)
			for each (var att:* in x.attributes())
			{
				//obj[XML(x).attributes()[attndx].name().toString()] = XML(x).attributes()[attndx].toString();
				obj["$" + att.name().toString()] = x.attribute(att.name()).toString();
			}
		}
	}
}