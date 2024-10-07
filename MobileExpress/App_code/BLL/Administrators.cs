using DAL;
using System;
using System.Collections.Generic;


namespace BLL
{
	public class Administrators
	{

		public int AdminId { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Addres { get; set; }
		public string Uname { get; set; }
		public string Pass { get; set; }
		public DateTime DateAdd { get; set; }
		public bool Status { get; set; }
		public string Email { get; set; }

		// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
		public void Save()
		{
			AdministratorsDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Administrators> GetAll()
		{
			return AdministratorsDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Administrators GetById(int Id)
		{
			return AdministratorsDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return AdministratorsDAL.DeleteById(Id);
		}






	}


}