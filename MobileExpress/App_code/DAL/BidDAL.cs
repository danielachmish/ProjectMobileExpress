using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using System.Diagnostics;
using Data;
using System.Data;

namespace DAL
{
	public class BidDAL
	{   // יצירת ביד חדש או עדכון ביד קיים
		public static void Save(Bid Tmp)
		{
			string Sql;
			if (Tmp.BidId == -1)
			{
				Sql = "insert into T_Bid(Desc,Price,Status,TecId,ReadId,Date)" +
					$"Values(@Desc,@Price,@Status,@TecId,@ReadId,@Date)";
			}
			else
			{
				Sql = $"Update T_BidId set Desc=@Desc,Price=@Price,Status=@Status,TecId=@TecId,ReadId=@ReadId,Date=@Date where BidId=@BidId";
			}

			DbContext Db = new DbContext();

			var Obj = new
			{
				BidId=Tmp.BidId,
				Desc=Tmp.Desc,
				Price=Tmp.Price,
				Status=Tmp.Status,
				TecId=Tmp.TecId,
				ReadId=Tmp.ReadId,
				Date=Tmp.Date
			};


			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(Sql, LstParma);

			Db.Close();
		}
		// אחזור כל הבידים
		public static List<Bid> GetAll()
		{
			List<Bid> BidList = new List<Bid>();
			string sql = "Select * from T_Bid";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Bid Tmp = new Bid()
					{
						BidId = int.Parse(Dt.Rows[i]["BidId"].ToString()),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						Price = int.Parse(Dt.Rows[i]["Price"].ToString()),
						TecId = int.Parse(Dt.Rows[i]["TecId"].ToString()),
						ReadId = int.Parse(Dt.Rows[i]["ReadId"].ToString()),
						Date = DateTime.Parse(Dt.Rows[i]["Date"].ToString()),
						Status = false,  // המרה בשלושה חלקים
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

					BidList.Add(Tmp);
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

			return BidList;
		}
		// אחזור לפי זיהוי
		public static Bid GetById(int Id)
		{
			Bid Tmp = null;
			string sql = $"Select * from T_Bid Where BidId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Bid()
				{
					BidId = int.Parse(Dt.Rows[0]["BidId"].ToString()),
					Desc = Dt.Rows[0]["Desc"].ToString(),
					Price = float.Parse(Dt.Rows[0]["Price"].ToString()),
					TecId =int.Parse(Dt.Rows[0]["TecId"].ToString()),
					ReadId =int.Parse(Dt.Rows[0]["Uname"].ToString()),
					Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"]),
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Bid Where BidId={Id}";
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
	
	
	
