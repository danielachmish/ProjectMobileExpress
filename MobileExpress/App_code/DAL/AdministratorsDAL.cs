using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Data;
using System.Data.SqlClient;
using System.Data;
using BLL;


namespace DAL
{
	public class AdministratorsDAL
	{
		// יצירת משתמש חדש או עדכון משתמש קיים
		public static void Save(Administrators Tmp)
		{
			// בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
			string sql;
			if (Tmp.AdminId == -1)
			{
				sql = "insert into T_Administrators(FullName,Phone,Addres,Uname,Pass,DateAdd,Status,Email)" +
					$"Values(@FullName,@Phone,@Addres,@Uname,@Pass,@DateAdd,@Status,@Email)";
			}
			else
			{
				sql = $"Update T_Administrators set FullName=@FullName,Phone=@Phone,Addres=@Addres,Uname=@Uname,Pass=@Pass,DateAdd=@DateAdd,Status=@Status,Email=@Email where AdminId=@AdminId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				AdminId = Tmp.AdminId,
				FullName = Tmp.FullName,
				Phone = Tmp.Phone,
				Addres = Tmp.Addres,
				Uname = Tmp.Uname,
				Pass = Tmp.Pass,
				DateAdd = Tmp.DateAdd,
				Status = Tmp.Status,
				Email = Tmp.Email
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל המשתמשים
		public static List<Administrators> GetAll()	
		{
			List<Administrators> AdministratorsList = new List<Administrators>();
			string sql = "Select * from T_Administrators";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Administrators Tmp = new Administrators()
					{
						AdminId = int.Parse(Dt.Rows[i]["AdminId"].ToString()),
						FullName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[i]["Phone"].ToString(),
						Addres = Dt.Rows[i]["Addres"].ToString(),
						Uname = Dt.Rows[i]["Uname"].ToString(),
						Pass = Dt.Rows[i]["Pass"].ToString(),
						DateAdd = DateTime.Parse(Dt.Rows[i]["DateAdd"].ToString()),
						Status = false,  // המרה בשלושה חלקים
						Email = Dt.Rows[i]["Email"].ToString(),
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

					AdministratorsList.Add(Tmp);
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

		return AdministratorsList;
		}
		// אחזור לפי זיהוי
		public static Administrators GetById(int Id)
		{
			Administrators Tmp = null;
			string sql = $"Select * from T_Administrators Where AdminId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Administrators()
				{
					AdminId = int.Parse(Dt.Rows[0]["AdminId"].ToString()),
					FullName = Dt.Rows[0]["FullName"].ToString(),
					Phone = Dt.Rows[0]["Phone"].ToString(),
					Addres = Dt.Rows[0]["Addres"].ToString(),
					Uname = Dt.Rows[0]["Uname"].ToString(),
					Pass = Dt.Rows[0]["Pass"].ToString(),
					DateAdd = DateTime.Parse(Dt.Rows[0]["DateAdd"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"]), 
					Email = Dt.Rows[0]["Email"].ToString(),
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Administrators Where AdminId={Id}";
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