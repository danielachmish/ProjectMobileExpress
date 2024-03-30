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
		public static void Save(Categories Tmp)
		{
			// בדיקה אם הקטגוריה קיימת - עדכון, אחרת הוספת קטגוריה חדשה
			string sql;
			if (Tmp.CatId == -1)
			{
				sql = "insert into T_Categories(CatName,DateAdd,Status)" +
					$"Values(@CatName,@DateAdd,@Status,";
			}
			else
			{
				sql = $"Update T_Categories set CatName=@CatName,DateAdd=@DateAdd,Status=@Status where CatId=@CatId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				CatId = Tmp.CatId,
				CatName = Tmp.CatName,
				DateAdd = Tmp.DateAdd,
				Status = Tmp.Status
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
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
