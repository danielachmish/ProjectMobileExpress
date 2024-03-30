using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Models
	{
		public int ModelId { get; set; }
		public string ModelName { get; set; }
		public int ManuId { get; set; }
		public string Image { get; set; }
		public DateTime Date { get; set; }

		public void Save()
		{
			ModelsDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Models> GetAll()
		{
			return ModelsDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Models GetById(int Id)
		{
			return ModelsDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return ModelsDAL.DeleteById(Id);
		}
	}	
}