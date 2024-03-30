using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class ManufacturersDAL
	{
		public static void Save(Manufacturers Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.ManuId == -1)
			{
				sql = "insert into T_Manufacturers(ManuName,Desc,NameImage,Date)" +
					$"Values(@ManuName,Desc,@NameImage,@Date)";
			}
			else
			{
				sql = $"Update T_Manufacturers set ManuName=@ManuName,Desc=@Desc,NameImage=@NameImage,Date=@Date where ManuId=@ManuId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				ManuId = Tmp.ManuId,
				ManuName = Tmp.ManuName,
				Desc = Tmp.Desc,
				NameImage = Tmp.NameImage,
				Date = Tmp.Date,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<Manufacturers> GetAll()
		{
			List<Manufacturers> ManufacturersList = new List<Manufacturers>();
			string sql = "Select * from T_Manufacturers";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Manufacturers Tmp = new Manufacturers()
					{
						ManuId = int.Parse(Dt.Rows[i]["ManuId"].ToString()),
						ManuName = Dt.Rows[i]["ManuName"].ToString(),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						NameImage = Dt.Rows[i]["NameImage"].ToString(),
						Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
					};

					ManufacturersList.Add(Tmp);
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

			return ManufacturersList;
		}
		// אחזור לפי זיהוי
		public static Manufacturers GetById(int Id)
		{
			Manufacturers Tmp = null;
			string sql = $"Select * from T_Manufacturers Where ManuId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Manufacturers()
				{
					ManuId = int.Parse(Dt.Rows[0]["ManuId"].ToString()),
					ManuName = Dt.Rows[0]["ManuName"].ToString(),
					Desc = Dt.Rows[0]["Desc"].ToString(),
					NameImage = Dt.Rows[0]["NameImage"].ToString(),
					Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Manufacturers Where ManuId={Id}";
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