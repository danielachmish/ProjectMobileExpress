﻿using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class RatingDAL
	{
		public static void Save(Rating Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.RatingId == -1)
			{
				sql = "insert into T_Rating(Date,Grade,Description,TecId,CusId,Comment)" +
					$"Values(@Date,@Grade,@Description,@TecId,@CusId,@Comment)";
			}
			else
			{
				sql = $"Update Rating set Date=@Date,Grade=@Grade,Description=@Description,TecId=@TecId,CusId=@CusId,Comment=@Comment where RatingId=@RatingId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				RatingId = Tmp.RatingId,
				Date = Tmp.Date,
				Grade = Tmp.Grade,
				Description = Tmp.Description,
				TecId = Tmp.TecId,
				CusId = Tmp.CusId,
				Comment = Tmp.Comment,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<Rating> GetAll()
		{
			List<Rating> RatingList = new List<Rating>();
			string sql = "Select * from T_Rating";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Rating Tmp = new Rating()
					{
						RatingId = int.Parse(Dt.Rows[i]["RatingId"].ToString()),
						Date = Dt.Rows[i]["Date"].ToString(),
						Grade = Dt.Rows[i]["Grade"].ToString(),
						Description = Dt.Rows[i]["Description"].ToString(),
						TecId = int.Parse(Dt.Rows[0]["TecId"].ToString()),
						CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
						Comment = Dt.Rows[i]["Comment"].ToString()
					};

					RatingList.Add(Tmp);
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

			return RatingList;
		}
		// אחזור לפי זיהוי
		public static Rating GetById(int Id)
		{
			Rating Tmp = null;
			string sql = $"Select * from T_Rating Where RatingId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Rating()
				{
					RatingId = int.Parse(Dt.Rows[0]["RatingId"].ToString()),
					Date = Dt.Rows[0]["Date"].ToString(),
					Grade = Dt.Rows[0]["Grade"].ToString(),
					Description = Dt.Rows[0]["Description"].ToString(),
					TecId = int.Parse(Dt.Rows[0]["TecId"].ToString()),
					CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
					Comment = Dt.Rows[0]["Comment"].ToString(),
				};
			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Rating Where RatingId={Id}";
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