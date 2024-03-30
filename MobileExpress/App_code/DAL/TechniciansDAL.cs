using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class TechniciansDAL
	{
		public static void Save(Technicians Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.TecId == -1)
			{
				sql = "insert into T_Technicians(TecNum,FulName,Phone,Address,Pass,UserName,Type,History,Nots,Email,Status,SerProdId,DateAddition)" +
					$"Values(@TecNum,@FulName,@Phone,@Address,@Pass,@UserName,@DateAdd,@Type,@History,@Nots,@Email,@Status,@SerProdId,@DateAddition)";
			}
			else
			{
				sql = $"Update T_Technicians set TecNum=@TecNum,FulName=@FulName,Phone=@Phone,Address=@Address,Pass=@Pass,UserName=@UserName,Type=@Type,History=@History,Nots=@Nots,Email=@Email,Status=@Status,SerProdId=@SerProdId,DateAddition=@DateAddition where TecId=@TecId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				TecId = Tmp.TecId,
				TecNum = Tmp.TecNum,
				FulName = Tmp.FulName,
				Phone = Tmp.Phone,
				Address = Tmp.Address,
				Pass = Tmp.Pass,
				UserName = Tmp.UserName,
				Type=Tmp.Type,
				Status = Tmp.Status,
				History = Tmp.History,
				Nots = Tmp.Nots,
				Eamil=Tmp.Email,
				SerProdId = Tmp.SerProdId,
				DateAddition = Tmp.DateAddition
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<Technicians> GetAll()
		{
			List<Technicians> TechniciansList = new List<Technicians>();
			string sql = "Select * from T_Technicians";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Technicians Tmp = new Technicians()
					{
						TecId = int.Parse(Dt.Rows[i]["TecId"].ToString()),
						TecNum = int.Parse(Dt.Rows[i]["TecNum"].ToString()),
						FulName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[i]["Phone"].ToString(),
						Address = Dt.Rows[i]["Address"].ToString(),
						Pass = Dt.Rows[i]["Pass"].ToString(),
						UserName = Dt.Rows[i]["UserName"].ToString(),
						Type = Dt.Rows[i]["Type"].ToString(),
						History = Dt.Rows[i]["History"].ToString(),
						Nots = Dt.Rows[i]["Nots"].ToString(),
						Email = Dt.Rows[i]["Eamil"].ToString(),
						SerProdId = int.Parse(Dt.Rows[i]["SerProdId"].ToString()),
						DateAddition = Dt.Rows[i]["DateAddition"].ToString(),
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

					TechniciansList.Add(Tmp);
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

			return TechniciansList;
		}
		// אחזור לפי זיהוי
		public static Technicians GetById(int Id)
		{
			Technicians Tmp = null;
			string sql = $"Select * from T_Technicians Where TecId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Technicians()
				{
					TecId = int.Parse(Dt.Rows[0]["TecId"].ToString()),
					TecNum = int.Parse(Dt.Rows[0]["TecNum"].ToString()),
					FulName = Dt.Rows[0]["FullName"].ToString(),
					Phone = Dt.Rows[0]["Phone"].ToString(),
					Address = Dt.Rows[0]["Address"].ToString(),
					Pass = Dt.Rows[0]["Pass"].ToString(),
					UserName = Dt.Rows[0]["UserName"].ToString(),
					Type = Dt.Rows[0]["Type"].ToString(),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"]),
					History = Dt.Rows[0]["History"].ToString(),
					Nots = Dt.Rows[0]["Nots"].ToString(),
					Email = Dt.Rows[0]["Eamil"].ToString(),
					SerProdId = int.Parse(Dt.Rows[0]["SerProdId"].ToString()),
					DateAddition = Dt.Rows[0]["DateAddition"].ToString()
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Technicians Where TecId={Id}";
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