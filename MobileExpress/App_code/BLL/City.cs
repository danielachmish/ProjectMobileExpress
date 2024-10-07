using DAL;
using System.Collections.Generic;

namespace BLL
{
	public class City
	{
		public int CityId { get; set; }
		public string CityName { get; set; }

		// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
		public void Save()
		{
			CityDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<City> GetAll()
		{
			return CityDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static City GetById(int Id)
		{
			return CityDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return CityDAL.DeleteById(Id);
		}
	}
}