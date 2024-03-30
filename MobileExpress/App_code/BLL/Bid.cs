using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL;


namespace BLL
{
	public class Bid
	{
		public int BidId { get; set; }
		public string Desc { get; set; }
		public float Price { get; set; }
		public bool Status { get; set; }
		public int TecId { get; set; }
		public int ReadId { get; set; }
		public DateTime Date { get; set; }
		
		public void Save()
		{
			BidDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Bid> GetAll()
		{
			return BidDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Bid GetById(int Id)
		{
			return BidDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return BidDAL.DeleteById(Id);
		}
	}
}