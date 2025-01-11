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
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל תהליך שמירה...");
				System.Diagnostics.Debug.WriteLine($"AdminId: {Tmp.AdminId}");
				System.Diagnostics.Debug.WriteLine($"FullName: {Tmp.FullName}");
				System.Diagnostics.Debug.WriteLine($"Status: {Tmp.Status}");

				string sql;
				if (Tmp.AdminId <= 0)
				{
					sql = @"INSERT INTO T_Administrators 
                    (FullName, Phone, Addres, Uname, Pass, DateAdd, Status, Email)
                    VALUES 
                    (@FullName, @Phone, @Addres, @Uname, @Pass, @DateAdd, @Status, @Email);
                    SELECT SCOPE_IDENTITY();";
				}
				else
				{
					sql = @"UPDATE T_Administrators 
                    SET FullName=@FullName, 
                        Phone=@Phone, 
                        Addres=@Addres, 
                        Uname=@Uname, 
                        Pass=@Pass, 
                        DateAdd=@DateAdd, 
                        Status=@Status, 
                        Email=@Email 
                    WHERE AdminId=@AdminId";
				}

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						AdminId = Tmp.AdminId,
						FullName = Tmp.FullName,
						Phone = Tmp.Phone,
						Addres = Tmp.Addres,
						Uname = Tmp.Uname,
						Pass = Tmp.Pass,
						DateAdd = Tmp.DateAdd,
						Status = Convert.ToInt32(Tmp.Status),  // המרה ל-TINYINT
						Email = Tmp.Email
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int result = Db.ExecuteNonQuery(sql, LstParma);
					System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {result}");
				}
				finally
				{
					Db.Close(); // סגירת החיבור
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת נתונים: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				throw;
			}
		}

		public static void UpdateAdministrators(Administrators Tmp)
		{
			try
			{
				string sql = @"UPDATE T_Administrators 
                      SET FullName = @FullName,
                          Phone = @Phone,
                          Addres = @Addres,
                          Pass = @Pass,
                          Uname = @Uname,
                          DateAdd = @DateAdd,
                          Status = @Status,
                          Email = @Email 
                      WHERE AdminId = @AdminId";

				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						Tmp.AdminId,
						Tmp.FullName,
						Tmp.Phone,
						Tmp.Addres,
						Tmp.Uname,
						Tmp.Pass,
						Tmp.DateAdd,
						Status = Convert.ToInt32(Tmp.Status),
						Tmp.Email,
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
					System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine("Administrators updated successfully.");
					}
					else
					{
						System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
					}
				}
				finally
				{
					Db.Close(); // סגירת החיבור
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in UpdateAdministrators method: {ex.Message}");
				throw;
			}
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