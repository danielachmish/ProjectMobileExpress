using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace DAL
{
    public class ManufacturersDAL
    {
        public static void Save(Manufacturers Tmp)
        {
            try
            {
                Console.WriteLine("=== מתחיל תהליך שמירה ===");
                Console.WriteLine($"ManuId: {Tmp.ManuId}");
                Console.WriteLine($"ManuName: {Tmp.ManuName}");
                Console.WriteLine($"Desc: {Tmp.Desc}");
                Console.WriteLine($"NameImage: {Tmp.NameImage}");
                Console.WriteLine($"Date: {Tmp.Date}");

                string sql;
                if (Tmp.ManuId <= 0)
                {
                    sql = "INSERT INTO T_Manufacturers (ManuName, [Desc], NameImage, [Date]) " +
                          "VALUES (@ManuName, @Desc, @NameImage, @Date)";
                    Console.WriteLine("מבצע INSERT");
                }
                else
                {
                    sql = "UPDATE T_Manufacturers SET ManuName = @ManuName, [Desc] = @Desc, " +
                          "NameImage = @NameImage, [Date] = @Date WHERE ManuId = @ManuId";
                    Console.WriteLine("מבצע UPDATE");
                }

                Console.WriteLine($"SQL Query: {sql}");

                DbContext Db = new DbContext();
                var Obj = new
                {
                    ManuId = Tmp.ManuId,
                    ManuName = Tmp.ManuName,
                    Desc = Tmp.Desc,
                    NameImage = Tmp.NameImage,
                    Date = Tmp.Date
                };
                var LstParma = DbContext.CreateParameters(Obj);
                Console.WriteLine("Parameters:");
                foreach (var param in LstParma)
                {
                    Console.WriteLine($"{param.ParameterName} = {param.Value}");
                }

                int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
                Console.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");
                Db.Close();
                Console.WriteLine("=== סיום תהליך שמירה בהצלחה ===");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"!!! שגיאה בשמירה !!!: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

        public static void UpdateManufacturers(Manufacturers Tmp)
        {
            try
            {
                string sql = "UPDATE T_Manufacturers SET ManuName = @ManuName,	[Desc] = @Desc,	NameImage = @NameImage,	[Date] = @Date WHERE ManuId = @ManuId";

                // הדפסת השאילתה לשם בדיקה
                System.Diagnostics.Debug.WriteLine("SQL Query (Update): " + sql);

                DbContext Db = new DbContext();
                var Obj = new
                {
                    Tmp.ManuId,
                    Tmp.ManuName,
                    Tmp.Desc,
                    Tmp.NameImage,     
                    Tmp.Date         
                };

                var LstParma = DbContext.CreateParameters(Obj);

                // ביצוע השאילתה והכנסת הנתונים לבסיס הנתונים
                int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);
                System.Diagnostics.Debug.WriteLine($"Rows affected (Update): {rowsAffected}");

                if (rowsAffected > 0)
                {
                    System.Diagnostics.Debug.WriteLine("Manufacturers updated successfully.");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("No rows were affected. Check your update query and parameters.");
                }

                Db.Close();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in UpdateManufacturers method: {ex.Message}");
            }
        }

        // אחזור כל הלקוחות
        public static List<Manufacturers> GetAll()
        {
            List<Manufacturers> ManufacturersList = new List<Manufacturers>();
            string sql = "SELECT * FROM T_Manufacturers";
            DbContext Db = new DbContext();
            DataTable Dt = Db.Execute(sql);

            try
            {
                for (int i = 0; i < Dt.Rows.Count; i++)
                {
                    Manufacturers Tmp = new Manufacturers()
                    {
                        ManuId = int.Parse(Dt.Rows[i]["ManuId"].ToString()),
                        ManuName = Dt.Rows[i]["ManuName"].ToString(),
                        Desc = Dt.Rows[i]["Desc"].ToString(),
                        NameImage = Dt.Rows[i]["NameImage"].ToString(),
                        Date = DateTime.Parse(Dt.Rows[i]["Date"].ToString())
                    };

                    ManufacturersList.Add(Tmp);
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

            return ManufacturersList;
        }

        // אחזור לפי זיהוי
        public static Manufacturers GetById(int Id)
        {
            Manufacturers Tmp = null;
            string sql = $"SELECT * FROM T_Manufacturers WHERE ManuId = {Id}";
            DbContext Db = new DbContext();
            DataTable Dt = Db.Execute(sql);
            if (Dt.Rows.Count > 0)
            {
                Tmp = new Manufacturers()
                {
                    ManuId = int.Parse(Dt.Rows[0]["ManuId"].ToString()),
                    ManuName = Dt.Rows[0]["ManuName"].ToString(),
                    Desc = Dt.Rows[0]["Desc"].ToString(),
                    NameImage = Dt.Rows[0]["NameImage"].ToString(),
                    Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString())
                };
            }
            Db.Close();
            return Tmp;
        }

        // מחיקה לפי זיהוי
        public static int DeleteById(int Id)
        {
            string Sql = $"DELETE FROM T_Manufacturers WHERE ManuId = {Id}";
            DbContext Db = new DbContext();
            int Total = Db.ExecuteNonQuery(Sql);
            Db.Close();

            return Total > 0 ? 1 : -1;
        }
    }
}
