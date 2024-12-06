using BLL;
using Data;
using System;

using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace DAL
{
	public class CustomersDAL
	{

		//public static Customers GetByEmail(string email)
		//{
		//	Debug.WriteLine($"מחפש לקוח לפי אימייל: {email}");

		//	Customers customer = null;
		//	string sql = "SELECT * FROM T_Customers WHERE Email = @Email";
		//	DbContext db = new DbContext();

		//	try
		//	{
		//		var parameters = DbContext.CreateParameters(new { Email = email });
		//		DataTable dt = db.Execute(sql, parameters);

		//		if (dt.Rows.Count > 0)
		//		{
		//			customer = new Customers
		//			{
		//				CusId = int.Parse(dt.Rows[0]["CusId"].ToString()),
		//				FullName = dt.Rows[0]["FullName"].ToString(),
		//				Email = dt.Rows[0]["Email"].ToString(),
		//				Phone = dt.Rows[0]["Phone"].ToString(),
		//				Addres = dt.Rows[0]["Addres"].ToString(),
		//				Email = dt.Rows[0]["Email"].ToString(),
		//				Pass = dt.Rows[0]["Pass"].ToString(),
		//				DateAdd = DateTime.Parse(dt.Rows[0]["DateAdd"].ToString()),
		//				Status = Convert.ToBoolean(dt.Rows[0]["Status"]),
		//				History = dt.Rows[0]["History"].ToString(),
		//				Nots = dt.Rows[0]["Nots"].ToString(),
		//				CityId = int.Parse(dt.Rows[0]["CityId"].ToString()),
		//				GoogleId = dt.Rows[0]["GoogleId"].ToString()
		//			};

		//			Debug.WriteLine($"נמצא לקוח: {customer.FullName}");
		//		}
		//	}
		//	catch (Exception ex)
		//	{
		//		Debug.WriteLine($"שגיאה בחיפוש לקוח לפי אימייל: {ex.Message}");
		//		throw;
		//	}
		//	finally
		//	{
		//		db.Close();
		//	}

		//	return customer;
		//}
		public static Customers GetByEmail(string Email)
		{
			Debug.WriteLine($"מחפש לקוח לפי אימייל: {Email}");

			Customers customer = null;
			string sql = "SELECT * FROM T_Customers WHERE Email = @Email";
			DbContext db = new DbContext();

			try
			{
				SqlParameter parameter = new SqlParameter("@Email", Email);
				// העברת מערך של פרמטר אחד
				DataTable dt = db.Execute(sql, new SqlParameter[] { parameter });
				if (dt.Rows.Count > 0)
				{
					customer = new Customers
					{
						CusId = int.Parse(dt.Rows[0]["CusId"].ToString()),
						FullName = dt.Rows[0]["FullName"].ToString(),
						
						Phone = dt.Rows[0]["Phone"].ToString(),
						Addres = dt.Rows[0]["Addres"].ToString(),
						Email = dt.Rows[0]["Email"].ToString(),
						Pass = dt.Rows[0]["Pass"].ToString(),
						DateAdd = DateTime.Parse(dt.Rows[0]["DateAdd"].ToString()),
						Status = Convert.ToBoolean(dt.Rows[0]["Status"]),
						History = dt.Rows[0]["History"].ToString(),
						Nots = dt.Rows[0]["Nots"].ToString(),
						CityId = int.Parse(dt.Rows[0]["CityId"].ToString()),
						GoogleId = dt.Rows[0]["GoogleId"].ToString()
					};

					Debug.WriteLine($"נמצא לקוח: {customer.FullName}");
				}
			}
			catch (Exception ex)
			{
				Debug.WriteLine($"שגיאה בחיפוש לקוח לפי אימייל: {ex.Message}");
				throw;
			}
			finally
			{
				db.Close();
			}

			return customer;
		}

		//// עדכן את הפונקציות הקיימות כך שיתמכו בשדות החדשים
		//public static void SaveNewCustomers(Customers Tmp)
		//{
		//	string sql = "INSERT INTO T_Customers(FullName,Phone,Addres,Email,Pass,DateAdd,Status,Nots,CityId,Email,GoogleId) " +
		//			  "VALUES(@FullName,@Phone,@Addres,@Email,@Pass,@DateAdd,@Status,@Nots,@CityId,@Email,@GoogleId)";

		//	// שאר הקוד נשאר אותו דבר, רק צריך להוסיף את הפרמטרים החדשים
		//	DbContext Db = new DbContext();
		//	try
		//	{
		//		var Obj = new
		//		{
		//			Tmp.CusId,
		//			Tmp.FullName,
		//			Tmp.Phone,
		//			Tmp.Addres,
		//			Tmp.Email,
		//			Tmp.Pass,
		//			Tmp.DateAdd,
		//			Tmp.Status,
		//			Tmp.Nots,
		//			Tmp.CityId,
		//			Tmp.Email,
		//			Tmp.GoogleId
		//		};

		//		var LstParma = DbContext.CreateParameters(Obj);
		//		Db.ExecuteNonQuery(sql, LstParma);
		//	}
		//	catch (Exception ex)
		//	{
		//		Debug.WriteLine($"שגיאה בשמירת לקוח חדש: {ex.Message}");
		//		throw;
		//	}
		//	finally
		//	{
		//		Db.Close();
		//	}
		//}
		public static void SaveNewCustomers(Customers Tmp)
		{
			Debug.WriteLine("נכנס לפונקציית SaveNewCustomers");
			Debug.WriteLine($"פרטי הלקוח: CusId={Tmp.CusId}, FullName={Tmp.FullName}, Phone={Tmp.Phone}");

			string sql;
			if (Tmp.CusId == -1 || Tmp.CusId == 0)
			{
				Debug.WriteLine("מבצע הכנסה של לקוח חדש");
				sql = "INSERT INTO T_Customers(FullName,Phone,Addres,Email,Pass,DateAdd,Status) " +
					  "VALUES(@FullName,@Phone,@Addres,@Email,@Pass,@DateAdd,@Status)";
			}
			else
			{
				Debug.WriteLine($"מבצע עדכון של לקוח קיים עם CusId={Tmp.CusId}");
				sql = "UPDATE T_Customers SET FullName=@FullName,Phone=@Phone,Addres=@Addres,Email=@Email," +
					  "Pass=@Pass,DateAdd=@DateAdd,Status=@Status,Nots=@Nots,CityId=@CityId WHERE CusId=@CusId";
			}

			Debug.WriteLine($"SQL Query: {sql}");

			DbContext Db = new DbContext();
			try
			{
				var Obj = new
				{
					//CusId = Tmp.CusId,
					FullName = Tmp.FullName,
					Phone = Tmp.Phone,
					Addres = Tmp.Addres,
					Email = Tmp.Email,
					Pass = Tmp.Pass,
					DateAdd = Tmp.DateAdd,
					Status = Tmp.Status,
					//Nots = Tmp.Nots,
					//CityId = Tmp.CityId,
					
					//GoogleId = Tmp.GoogleId
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
		public static bool IsEmailExists(string Email)
		{
			string sql = "SELECT COUNT(*) FROM T_Customers WHERE Email = @Email";
			DbContext Db = new DbContext();

			try
			{
				var parameters = DbContext.CreateParameters(new { Email = Email });
				object result = Db.ExecuteScalar(sql, parameters);
				return Convert.ToInt32(result) > 0;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error checking Email existence: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}
		}
		public static void UpdateCustomers(Customers Tmp)
		{
			try
			{
				string sql = "UPDATE T_Customers SET FullName = @FullName,	Phone = @Phone,	Addres = @Addres,	Pass = @Pass,	Email = @Email,	DateAdd = @DateAdd,	Status = @Status,	Nots = @Nots,	CityId = @CityId WHERE CusId = @CusId";

				// הדפסת השאילתה לשם בדיקה
				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				var Obj = new
				{
					Tmp.CusId,
					
					Tmp.FullName,
					Tmp.Phone,
					Tmp.Addres,
					Tmp.Email,
					Tmp.Pass,
					Tmp.DateAdd,
					Tmp.Status,				
					Nots = (object)Tmp.Nots ?? DBNull.Value,       // טיפול בערכים null					
					Tmp.CityId
					
					//Tmp.GoogleId

				};

				var LstParma = DbContext.CreateParameters(Obj);

				// ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

				if (rowsAffected > 0)
				{
					System.Diagnostics.Debug.WriteLine("Customers updated successfully.");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
				}

				Db.Close();
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in UpdateCustomers method: {ex.Message}");
			}
		}

		// אחזור כל הלקוחות
		//public static List<Customers> GetAll()
		//{
		//	List<Customers> CustomersList = new List<Customers>();
		//	string sql = "Select * from T_Customers";
		//	DbContext Db = new DbContext();
		//	DataTable Dt = Db.Execute(sql);

		//	try
		//	{
		//		for (int i = 0; i < Dt.Rows.Count; i++)
		//		{
		//			Customers Tmp = new Customers()
		//			{
		//				CusId = int.Parse(Dt.Rows[i]["CusId"].ToString()),
		//				FullName = Dt.Rows[i]["FullName"].ToString(),
		//				Phone = Dt.Rows[i]["Phone"].ToString(),
		//				Addres = Dt.Rows[i]["Addres"].ToString(),
		//				Email = Dt.Rows[i]["Email"].ToString(),
		//				Pass = Dt.Rows[i]["Pass"].ToString(),
		//				DateAdd = DateTime.Parse(Dt.Rows[i]["DateAdd"].ToString()),
		//				History = Dt.Rows[i]["History"].ToString(),
		//				Nots = Dt.Rows[i]["Nots"].ToString(),
		//				CityId = int.Parse(Dt.Rows[i]["CityId"].ToString()),
		//				Status = false, // המרה בשלושה חלקים

		//				GoogleId = Dt.Rows[i]["GoogleId"].ToString(),
		//			};

		//			// המרת ערך ה-Status לבוליאני
		//			bool status;
		//			if (bool.TryParse(Dt.Rows[i]["Status"].ToString(), out status))
		//			{
		//				Tmp.Status = status;
		//			}
		//			else
		//			{
		//				// טיפול בכשל בהמרה - הגדרת ערך ברירת מחדל או תיעוד הבעיה
		//				// Tmp.Status = false; // הגדרת ערך ברירת מחדל או טיפול בהתאם לצורך
		//			}

		//			CustomersList.Add(Tmp);
		//		}

		//	}
		//	catch (Exception ex)
		//	{
		//		// תיעוד של השגיאה לצורך ניפוי
		//		Console.WriteLine("Exception: " + ex.Message);
		//	}
		//	finally
		//	{
		//		Db.Close();
		//	}

		//	return CustomersList;
		//}
		public static List<Customers> GetAll()
		{
			List<Customers> CustomersList = new List<Customers>();
			string sql = "Select * from T_Customers";
			DbContext Db = new DbContext();

			try
			{
				DataTable Dt = Db.Execute(sql);
				System.Diagnostics.Debug.WriteLine($"נמצאו {Dt.Rows.Count} לקוחות בדאטהבייס");

				foreach (DataRow row in Dt.Rows)
				{
					try
					{
						// הדפסת תוכן השורה לדיבוג
						System.Diagnostics.Debug.WriteLine($"קורא שורה - CusId: {row["CusId"]}, Email: {row["Email"]}");

						Customers Tmp = new Customers()
						{
							// טיפול נכון בערכים מהדאטהבייס
							CusId = Convert.ToInt32(row["CusId"]),
							FullName = Convert.ToString(row["FullName"]),
							Phone = Convert.ToString(row["Phone"]),
							Addres = Convert.ToString(row["Addres"]),
							Email = Convert.ToString(row["Email"]),
							Pass = Convert.ToString(row["Pass"]),
							DateAdd = row["DateAdd"] != DBNull.Value ? Convert.ToDateTime(row["DateAdd"]) : DateTime.Now,
							Status = row["Status"] != DBNull.Value ? Convert.ToBoolean(row["Status"]) : false,
							History = row["History"] != DBNull.Value ? Convert.ToString(row["History"]) : "",
							Nots = row["Nots"] != DBNull.Value ? Convert.ToString(row["Nots"]) : "",
							CityId = row["CityId"] != DBNull.Value ? Convert.ToInt32(row["CityId"]) : 0
							//GoogleId = row["GoogleId"] != DBNull.Value ? Convert.ToString(row["GoogleId"]) : ""
						};

						CustomersList.Add(Tmp);
						System.Diagnostics.Debug.WriteLine($"הוספת לקוח לרשימה - ID: {Tmp.CusId}, Email: {Tmp.Email}");
					}
					catch (Exception ex)
					{
						System.Diagnostics.Debug.WriteLine($"שגיאה בקריאת שורה: {ex.Message}");
					}
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בביצוע השאילתה: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}

			System.Diagnostics.Debug.WriteLine($"סה״כ נקראו {CustomersList.Count} לקוחות");
			return CustomersList;
		}
		// אחזור לפי זיהוי
		//public static Customers GetById(int Id)
		//{
		//	Customers Tmp = null;

		//	string sql = $"Select * from T_Customers Where CusId ={Id}";
		//	DbContext Db = new DbContext();
		//	DataTable Dt = Db.Execute(sql);
		//	if (Dt.Rows.Count > 0)
		//	{
		//		Tmp = new Customers()
		//		{
		//			CusId = int.Parse(Dt.Rows[0]["CusId"].ToString()),
		//			FullName = Dt.Rows[0]["FullName"].ToString(),
		//			Phone = Dt.Rows[0]["Phone"].ToString(),
		//			Addres = Dt.Rows[0]["Addres"].ToString(),
		//			Email = Dt.Rows[0]["Email"].ToString(),
		//			Pass = Dt.Rows[0]["Pass"].ToString(),
		//			DateAdd = DateTime.Parse(Dt.Rows[0]["DateAdd"].ToString()),
		//			History = Dt.Rows[0]["History"].ToString(),
		//			Nots = Dt.Rows[0]["Nots"].ToString(),
		//			CityId = int.Parse(Dt.Rows[0]["CityId"].ToString()),
		//			Status = Convert.ToBoolean(Dt.Rows[0]["Status"]),
		//			//GoogleId = Dt.Rows[0]["GoogleId"].ToString(),

		//		};
		//	}
		//	Db.Close();
		//	return Tmp;
		//}
		public static Customers GetById(int Id)
		{
			Customers Tmp = null;
			string sql = $"Select * from T_Customers Where CusId = {Id}";
			DbContext Db = new DbContext();

			try
			{
				DataTable Dt = Db.Execute(sql);
				System.Diagnostics.Debug.WriteLine($"GetById: מחפש לקוח עם ID={Id}");

				if (Dt.Rows.Count > 0)
				{
					DataRow row = Dt.Rows[0];
					System.Diagnostics.Debug.WriteLine($"נמצאה שורה - ערכים: {string.Join(", ", row.ItemArray)}");

					Tmp = new Customers()
					{
						CusId = Convert.ToInt32(row["CusId"]),
						FullName = Convert.ToString(row["FullName"]),
						Phone = Convert.ToString(row["Phone"]),
						Addres = Convert.ToString(row["Addres"]),
						Email = Convert.ToString(row["Email"]),
						Pass = Convert.ToString(row["Pass"]),
						DateAdd = row["DateAdd"] != DBNull.Value ? Convert.ToDateTime(row["DateAdd"]) : DateTime.Now,
						Status = row["Status"] != DBNull.Value ? Convert.ToBoolean(row["Status"]) : false,
						History = row["History"] != DBNull.Value ? Convert.ToString(row["History"]) : "",
						Nots = row["Nots"] != DBNull.Value ? Convert.ToString(row["Nots"]) : "",
						CityId = row["CityId"] != DBNull.Value ? Convert.ToInt32(row["CityId"]) : 0
					};

					System.Diagnostics.Debug.WriteLine($"לקוח נטען בהצלחה - ID: {Tmp.CusId}, Email: {Tmp.Email}");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"לא נמצא לקוח עם ID={Id}");
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה ב-GetById: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}

			return Tmp;
		}
		//מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			string Sql = $"Delete from T_Customers Where CusId={Id}";
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