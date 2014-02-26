package com.skitsanos.data.sql
{
	public class CriteriaItem
	{
		public var criteria:String
		public var logic:String = CriteriaLogic.OR;

		public function CriteriaItem(criteria:String, logic:String)
		{
			this.criteria = criteria;
			this.logic = logic;
		}
	}
}