using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Rating
	{
		public int RatingId { get; set; }
		public string Date { get; set; }
		public string Grade { get; set; }
		public string Description { get; set; }
		public int TecId { get; set; }
		public int CusId { get; set; }
		public string Comment { get; set; }

		public void Save()
		{
			RatingDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Rating> GetAll()
		{
			return RatingDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Rating GetById(int Id)
		{
			return RatingDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return RatingDAL.DeleteById(Id);
		}
	}
}