using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.IdentityModel.Protocols.WSTrust;
using System.Linq;
using System.Web;

namespace DAL
{
	public class ReadabilityDAL
	{
		public static void Save(Readability Tmp)
		{
			// בדיקה אם הלקוח קיים - עדכון, אחרת הוספת לקוח חדש
			string sql;
			if (Tmp.ReadiId == -1)
			{
				sql = "insert into T_Readability(DateRead,Desc,FullName,Phone,Nots,CusId,ModelId,Status,NameImage,Urgency,SerProdId)" +
					$"Values(@DateRead,@Desc,@FullName,@Phone,@Nots,@CusId,@ModelId,@Status,@NameImage,@Urgency,@SerProdId)";
			}
			else
			{
				sql = $"Update Readability set DateRead=@DateRead,Desc=@Desc,FullName=@FullName,Phone=@Phone,Nots=@Nots,CusId=@CusId,ModelId=@ModelId,Status=@Status,NameImage=@NameImage,Urgency=@Urgency,SerProdId=@SerProdId where ReadiId=@ReadiId";
			}

			DbContext Db = new DbContext();
			var Obj = new
			{
				ReadiId = Tmp.ReadiId,
				DateRead = Tmp.DateRead,
				Desc = Tmp.Desc,
				FullName = Tmp.FullName,
				Phone = Tmp.Phone,
				Nots = Tmp.Nots,
				CusId = Tmp.CusId,
				ModelId = Tmp.ModelId,
				Status = Tmp.Status,
				NameImage = Tmp.NameImage,
				Urgency = Tmp.Urgency,
				SerProdId = Tmp.SerProdId,
			};

			var LstParma = DbContext.CreateParameters(Obj);
			// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
			Db.ExecuteNonQuery(sql, LstParma);

			Db.Close();
		}
		// אחזור כל הלקוחות
		public static List<Readability> GetAll()
		{
			List<Readability> ReadabilityList = new List<Readability>();
			string sql = "Select * from T_Readability";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Readability Tmp = new Readability()
					{
						ReadiId = int.Parse(Dt.Rows[i]["ReadiId"].ToString()),
						DateRead = DateTime.Parse(Dt.Rows[i]["DateRead"].ToString()),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						FullName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[0]["Phone"].ToString(),
						Nots = Dt.Rows[0]["Nots"].ToString(),
						CusId = int.Parse(Dt.Rows[i]["CusId"].ToString()),
						ModelId = int.Parse(Dt.Rows[i]["ModelId"].ToString()),
						Status = false ,// המרה בשלושה חלקים
						NameImage = Dt.Rows[i]["NameImage"].ToString(),
						Urgency = Dt.Rows[i]["Urgency"].ToString(),
						SerProdId = int.Parse(Dt.Rows[i]["SerProdId"].ToString())
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

					ReadabilityList.Add(Tmp);
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

			return ReadabilityList;
		}
		// אחזור לפי זיהוי
		public static Readability GetById(int Id)
		{
			Readability Tmp = null;
			string sql = $"Select * from T_Readability Where ReadiId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Readability()
				{
					ReadiId = int.Parse(Dt.Rows[0]["ReadiId"].ToString()),
					DateRead = DateTime.Parse(Dt.Rows[0]["DateRead"].ToString()),
					Desc = Dt.Rows[0]["Desc"].ToString(),
					FullName = Dt.Rows[0]["FullName"].ToString(),
					Phone = Dt.Rows[0]["Phone"].ToString(),
					Nots = Dt.Rows[0]["Nots"].ToString(),
					CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
					ModelId = int.Parse(Dt.Rows[0]["ModelId"].ToString()),
					NameImage = Dt.Rows[0]["NameImage"].ToString(),
					Urgency = Dt.Rows[0]["Urgency"].ToString(),
					SerProdId = int.Parse(Dt.Rows[0]["SerProdId"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"])
				};

			}
			Db.Close();
			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Readability Where ReadiId={Id}";
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