using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class CityDAL
	{
		public static void Save(City Tmp)
		{
			// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
			string sql;
			if (Tmp.CityId == -1)
			{
				sql = "insert into T_City(CityName)" +
					$"Values(@CityName)";
			}
			else
			{
				sql = $"Update T_City set CityName=@CityName where CityId=@CityId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				CityId = Tmp.CityId,
				CityName = Tmp.CityName,
				
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל המשתמשים
		public static List<City> GetAll()
		{
			List<City> CityList = new List<City>();
			string sql = "Select * from T_City";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					City Tmp = new City()
					{
						CityId = int.Parse(Dt.Rows[i]["CityId"].ToString()),
						CityName = Dt.Rows[i]["CityName"].ToString(),
					};

					
					CityList.Add(Tmp);
				}

			}
			catch (Exception ex)
			{
				// תיעוד של השגיאה לצורך ניפוי
				Console.WriteLine("Exception: " + ex.Message);
			}
			finally
			{
				Db.Close();
			}

			return CityList;
		}
		// אחזור לפי זיהוי
		public static City GetById(int Id)
		{
			City Tmp = null;
			string sql = $"Select * from T_City Where CityId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new City()
				{
					CityId = int.Parse(Dt.Rows[0]["CityId"].ToString()),
					CityName = Dt.Rows[0]["CityName"].ToString(),
					
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_City Where CityId={Id}";
			DbContext Db = new DbContext();
			int Total = Db.ExecuteNonQuery(Sql);
			Db.Close();

			if (Total > 0)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
	}
}
