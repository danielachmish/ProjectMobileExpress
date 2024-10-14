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
		public void SaveNewAdministrators()
		{
			AdministratorsDAL.Save(this);
		}
		// פונקציה לעדכון מנהל קיים
		public void UpdateAdministrators()
		{
			try
			{
				AdministratorsDAL.UpdateAdministrators(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה כללית לשמירת לקוח חדש או קיים
		public void Save()
		{
			if (this.AdminId == -1)
			{
				SaveNewAdministrators();
			}
			else
			{
				UpdateAdministrators();
			}
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