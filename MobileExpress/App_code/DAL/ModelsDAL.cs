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
			System.Diagnostics.Debug.WriteLine($"Saving model - ModelId: {Tmp.ModelId}, Name: {Tmp.ModelName}, manuId: {Tmp.manuId}");

			string sql;
			if (Tmp.ModelId == -1 || Tmp.ModelId == 0)
			{
				sql = "INSERT INTO T_Models(ModelName,manuId,Image,[Date]) " +
					  "VALUES (@ModelName,@manuId,@Image,@Date); SELECT SCOPE_IDENTITY();";
				System.Diagnostics.Debug.WriteLine("Performing INSERT");
			}
			else
			{
				sql = "UPDATE T_Models SET ModelName=@ModelName,ManuId=@ManuId,Image=@Image,[Date]=@Date WHERE ModelId=@ModelId";
				System.Diagnostics.Debug.WriteLine("Performing UPDATE");
			}

			DbContext Db = new DbContext();
			try
			{
				var Obj = new
				{
					ModelId = Tmp.ModelId,
					ModelName = Tmp.ModelName,
					manuId = Tmp.manuId,
					Image = Tmp.Image,
					Date = Tmp.Date,
				};

				var LstParma = DbContext.CreateParameters(Obj);
				int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
				System.Diagnostics.Debug.WriteLine($"Rows affected: {rowsAffected}");
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in Save method: {ex.Message}");
				throw;
			}
			finally
			{
				Db.Close();
			}
		}
		public static void UpdateModels(Models Tmp)
		{
			try
			{
				string sql = @"UPDATE T_Models 
                      SET ModelName = @ModelName,
                          manuId = @manuId,
                          Image = @Image,
                          Date = @Date
                           WHERE ModelId = @ModelId";

				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						Tmp.ModelId,
						Tmp.ModelName,
						Tmp.manuId,
						Tmp.Image,
						Tmp.Date						
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
					System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine("Models updated successfully.");
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
				System.Diagnostics.Debug.WriteLine($"Error in UpdateModels method: {ex.Message}");
				throw;
			}
		}
		public static List<Models> GetAll()
		{
			List<Models> ModelsList = new List<Models>();
			DbContext db = new DbContext();

			try
			{
				string sql = "SELECT * FROM T_Models";
				var dt = db.Execute(sql);

				// לוג לצורך דיבאג
				foreach (DataColumn col in dt.Columns)
				{
					System.Diagnostics.Debug.WriteLine($"Column: {col.ColumnName}, Type: {col.DataType}");
				}

				// המרת כל שורה בדאטה טייבל לאובייקט Models
				foreach (DataRow row in dt.Rows)
				{
					Models model = new Models
					{
						ModelId = Convert.ToInt32(row["ModelId"]),
						ModelName = row["ModelName"].ToString(),
						manuId = Convert.ToInt32(row["manuId"]),
						Image = row["Image"].ToString(),
						Date = Convert.ToDateTime(row["Date"])
					};

					// הוספת האובייקט לרשימה
					ModelsList.Add(model);

					// לוג לצורך דיבאג
					System.Diagnostics.Debug.WriteLine($"Added Model: " +
						$"ID={model.ModelId}, " +
						$"Name={model.ModelName}, " +
						$"manuId={model.manuId}, " +
						$"Image={model.Image}, " +
						$"Date={model.Date}");
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetAll: {ex.Message}");
				throw;
			}
			finally
			{
				db.Close();
			}

			// לוג לצורך דיבאג
			System.Diagnostics.Debug.WriteLine($"Total models retrieved: {ModelsList.Count}");

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
					manuId = int.Parse(Dt.Rows[0]["manuId"].ToString()),
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