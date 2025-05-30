﻿using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IdentityModel.Protocols.WSTrust;
using System.Linq;
using System.Web;

namespace DAL
{
	public class ReadabilityDAL
	{
		
		public static void Save(Readability Tmp)
		{
			

			Debug.WriteLine("נכנס לפונקציית SaveNewRead");
			Debug.WriteLine($"פרטי הלקוח: ReadId={Tmp.ReadId}, FullName={Tmp.FullName}, Phone={Tmp.Phone}");

			string sql;
			if (Tmp.ReadId == -1 || Tmp.ReadId == 0)
			{
				Debug.WriteLine("מבצע הכנסה של לקוח חדש");
				sql = "INSERT INTO T_Readability(DateRead,[Desc],FullName,Phone,Nots,CusId,ModelId,Status,CallStatus,Urgency,SerProdId,ModelCode) " +
					  "VALUES(@DateRead,@Desc,@FullName,@Phone,@Nots,@CusId,@ModelId,@Status,@CallStatus,@Urgency,@SerProdId,@ModelCode)";
			}
			else
			{
				Debug.WriteLine($"מבצע עדכון של לקוח קיים עם ReadId={Tmp.ReadId}");
				sql = "UPDATE T_Readability SET DateRead=@DateRead,[Desc]=@Desc,FullName=@FullName,Phone=@Phone,Nots=@Nots," +
					  "CusId=@CusId,ModelId=@ModelId,Status=@Status,CallStatus=@CallStatus,Urgency=@Urgency,SerProdId=@SerProdId,ModelCode=@ModelCode WHERE ReadId=@ReadId";
			}

			Debug.WriteLine($"SQL Query: {sql}");

			DbContext Db = new DbContext();
			try
			{
				var Obj = new
				{
					ReadId = Tmp.ReadId,
					DateRead = Tmp.DateRead,
					Desc = Tmp.Desc,
					FullName = Tmp.FullName,
					Phone = Tmp.Phone,
					Nots = Tmp.Nots,
					CusId = Tmp.CusId,
					ModelId = string.IsNullOrEmpty(Tmp.ModelId) ? DBNull.Value : (object)Tmp.ModelId,
					Status = Tmp.Status,
					//NameImage = Tmp.NameImage,
					CallStatus = (int)Tmp.CallStatus,
					Urgency = Tmp.Urgency,
					SerProdId = Tmp.SerProdId,
					ModelCode=Tmp.ModelCode
					
				};

				var LstParma = DbContext.CreateParameters(Obj);
				Debug.WriteLine($"מספר פרמטרים שנוצרו: {LstParma.Count}");

				Debug.WriteLine("מבצע את השאילתה");
				Db.ExecuteNonQuery(sql, LstParma);
				Debug.WriteLine("השאילתה בוצעה בהצלחה");
			}
			catch (Exception ex)
			{
				Debug.WriteLine($"שגיאה בביצוע השאילתה: {ex.Message}");
				throw; // זורק את החריגה מחדש כדי לאפשר טיפול ברמה גבוהה יותר
			}
			finally
			{
				Db.Close();
				Debug.WriteLine("החיבור לבסיס הנתונים נסגר");
			}

			Debug.WriteLine("סיום פונקציית SaveNewCustomers");
		}

	

		public static void UpdateReadability(Readability Tmp)
		{
			try
			{
				string sql = "UPDATE T_Readability SET DateRead=@DateRead,[Desc]=@Desc,FullName=@FullName,Phone=@Phone,Nots=@Nots," +
						  "CusId=@CusId,ModelId=@ModelId,Status=@Status,Urgency=@Urgency,SerProdId=@SerProdId,ModelCode=@ModelCode," +
						  "AssignedTechnicianId=@AssignedTechnicianId,CallStatus=@CallStatus WHERE ReadId=@ReadId";

				DbContext Db = new DbContext();
				var Obj = new
				{
					Tmp.ReadId,
					Tmp.DateRead,
					Tmp.Desc,
					Tmp.FullName,
					Tmp.Phone,
					Tmp.Nots,
					Tmp.CusId,
					ModelId = string.IsNullOrEmpty(Tmp.ModelId) ? DBNull.Value : (object)Tmp.ModelId,
					Tmp.Status,
					Tmp.CallStatus,
					Tmp.Urgency,
					Tmp.SerProdId,
					Tmp.ModelCode,
					AssignedTechnicianId = Tmp.AssignedTechnicianId.HasValue ? (object)Tmp.AssignedTechnicianId.Value : DBNull.Value
				
				};

				var LstParma = DbContext.CreateParameters(Obj);
				Db.ExecuteNonQuery(sql, LstParma);
				Db.Close();
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in UpdateReadability method: {ex.Message}");
				throw;
			}
		}
		// אחזור כל הלקוחות
		public static List<Readability> GetAll()

