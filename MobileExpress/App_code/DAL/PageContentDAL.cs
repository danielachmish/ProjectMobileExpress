using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using BLL;
using Data;

namespace DAL
{
    public class PageContentDAL
    {
       

		// שמירת תוכן חדש או עדכון קיים
		public static void Save(PageContent Tmp)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל תהליך שמירה...");
				System.Diagnostics.Debug.WriteLine($"Id: {Tmp.Id}");
				System.Diagnostics.Debug.WriteLine($"SectionName: {Tmp.SectionName}");
				System.Diagnostics.Debug.WriteLine($"Content: {Tmp.Content}");

				string sql;
				if (Tmp.Id <= 0)
				{
					sql = @"INSERT INTO T_PageContent 
                    (SectionName, Content, LastUpdated, IsActive)
                    VALUES 
                    (@SectionName, @Content, @LastUpdated, @IsActive);
                    SELECT SCOPE_IDENTITY();";
				}
				else
				{
					sql = @"UPDATE T_PageContent 
                    SET SectionName=@SectionName, 
                        Content=@Content, 
                        LastUpdated=@LastUpdated, 
                        IsActive=@IsActive,                       
                    WHERE Id=@Id";
				}

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						Id = Tmp.Id,
						SectionName = Tmp.SectionName,
						Content = Tmp.Content,
						LastUpdated = Tmp.LastUpdated,
						IsActive = Tmp.IsActive,						
						
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

		public static void UpdatePageContent(PageContent Tmp)
		{
			try
			{
				string sql = @"UPDATE T_PageContent 
                      SET SectionName = @SectionName,
                          Content = @Content,
                          LastUpdated = @LastUpdated,
                          IsActive = @IsActive,                          
                      WHERE Id = @Id";

				System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						Tmp.Id,
						Tmp.SectionName,
						Tmp.Content,
						Tmp.LastUpdated,
						Tmp.IsActive,
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
		public static List<PageContent> GetAll()
		{
			List<PageContent> PageContentList = new List<PageContent>();
			string sql = "Select * from T_PageContent";
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
						

						PageContent Tmp = new PageContent()
						{
							// טיפול נכון בערכים מהדאטהבייס
							Id = Convert.ToInt32(row["Id"]),
							SectionName = Convert.ToString(row["SectionName"]),
							Content = Convert.ToString(row["Content"]),

							LastUpdated = row["LastUpdated"] != DBNull.Value ? Convert.ToDateTime(row["LastUpdated"]) : DateTime.Now,
							IsActive = row["IsActive"] != DBNull.Value ? Convert.ToBoolean(row["IsActive"]) : false,
							
						};

						PageContentList.Add(Tmp);
						
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

			System.Diagnostics.Debug.WriteLine($"סה״כ נקראו {PageContentList.Count} לקוחות");
			return PageContentList;
		}
		// אחזור כל התוכן
		//public static List<PageContent> GetAll()
  //      {
  //          List<PageContent> contents = new List<PageContent>();

  //          using (SqlConnection conn = new SqlConnection("your_connection_string_here"))
  //          {
  //              string query = "SELECT * FROM PageContent WHERE IsActive = 1";
  //              SqlCommand cmd = new SqlCommand(query, conn);
  //              conn.Open();

  //              SqlDataReader reader = cmd.ExecuteReader();
  //              while (reader.Read())
  //              {
  //                  contents.Add(new PageContent
  //                  {
  //                      Id = Convert.ToInt32(reader["Id"]),
  //                      SectionName = reader["SectionName"].ToString(),
  //                      Content = reader["Content"].ToString(),
  //                      LastUpdated = Convert.ToDateTime(reader["LastUpdated"]),
  //                      IsActive = Convert.ToBoolean(reader["IsActive"])
  //                  });
  //              }
  //          }

  //          return contents;
  //      }

        // אחזור תוכן לפי מזהה
        public static PageContent GetById(int id)
        {
            PageContent content = null;

            using (SqlConnection conn = new SqlConnection("your_connection_string_here"))
            {
                string query = "SELECT * FROM PageContent WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    content = new PageContent
                    {
                        Id = Convert.ToInt32(reader["Id"]),
                        SectionName = reader["SectionName"].ToString(),
                        Content = reader["Content"].ToString(),
                        LastUpdated = Convert.ToDateTime(reader["LastUpdated"]),
                        IsActive = Convert.ToBoolean(reader["IsActive"])
                    };
                }
            }

            return content;
        }

        // מחיקת תוכן לפי מזהה
        public static int DeleteById(int id)
        {
            using (SqlConnection conn = new SqlConnection("your_connection_string_here"))
            {
                string query = "DELETE FROM PageContent WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();

                return cmd.ExecuteNonQuery();
            }
        }
    }
}
