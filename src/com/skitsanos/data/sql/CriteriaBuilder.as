package com.skitsanos.data.sql
{
	import com.skitsanos.utils.DateTime;
	import com.skitsanos.utils.Strings;

	public class CriteriaBuilder
	{
		private var hash:Array = [];

		public function CriteriaBuilder()
		{

		}

		private function eachValue(func:Function):void
		{
			for each(var i:* in hash)
			{
				func(i.label, i.item);
			}
		}

		/**
		 * Removes the criteria item for this label from the builder if present.
		 */
		public function remove(label:String):*
		{
			//return hash.remove(label);
			return false;
		}

		public function beginGroup(logic:String = "AND"):void
		{
			hash.push({
				label: "separator-start-" + Strings.getGuid(),
				item: {
					action: 0,
					logic: logic
				}
			});
		}

		public function endGroup():void
		{
			hash.push({
				label: "separator-end-" + Strings.getGuid(),
				item: {
					action: 1, logic: null
				}
			});
		}

		public function add(label:String, field:String, operation:String, value:*, logic:String = "OR"):void
		{
			if (operation == CriteriaOperation.BETWEEN)
			{
				var itemWithBetweenCondition:CriteriaItem = new CriteriaItem(field + " " + WrapValueByOperation(operation, value), logic);
				hash.push({label: label, item: itemWithBetweenCondition});
			}
			else if (operation == CriteriaOperation.IN)
			{
				var itemWithInCondition:CriteriaItem = new CriteriaItem(field + " " + WrapValueByOperation(operation, value), logic);
				hash.push({label: label, item: itemWithInCondition});
			}
			else
			{
				if (value is String)
				{
					var index:int = 0;
					for each (var foundValue:String in String(value).split(' '))
					{
						var item:CriteriaItem = new CriteriaItem(field + " " + WrapValueByOperation(operation, foundValue), logic);
						hash.push({label: label + index.toString(), item: item});
						index++;
					}
				}
				else
				{
					var itemSingleString:CriteriaItem = new CriteriaItem(field + " " + WrapValueByOperation(operation, value), logic);
					hash.push({label: label, item: itemSingleString});
				}
			}
		}

		private function WrapValueByOperation(operation:String, value:*):String
		{
			var ret:String = "";
			switch (operation)
			{
				case CriteriaOperation.LIKE:
					/*if(!(value is Number) && !(value is int) && !(value is Date)) //check also if not date
					 {
					 value = value.replace("'","''");
					 }*/
					ret = " LIKE '%" + value + "%'";
					break;

				case CriteriaOperation.IN:
					if (value is Array)
					{
						var wrapString:String = " IN (";
						
						for (var i:int =0 ; i < value.length; i++)
						{
							if (i != value.length - 1)
							{
								wrapString += value[i].toString() + "," ;
							}
							else
							{
								wrapString += value[i].toString() + ")";
							}
						}
						
						ret = wrapString; 
					}
					break;
				
				case CriteriaOperation.NOT_LIKE:
					if (!(value is Number) && !(value is int) && !(value is Date))
					{
						value = value.replace("'", "''");
					}
					ret = " NOT LIKE '%" + value + "%'";
					break;

				case CriteriaOperation.EQUAL:
					/*if(!(value is Number) && !(value is int) && !(value is Date))
					 {
					 value = "'" + value.replace("'", "''") + "'"
					 }*/

					if (DateTime.isDate(value))
					{
						ret = "= '" + value + "'";
					}
					else
					{
						/*if (value.toLowerCase() == 'true' || value.toLowerCase() == 'false')
						{
							ret = "= '" + value.toString() + "'";
						}
						else
						{*/
							ret = "= " + value.toString();
						//}
					}
					break;

				case CriteriaOperation.NOT:
					ret = " NOT " + value;
					break;

				case CriteriaOperation.IS:
					ret = " IS " + value;
					break;

				case CriteriaOperation.BETWEEN:
					ret = " BETWEEN " + value;
					break;

				case CriteriaOperation.MORE_THAN:
					ret = ">" + value;
					break;

				case CriteriaOperation.LESS_THAN:
					ret = "<" + value;
					break;

				case CriteriaOperation.LESS_OR_EQUAL:
					ret = "<=" + value;
					break;

				case CriteriaOperation.MORE_OR_EQUAL:
					ret = "=>" + value;
					break;

				case CriteriaOperation.NOT_EQUAL:
					ret = "<>" + value;
					break;
			}

			ret = ret.replace("'''", "'");

			return ret;
		}

		/**
		 * Returns SQL ready string representation of the criteria
		 */
		public function toString():String
		{
			var sql:String = "";

			eachValue(function(label:String, item:*):void
			{
				if (!(item is CriteriaItem))
				{
					switch (item.action)
					{
						case 0:
							sql += " " + item.logic + "(";
							break;

						case 1:
							sql += ") ";
							break;
					}
				}
				else
				{
					if (Strings.endsWith(sql, '('))
					{
						sql += " " + item.criteria + " ";
					}
					else
					{
						sql += item.logic + " " + item.criteria + " ";
					}
					//sql += item.logic + " " + item.criteria + " ";
				}
			});

			sql = Strings.trim(sql);

			if (Strings.startsWith(sql, CriteriaLogic.OR) || Strings.startsWith(sql, CriteriaLogic.AND) || Strings.startsWith(sql, CriteriaLogic.NOT))
			{
				sql = sql.substr(sql.indexOf(" ") + 1);
			}

			return sql;
		}
	}
}