		{
			List<Readability> ReadabilityList = new List<Readability>();
			string sql = "SELECT * FROM T_Readability ORDER BY DateRead DESC";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);

			try
			{
				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Readability Tmp = new Readability()
					{
						ReadId = int.Parse(Dt.Rows[i]["ReadId"].ToString()),
						DateRead = DateTime.Parse(Dt.Rows[i]["DateRead"].ToString()),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						FullName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[i]["Phone"].ToString(),
						Nots = Dt.Rows[i]["Nots"].ToString(),
						CusId = int.Parse(Dt.Rows[i]["CusId"].ToString()),
						ModelId = Dt.Rows[i]["ModelId"].ToString(),
						Status = true,// המרה בשלושה חלקים
									   //NameImage = Dt.Rows[i]["NameImage"].ToString(),
						CallStatus = (CallStatus)Convert.ToInt32(Dt.Rows[i]["CallStatus"]),
						Urgency = Dt.Rows[i]["Urgency"].ToString(),
						SerProdId = int.Parse(Dt.Rows[i]["SerProdId"].ToString()),
						ModelCode = Dt.Rows[i]["ModelCode"].ToString()
					};

					// המרת ערך ה-Status לבוליאני
					bool status;
					// המרת ערך ה-Status מהדאטהבייס לבוליאני
					if (Dt.Rows[i]["Status"] != DBNull.Value)
					{
						// אם הערך הוא 1 או true בדאטהבייס, Status יהיה true
						Tmp.Status = Convert.ToBoolean(Dt.Rows[i]["Status"]);
					}
					else
					{
						// אם הערך הוא NULL בדאטהבייס, נגדיר ברירת מחדל
						Tmp.Status = false;
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
			string sql = $"Select * from T_Readability Where ReadId ={Id}";
			DbContext Db = new DbContext();
			DataTable Dt = Db.Execute(sql);
			if (Dt.Rows.Count > 0)
			{
				Tmp = new Readability()
				{
					ReadId = int.Parse(Dt.Rows[0]["ReadId"].ToString()),
					DateRead = DateTime.Parse(Dt.Rows[0]["DateRead"].ToString()),
					Desc = Dt.Rows[0]["Desc"].ToString(),
					FullName = Dt.Rows[0]["FullName"].ToString(),
					Phone = Dt.Rows[0]["Phone"].ToString(),
					Nots = Dt.Rows[0]["Nots"].ToString(),
					CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
					ModelId = Dt.Rows[0]["ModelId"].ToString(),
					//NameImage = Dt.Rows[0]["NameImage"].ToString(),
					CallStatus = (CallStatus)Convert.ToInt32(Dt.Rows[0]["CallStatus"]),
					Urgency = Dt.Rows[0]["Urgency"].ToString(),
					SerProdId = int.Parse(Dt.Rows[0]["SerProdId"].ToString()),
					Status = Convert.ToBoolean(Dt.Rows[0]["Status"]),
					ModelCode= Dt.Rows[0]["ModelCode"].ToString(),
 AssignedTechnicianId = string.IsNullOrEmpty(Dt.Rows[0]["AssignedTechnicianId"].ToString()) ?
				null :
				(int?)Convert.ToInt32(Dt.Rows[0]["AssignedTechnicianId"])
				};
			}
			Db.Close();
			return Tmp;
		}
		public static List<Readability> GetAllByCustomerId(int cusId)
		{
			List<Readability> ReadabilityList = new List<Readability>();
			string sql = $"SELECT * FROM T_Readability WHERE CusId = {cusId} ORDER BY DateRead DESC";
			DbContext Db = new DbContext();

			try
			{
				DataTable Dt = Db.Execute(sql);

				for (int i = 0; i < Dt.Rows.Count; i++)
				{
					Readability Tmp = new Readability()
					{
						ReadId = int.Parse(Dt.Rows[i]["ReadId"].ToString()),
						DateRead = DateTime.Parse(Dt.Rows[i]["DateRead"].ToString()),
						Desc = Dt.Rows[i]["Desc"].ToString(),
						FullName = Dt.Rows[i]["FullName"].ToString(),
						Phone = Dt.Rows[i]["Phone"].ToString(),
						Nots = Dt.Rows[i]["Nots"].ToString(),
						CusId = int.Parse(Dt.Rows[i]["CusId"].ToString()),
						ModelId = Dt.Rows[i]["ModelId"].ToString(),
						Status = Convert.ToBoolean(Dt.Rows[i]["Status"]),
						CallStatus = (CallStatus)Convert.ToInt32(Dt.Rows[i]["CallStatus"]),
						Urgency = Dt.Rows[i]["Urgency"].ToString(),
						SerProdId = int.Parse(Dt.Rows[i]["SerProdId"].ToString()),
						ModelCode = Dt.Rows[i]["ModelCode"].ToString(),

					};
					ReadabilityList.Add(Tmp);
				}
			}
			catch (Exception ex)
			{
				Debug.WriteLine($"Error in GetAllByCustomerId: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}

			return ReadabilityList;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Readability Where ReadId={Id}";
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
		public static int GetTotalReadability()
		{
			string sql = "SELECT COUNT(*) FROM T_Readability";
			DbContext Db = new DbContext();

			try
			{
				// השתמש ב-CreateParameters עם אובייקט ריק
				var LstParma = DbContext.CreateParameters(new { });

				object result = Db.ExecuteScalar(sql, LstParma);
				return Convert.ToInt32(result);
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetTotalReadability: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}
		}
		public static List<Readability> GetAllByTechnicianId(int technicianId)
		{
			string sql = @"
    SELECT * 
    FROM T_Readability 
    WHERE AssignedTechnicianId = @TechnicianId";

			using (var db = new DbContext())
			{
				var parameters = new List<SqlParameter>
		{
			new SqlParameter("@TechnicianId", technicianId)
		};

				Console.WriteLine($"Executing query: {sql} with TechnicianId={technicianId}");
				DataTable dt = db.Execute(sql, parameters);
				Console.WriteLine($"Rows returned: {dt.Rows.Count}");

				return ConvertToList(dt);
			}
		}


		// המרה מטבלה לאובייקטים
		private static List<Readability> ConvertToList(DataTable dt)
		{
			var list = new List<Readability>();
			foreach (DataRow row in dt.Rows)
			{
				list.Add(new Readability
				{
					ReadId = Convert.ToInt32(row["ReadId"]),
					DateRead = Convert.ToDateTime(row["DateRead"]),
					Desc = row["Desc"].ToString(),
					FullName = row["FullName"].ToString(),
					Phone = row["Phone"].ToString(),
					Nots = row["Nots"].ToString(),
					CusId = Convert.ToInt32(row["CusId"]),
					ModelId = row["ModelId"].ToString(),
					Status = Convert.ToBoolean(row["Status"]),
					NameImage = row["NameImage"].ToString(),
					Urgency = row["Urgency"].ToString(),
					SerProdId = Convert.ToInt32(row["SerProdId"]),
					AssignedTechnicianId = row["AssignedTechnicianId"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["AssignedTechnicianId"]),
					CallStatus = (CallStatus)Convert.ToInt32(row["CallStatus"]),
					ModelCode = row["ModelCode"].ToString(),
					TreatmentStartTime = row["TreatmentStartTime"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["TreatmentStartTime"]),
					TechnicianNotes = row["TechnicianNotes"].ToString()
				});
			}
			return list;
		}

		public static int CountCallsByTechnicianIdAndStatus(int technicianId, CallStatus status)
		{
			string sql = @"
    SELECT COUNT(*) 
    FROM T_Readability 
    WHERE AssignedTechnicianId = @TechnicianId 
      AND CallStatus = @CallStatus";

			using (var db = new DbContext())
			{
				var parameters = new List<SqlParameter>
		{
			new SqlParameter("@TechnicianId", technicianId),
			new SqlParameter("@CallStatus", (int)status)
		};

				Console.WriteLine($"Executing query: {sql} with TechnicianId={technicianId} and CallStatus={(int)status}");
				int count = Convert.ToInt32(db.ExecuteScalar(sql, parameters));
				Console.WriteLine($"Count returned: {count}");
				return count;
			}
		}


	}
	public static class ReadabilityStatsDAL
	{
		public static (int totalCalls, int acceptedCalls) GetTechnicianStats(int technicianId)
		{
			// שינוי השאילתה כך שתתאים למבנה הטבלאות שלך
			string sql = @"SELECT 
            (SELECT COUNT(*) FROM T_Readability WHERE Status = 0) as TotalCalls,
            (SELECT COUNT(*) FROM T_Readability WHERE Status = 1) as AcceptedCalls";

			DbContext db = new DbContext();
			try
			{
				DataTable dt = db.Execute(sql);

				if (dt.Rows.Count > 0)
				{
					return (
						Convert.ToInt32(dt.Rows[0]["TotalCalls"]),
						Convert.ToInt32(dt.Rows[0]["AcceptedCalls"])
					);
				}
				return (0, 0);
			}
			finally
			{
				db.Close();
			}
		}
		


	}

}