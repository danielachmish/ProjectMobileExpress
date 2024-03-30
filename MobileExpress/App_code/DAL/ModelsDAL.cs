using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class ModelsDAL
	{
		public static void Save(Models Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.ModelId == -1)
			{
				sql = "insert into T_Models(ModelName,ManuId,Image,Date)" +
					$"Values(@ModelName,@ManuId,@Image,@Date)";
			}
			else
			{
				sql = $"Update T_Models set ModelName=@ModelName,ManuId=@ManuId,Image=@Image,Date=@Date where ModelId=@ModelId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				ModelId = Tmp.ModelId,
				ModelName = Tmp.ModelName,
				ManuId = Tmp.ManuId,
				Image = Tmp.Image,
				Date = Tmp.Date,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<Models> GetAll()
		{
			List<Models> ModelsList = new List<Models>();
			string sql = "Select * from T_Models";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Models Tmp = new Models()
					{
						ModelId = int.Parse(Dt.Rows[i]["ManuId"].ToString()),
						ModelName = Dt.Rows[i]["ManuName"].ToString(),
						ManuId = int.Parse(Dt.Rows[i]["ManuId"].ToString()),
						Image = Dt.Rows[i]["Image"].ToString(),
						Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
					};

					ModelsList.Add(Tmp);
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

			return ModelsList;
		}
		// אחזור לפי זיהוי
		public static Models GetById(int Id)
		{
			Models Tmp = null;
			string sql = $"Select * from T_Models Where ModelId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Models()
				{
					ModelId = int.Parse(Dt.Rows[0]["ModelId"].ToString()),
					ModelName = Dt.Rows[0]["ModelName"].ToString(),
					ManuId = int.Parse(Dt.Rows[0]["ManuId"].ToString()),
					Image = Dt.Rows[0]["Image"].ToString(),
					Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Models Where ModelId={Id}";
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