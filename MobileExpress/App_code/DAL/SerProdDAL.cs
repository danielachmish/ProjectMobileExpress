﻿using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
	public class SerProdDAL
	{
		public static void Save(SerProd Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.SerProdId == -1)
			{
				sql = "insert into T_SerProd(Desc,Price,NameImage,Status,Nots)" +
					$"Values(@Desc,@Price,@NameImage,@Status,@Nots)";
			}
			else
			{
				sql = $"Update SerProd set Desc=@Desc,Price=@Price,NameImage=@NameImage,Status=@Status,Nots=@Nots where SerProdId=@SerProdId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				SerProdId = Tmp.SerProdId,
				Price = Tmp.Price,
				Desc = Tmp.Desc,
				NameImage = Tmp.NameImage,
				Nots = Tmp.Nots,
				Status = Tmp.Status,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<SerProd> GetAll()
		{
			List<SerProd> SerProdList = new List<SerProd>();
			string sql = "Select * from T_SerProd";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					SerProd Tmp = new SerProd()
					{
						SerProdId = int.Parse(Dt.Rows[i]["SerProdId"].ToString()),
						Price = float.Parse(Dt.Rows[i]["Price"].ToString()),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						Nots = Dt.Rows[0]["Nots"].ToString(),
						Status = false,// המרה בשלושה חלקים
						NameImage = Dt.Rows[i]["NameImage"].ToString(),
						
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

					SerProdList.Add(Tmp);
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

			return SerProdList;
		}
		// אחזור לפי זיהוי
		public static SerProd GetById(int Id)
		{
			SerProd Tmp = null;
			string sql = $"Select * from T_SerProd Where SerProdId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new SerProd()
				{
					SerProdId = int.Parse(Dt.Rows[0]["SerProdId"].ToString()),
					Price = float.Parse(Dt.Rows[0]["Price"].ToString()),
					Desc = Dt.Rows[0]["Desc"].ToString(),
					Nots = Dt.Rows[0]["Nots"].ToString(),
					NameImage = Dt.Rows[0]["NameImage"].ToString(),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"])
				};

			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_SerProd Where SerProdId={Id}";
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