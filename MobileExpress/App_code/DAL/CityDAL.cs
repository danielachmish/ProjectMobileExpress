using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace DAL
{
	public class CityDAL
	{
		//public static void Save(City Tmp)
		//{
		//	// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
		//	String Sql;

		//	if (Tmp.CityId == -1 || Tmp.CityId == 0)
		//	{
		//		Sql = "INSERT INTO T_City (CityName) " +
		//			"VALUES ( @CityName)";


		//	}
		//	else
		//	{
		//		Sql = $"Update T_City set CityName=@CityName where CityId=@CityId";
		//	}

		//	DbContext Db = new DbContext();
		//	var Obj = new
		//	{
		//		CityId = Tmp.CityId,
		//		CityName = Tmp.CityName,
				
		//	};

		//	var LstParma = DbContext.CreateParameters(Obj);
		//	// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
		//	Db.ExecuteNonQuery(Sql, LstParma);

		//	Db.Close();
		//}


	public static void Save(City Tmp)
	{
		try
		{
			// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
			String Sql;
			if (Tmp.CityId == -1 || Tmp.CityId == 0)
			{
				Sql = "INSERT INTO T_City (CityName) VALUES (@CityName)";
				Debug.WriteLine($"Attempting to insert new city: {Tmp.CityName}");
			}
			else
			{
				Sql = $"UPDATE T_City SET CityName=@CityName WHERE CityId=@CityId";
				Debug.WriteLine($"Attempting to update city with ID {Tmp.CityId}: {Tmp.CityName}");
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				CityId = Tmp.CityId,
				CityName = Tmp.CityName
			};
			var LstParma = DbContext.CreateParameters(Obj);

			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			int rowsAffected = Db.ExecuteNonQuery(Sql, LstParma);

			if (rowsAffected > 0)
			{
				Debug.WriteLine($"Successfully saved city to database. Rows affected: {rowsAffected}");
			}
			else
			{
				Debug.WriteLine("No rows were affected. The city may not have been saved.");
			}

			Db.Close();
		}
		catch (Exception ex)
		{
			Debug.WriteLine($"Error saving city to database: {ex.Message}");
			// You might want to re-throw the exception here depending on your error handling strategy
			throw;
		}
	}
	public static void UpdateCity(City Tmp)
		{
			try
			{
				string sql = "UPDATE T_City SET CityName = @CityName WHERE CityId = @CityId";

				// הדפסת השאילתה לשם בדיקה
				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				var Obj = new
				{
					Tmp.CityId,

					Tmp.CityName
					
				};

				var LstParma = DbContext.CreateParameters(Obj);

				// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

				if (rowsAffected > 0)
				{
					System.Diagnostics.Debug.WriteLine("City updated successfully.");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
				}

				Db.Close();
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in UpdateCity method: {ex.Message}");
			}
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
