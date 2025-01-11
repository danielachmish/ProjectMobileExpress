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
		public DateTime Date { get; set; }
		public string Grade { get; set; }
		public string Description { get; set; }
		public int TecId { get; set; }
		public int CusId { get; set; }
		public string Comment { get; set; }

		public void SaveNewRating()
		{
			try
			{
				RatingDAL.SaveNewRating(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה לעדכון לקוח קיים
		public void UpdateRating()
		{
			try
			{
				RatingDAL.UpdateRating(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
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