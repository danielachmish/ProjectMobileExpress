using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class CategoriesDAL
	{
		//עדכון קטגורייה קיימת או יצירת חדשה
		//public static void Save(Categories Tmp)
		//{
		//	// בדיקה אם הקטגוריה קיימת - עדכון, אחרת הוספת קטגוריה חדשה
		//	string sql;
		//	if (Tmp.CatId == -1)
		//	{
		//		sql = "insert into T_Categories(CatName,DateAdd,Status)" +
		//			$"Values(@CatName,@DateAdd,@Status)";
		//	}
		//	else
		//	{
		//		sql = $"Update T_Categories set CatName=@CatName, DateAdd=@DateAdd, Status=@Status where CatId=@CatId";
		//	}

		//	DbContext Db = new DbContext();
		//	var Obj = new
		//	{
		//		CatId = Tmp.CatId,
		//		CatName = Tmp.CatName,
		//		DateAdd = Tmp.DateAdd,
		//		Status = Tmp.Status
		//	};

		//	var LstParma = DbContext.CreateParameters(Obj);
		//	// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
		//	Db.ExecuteNonQuery(sql, LstParma);

		//	Db.Close();
		//}
		//public static void UpdateCategories(Categories Tmp)
		//{
		//	try
		//	{
		//		string sql = "UPDATE T_Categories SET CatName = @CatName,	DateAdd = @DateAdd,	Status = @Status WHERE CatId = @CatId";

		//		// הדפסת השאילתה לשם בדיקה
		//		System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

		//		DbContext Db = new DbContext();
		//		var Obj = new
		//		{
		//			Tmp.CatId,

		//			Tmp.CatName,
		//			Tmp.DateAdd,
		//			Tmp.Status,

		//		};

		//		var LstParma = DbContext.CreateParameters(Obj);

		//		// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
		//		int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
		//		System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

		//		if (rowsAffected > 0)
		//		{
		//			System.Diagnostics.Debug.WriteLine("Categories updated successfully.");
		//		}
		//		else
		//		{
		//			System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
		//		}

		//		Db.Close();
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in UpdateCategories method: {ex.Message}");
		//	}
		//}
		public static void Save(Categories Tmp)
		{
			System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת קטגוריה -------------");
			System.Diagnostics.Debug.WriteLine($"נתוני קטגוריה לשמירה: CatId={Tmp.CatId}, CatName={Tmp.CatName}, DateAdd={Tmp.DateAdd}, Status={Tmp.Status}");

			string sql;
			if (Tmp.CatId == -1 || Tmp.CatId == 0) 
			{
				sql = "INSERT INTO T_Categories(CatName,DateAdd,Status) VALUES(@CatName,@DateAdd,@Status)";
				System.Diagnostics.Debug.WriteLine("מבצע הוספת קטגוריה חדשה");
			}
			else
			{
				sql = "UPDATE T_Categories SET CatName=@CatName, DateAdd=@DateAdd, Status=@Status WHERE CatId=@CatId";
				System.Diagnostics.Debug.WriteLine("מבצע עדכון קטגוריה קיימת");
			}

			System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

			DbContext Db = new DbContext();
			var Obj = new
			{
				CatId = Tmp.CatId,
				CatName = Tmp.CatName,
				DateAdd = Tmp.DateAdd,
				Status = Tmp.Status
			};
			var LstParma = DbContext.CreateParameters(Obj);

			try
			{
				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

				if (rowsAffected > 0)
				{
					System.Diagnostics.Debug.WriteLine("הפעולה בוצעה בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine("לא בוצע שינוי בבסיס הנתונים. יש לבדוק את השאילתה והפרמטרים.");
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בביצוע הפעולה: {ex.Message}");
			}
			finally
			{
				Db.Close();
				System.Diagnostics.Debug.WriteLine("החיבור לבסיס הנתונים נסגר");
			}

			System.Diagnostics.Debug.WriteLine("------------- סיום תהליך שמירת קטגוריה -------------");
		}

		public static void UpdateCategories(Categories Tmp)
		{
			System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך עדכון קטגוריה -------------");
			System.Diagnostics.Debug.WriteLine($"נתוני קטגוריה לעדכון: CatId={Tmp.CatId}, CatName={Tmp.CatName}, DateAdd={Tmp.DateAdd}, Status={Tmp.Status}");

			try
			{
				string sql = "UPDATE T_Categories SET CatName = @CatName, DateAdd = @DateAdd, Status = @Status WHERE CatId = @CatId";
				System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

				DbContext Db = new DbContext();
				var Obj = new
				{
					Tmp.CatId,
					Tmp.CatName,
					Tmp.DateAdd,
					Tmp.Status,
				};
				var LstParma = DbContext.CreateParameters(Obj);

				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

				if (rowsAffected > 0)
				{
					System.Diagnostics.Debug.WriteLine("הקטגוריה עודכנה בהצלחה.");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine("לא בוצע עדכון. יש לבדוק את מזהה הקטגוריה והפרמטרים.");
				}

				Db.Close();
				System.Diagnostics.Debug.WriteLine("החיבור לבסיס הנתונים נסגר");
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בתהליך עדכון הקטגוריה: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
			}

			System.Diagnostics.Debug.WriteLine("------------- סיום תהליך עדכון קטגוריה -------------");
		}
		// אחזור כל הקטגוריות
		public static List<Categories> GetAll()
		{
			List<Categories> CategoriesList = new List<Categories>();
			string sql = "Select * from T_Categories";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Categories Tmp = new Categories()
					{
						CatId = int.Parse(Dt.Rows[i]["CatId"].ToString()),
						CatName = Dt.Rows[i]["CatName"].ToString(),
						DateAdd = DateTime.Parse(Dt.Rows[i]["DateAdd"].ToString()),
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

					CategoriesList.Add(Tmp);
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

			return CategoriesList;
		}
		// אחזור לפי זיהוי
		public static Categories GetById(int Id)
		{
			Categories Tmp = null;
			string sql = $"Select * from T_Categories Where CatId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Categories()
				{
					CatId = int.Parse(Dt.Rows[0]["CatId"].ToString()),
					CatName = Dt.Rows[0]["CatName"].ToString(),
					DateAdd = DateTime.Parse(Dt.Rows[0]["DateAdd"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"])
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Categories Where CatId={Id}";
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
