using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Protocols.WSTrust;

namespace DAL
{
    public class TechniciansDAL
	{
        public static void SaveNewTechnician(Technicians Tmp)
        {
            try
            {
                string sql = "INSERT INTO T_Technicians (TecNum, FulName, Phone, Address, Pass, UserName, Type, History, Nots, Email, Status, SerProdId, DateAddition ) " +
                             "VALUES (@TecNum, @FulName, @Phone, @Address, @Pass, @UserName, @Type, @History, @Nots, @Email, @Status, @SerProdId, @DateAddition)";

                Tmp.DateAddition = DateTime.Now;

                // הדפסת השאילתה לשם בדיקה
                System.Diagnostics.Debug.WriteLine("SQL Query (Insert): " + sql);

                DbContext Db = new DbContext();
                var Obj = new
                {
                    Tmp.TecNum,
                    Tmp.FulName,
                    Tmp.Phone,
                    Tmp.Address,
                    Tmp.Pass,
                    Tmp.UserName,
                    Tmp.Type,
                    Tmp.Status,
                    History = (object)Tmp.History ?? DBNull.Value, // טיפול בערכים null
                    Nots = (object)Tmp.Nots ?? DBNull.Value,       // טיפול בערכים null
                    Tmp.Email,
                    Tmp.SerProdId,
                    Tmp.DateAddition
                };

                var LstParma = DbContext.CreateParameters(Obj);

                // ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
                int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
                System.Diagnostics.Debug.WriteLine($"Rows affected (Insert): {rowsAffected}");

                if (rowsAffected > 0)
                {
                    System.Diagnostics.Debug.WriteLine("Technician inserted successfully.");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("No rows were affected. Check your insert query and parameters.");
                }

                Db.Close();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in SaveNewTechnician method: {ex.Message}");
            }
        }

        public static bool IsEmailExists(string email)
        {
            string sql = "SELECT COUNT(*) FROM T_Technicians WHERE Email = @Email";
            DbContext Db = new DbContext();

            try
            {
                var parameters = DbContext.CreateParameters(new { Email = email });
                object result = Db.ExecuteScalar(sql, parameters);
                return Convert.ToInt32(result) > 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error checking email existence: {ex.Message}");
                throw;
            }
            finally
            {
                Db.Close();
            }
        }

        public static void UpdateTechnician(Technicians Tmp)
        {
            try
            {
                string sql = "UPDATE T_Technicians SET TecNum = @TecNum, FulName = @FulName, Phone = @Phone, Address = @Address, Pass = @Pass, UserName = @UserName, " +
                             "Type = @Type, History = @History, Nots = @Nots, Email = @Email, Status = @Status, SerProdId = @SerProdId, DateAddition = @DateAddition " +
                             "WHERE TecId = @TecId";

                // הדפסת השאילתה לשם בדיקה
                System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

                DbContext Db = new DbContext();
                var Obj = new
                {
                    Tmp.TecId,
                    Tmp.TecNum,
                    Tmp.FulName,
                    Tmp.Phone,
                    Tmp.Address,
                    Tmp.Pass,
                    Tmp.UserName,
                    Tmp.Type,
                    Tmp.Status,
                    History = (object)Tmp.History ?? DBNull.Value, // טיפול בערכים null
                    Nots = (object)Tmp.Nots ?? DBNull.Value,       // טיפול בערכים null
                    Tmp.Email,
                    Tmp.SerProdId,
                    Tmp.DateAddition
                };

                var LstParma = DbContext.CreateParameters(Obj);

                // ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
                int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
                System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

                if (rowsAffected > 0)
                {
                    System.Diagnostics.Debug.WriteLine("Technician updated successfully.");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
                }

                Db.Close();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in UpdateTechnician method: {ex.Message}");
            }
        }


        //     public static void Save(BLL.Technicians Tmp)
        //     {
        //         // בדיקת תקינות הנתונים
        //         if (string.IsNullOrWhiteSpace(Tmp.FulName) ||
        //             string.IsNullOrWhiteSpace(Tmp.Phone) ||
        //             string.IsNullOrWhiteSpace(Tmp.Address) ||
        //             string.IsNullOrWhiteSpace(Tmp.Pass) ||
        //             string.IsNullOrWhiteSpace(Tmp.UserName) ||
        //             string.IsNullOrWhiteSpace(Tmp.Type) ||
        //             string.IsNullOrWhiteSpace(Tmp.Email) ||
        //	Tmp.DateAddition == default(DateTime)) // השוואה נכונה של DateTime
        //{
        //             throw new ArgumentException("One or more required fields are missing or invalid");
        //         }
        //         string sql;
        //         if (Tmp.TecId == -1)
        //         {
        //             // הוספת טכנאי חדש
        //             sql = "INSERT INTO T_Technicians (TecNum, FulName, Phone, Address, Pass, UserName, Type, History, Nots, Email, Status, SerProdId, DateAddition) " +
        //                   "VALUES (@TecNum, @FulName, @Phone, @Address, @Pass, @UserName, @Type, @History, @Nots, @Email, @Status, @SerProdId, @DateAddition)";
        //         }
        //         else
        //         {
        //             // עדכון טכנאי קיים
        //             sql = "UPDATE T_Technicians SET TecNum = @TecNum, FulName = @FulName, Phone = @Phone, Address = @Address, Pass = @Pass, UserName = @UserName, " +
        //                   "Type = @Type, History = @History, Nots = @Nots, Email = @Email, Status = @Status, SerProdId = @SerProdId, DateAddition = @DateAddition " +
        //                   "WHERE TecId = @TecId";
        //         }

