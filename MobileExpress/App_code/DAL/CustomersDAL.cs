using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class CustomersDAL
	{
		public static void SaveNewCustomers(Customers Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.CusId == -1)
			{
				sql = "insert into T_Customers(FullName,Phone,Addres,Uname,Pass,DateAdd,Status,,Nots,CityId)" +
					$"Values(@FullName,@Phone,@Addres,@Uname,@Pass,@DateAdd,@Status,,@Nots,@CityId)";
			}
			else
			{
				sql = $"Update T_Customers set FullName=@FullName,Phone=@Phone,Addres=@Addres,Uname=@Uname,Pass=@Pass,DateAdd=@DateAdd,Status=@Status,Nots=@Nots,CityId=@CityId where CusId=@CusId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				CusId = Tmp.CusId,
				FullName = Tmp.FullName,
				Phone = Tmp.Phone,
				Addres = Tmp.Addres,
				Uname = Tmp.Uname,
				Pass = Tmp.Pass,
				DateAdd = Tmp.DateAdd,
				Status = Tmp.Status,
				
				Nots = Tmp.Nots,
				CityId = Tmp.CityId,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}

		public static void UpdateCustomers(Customers Tmp)
		{
			try
			{
				string sql = "UPDATE T_Customers SET  FullName = @FullName, Phone = @Phone, Addres = @Addres, Pass = @Pass, Uname = @Uname, " +
							 "DateAdd = @DateAdd, Status = @Status, Nots = @Nots,  CityId = @CityId," +
							 "WHERE CusId = @CusId";

				// הדפסת השאילתה לשם בדיקה
				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				var Obj = new
				{
					Tmp.CusId,
					
					Tmp.FullName,
					Tmp.Phone,
					Tmp.Addres,
					Tmp.Uname,
					Tmp.Pass,
					Tmp.DateAdd,
					Tmp.Status,				
					Nots = (object)Tmp.Nots ?? DBNull.Value,       // טיפול בערכים null					
					Tmp.CityId,
					
				};

				var LstParma = DbContext.CreateParameters(Obj);

				// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

				if (rowsAffected > 0)
				{
					System.Diagnostics.Debug.WriteLine("Customers updated successfully.");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
				}

				Db.Close();
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in UpdateCustomers method: {ex.Message}");
			}
		} 

		// אחזור כל הלקוחות
		public static List<Customers> GetAll()
		{
			List<Customers> CustomersList = new List<Customers>();
			string sql = "Select * from T_Customers";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Customers Tmp = new Customers()
					{
						CusId = int.Parse(Dt.Rows[i]["CusId"].ToString()),
						FullName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[i]["Phone"].ToString(),
						Addres = Dt.Rows[i]["Addres"].ToString(),
						Uname = Dt.Rows[i]["Uname"].ToString(),
						Pass = Dt.Rows[i]["Pass"].ToString(),
						DateAdd = DateTime.Parse(Dt.Rows[i]["DateAdd"].ToString()),
						History = Dt.Rows[i]["History"].ToString(),
						Nots = Dt.Rows[i]["Nots"].ToString(),
						CityId = int.Parse(Dt.Rows[i]["CityId"].ToString()),
						Status = false  // המרה בשלושה חלקים
					};

					// המרת ערך ה-Status לבוליאני
					bool status;
					if (bool.TryParse(Dt.Rows[i]["Status"].ToString(), out status))
					{
						Tmp.Status = status;
					}
					else
					{
						// טיפול בכשל בהמרה - הגדרת ערך ברירת מחדל או תיעוד הבעיה
						// Tmp.Status = false; // הגדרת ערך ברירת מחדל או טיפול בהתאם לצורך
					}

					CustomersList.Add(Tmp);
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

			return CustomersList;
		}
		// אחזור לפי זיהוי
		public static Customers GetById(int Id)
		{
			Customers Tmp = null;
			string sql = $"Select * from T_Customers Where CusId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Customers()
				{
					CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
					FullName = Dt.Rows[0]["FullName"].ToString(),
					Phone = Dt.Rows[0]["Phone"].ToString(),
					Addres = Dt.Rows[0]["Addres"].ToString(),
					Uname = Dt.Rows[0]["Uname"].ToString(),
					Pass = Dt.Rows[0]["Pass"].ToString(),
					DateAdd = DateTime.Parse(Dt.Rows[0]["DateAdd"].ToString()),
					History = Dt.Rows[0]["History"].ToString(),
					Nots = Dt.Rows[0]["Nots"].ToString(),
					CityId = int.Parse(Dt.Rows[0]["CityId"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"])
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Customers Where CusId={Id}";
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