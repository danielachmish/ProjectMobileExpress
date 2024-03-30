using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Readability
	{
		public int ReadiId { get; set; }
		public DateTime DateRead { get; set; }
		public string Desc { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Nots { get; set; }
		public int CusId { get; set; }
		public int ModelId { get; set; }
		public bool Status { get; set; }
		public string NameImage { get; set; }
		public string Urgency { get; set; }
		public int SerProdId { get; set; }

		public void Save()
		{
			ReadabilityDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Readability> GetAll()
		{
			return ReadabilityDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Readability GetById(int Id)
		{
			return ReadabilityDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return ReadabilityDAL.DeleteById(Id);
		}

	}
}