        //         // הדפסת השאילתה לשם בדיקה
        //         Console.WriteLine("SQL Query: " + sql);

        //         DbContext Db = new DbContext();
        //         var Obj = new
        //         {
        //             Tmp.TecId,
        //             Tmp.TecNum,
        //             Tmp.FulName,
        //             Tmp.Phone,
        //             Tmp.Address,
        //             Tmp.Pass,
        //             Tmp.UserName,
        //             Tmp.Type,
        //             Tmp.Status,
        //             Tmp.History,
        //             Tmp.Nots,
        //             Tmp.Email,
        //             Tmp.SerProdId,
        //             Tmp.DateAddition
        //         };

        //         var LstParma = DbContext.CreateParameters(Obj);
        //         try
        //         {
        //             Db.ExecuteNonQuery(sql, LstParma);
        //             Console.WriteLine("Technician data saved successfully");
        //         }
        //         catch (SqlException ex)
        //         {
        //             Console.WriteLine("SqlException: " + ex.Message);
        //             throw; // זרוק את החריגה מחדש כדי שתוכל לראותה בשכבה עליונה יותר
        //         }
        //         catch (Exception ex)
        //         {
        //             Console.WriteLine("Exception: " + ex.Message);
        //             throw; // זרוק את החריגה מחדש כדי שתוכל לראותה בשכבה עליונה יותר
        //         }
        //         finally
        //         {
        //             Db.Close();
        //         }
        //     }

        // אחזור כל הלקוחות
        public static List<Technicians> GetAll()
        {
            List<Technicians> TechniciansList = new List<Technicians>();
            string sql = "SELECT * FROM T_Technicians";
            DbContext Db = new DbContext();
            DataTable Dt = Db.Execute(sql);

            try
            {
                foreach (DataRow row in Dt.Rows)
                {
					//DateTime dateAddition = default;
					Technicians Tmp = new Technicians
                    {
                        TecId = int.Parse(row["TecId"].ToString()),
                        TecNum = row["TecNum"].ToString(),
                        FulName = row["FulName"].ToString(),
                        Phone = row["Phone"].ToString(),
                        Address = row["Address"].ToString(),
                        Pass = row["Pass"].ToString(),
                        UserName = row["UserName"].ToString(),
                        Type = row["Type"].ToString(),
                        History = row["History"].ToString(),
                        Nots = row["Nots"].ToString(),
                        Email = row["Email"].ToString(),
                        SerProdId = int.Parse(row["SerProdId"].ToString()),
                        DateAddition = DateTime.Parse(row["DateAddition"].ToString()),
                        Status = Convert.ToBoolean(row["Status"])
                    };
                    TechniciansList.Add(Tmp);
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

            return TechniciansList;
        }

        // אחזור לפי זיהוי
        public static Technicians GetById(int Id)
        {
            Technicians Tmp = null;
            string sql = $"SELECT * FROM T_Technicians WHERE TecId = {Id}";
            DbContext Db = new DbContext();

            try
            {
                DataTable Dt = Db.Execute(sql);
                if (Dt.Rows.Count > 0)
                {
                    DataRow row = Dt.Rows[0];
					DateTime dateAddition = default;
					Tmp = new Technicians
                    {
                        TecId = int.Parse(row["TecId"].ToString()),
                        TecNum = row["TecNum"].ToString(),
                        FulName = row["FulName"].ToString(),
                        Phone = row["Phone"].ToString(),
                        Address = row["Address"].ToString(),
                        Pass = row["Pass"].ToString(),
                        UserName = row["UserName"].ToString(),
                        Type = row["Type"].ToString(),
                        Status = Convert.ToBoolean(row["Status"]),
                        History = row["History"].ToString(),
                        Nots = row["Nots"].ToString(),
                        Email = row["Email"].ToString(),
                        SerProdId = int.Parse(row["SerProdId"].ToString()),
                        DateAddition = dateAddition,
                    };
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

            return Tmp;
        }

        // מחיקה לפי זיהוי
        public static int DeleteById(int Id)
        {
            string sql = $"DELETE FROM T_Technicians WHERE TecId = {Id}";
            DbContext Db = new DbContext();

            try
            {
                int Total = Db.ExecuteNonQuery(sql);
                return Total > 0 ? 1 : -1;
            }
            catch (Exception ex)
            {
                // תיעוד של השגיאה לצורך ניפוי
                Console.WriteLine("Exception: " + ex.Message);
                return -1;
            }
            finally
            {
                Db.Close();
            }
        }
    }
}
