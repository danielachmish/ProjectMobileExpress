using Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

using System.Web;

namespace DAL
{
    public class VatRateDAL
    {
       
        public static decimal GetCurrentVatRate()
        {
            using (DbContext db = new DbContext())
            {
                try
                {
                    string sql = @"SELECT TOP 1 Rate 
                      FROM T_VAT_Rates 
                      WHERE EndDate IS NULL 
                      ORDER BY StartDate DESC";
                    var result = db.ExecuteScalar(sql, new List<SqlParameter>());
                    return result != null ? Convert.ToDecimal(result) / 100 : 0.17m;
                }
                catch (Exception ex)
                {
                    // לוג השגיאה
                    return 0.17m;
                }
            }
        }

      
        public static void UpdateVatRate(decimal newRate)
        {
            using (var db = new DbContext())
            {
                try
                {
                    // סגירת התעריף הקודם
                    string updateSql = @"UPDATE T_VAT_Rates 
                                SET EndDate = GETDATE() 
                                WHERE EndDate IS NULL";

					// הוספת התעריף החדש
					string insertSql = @"INSERT INTO T_VAT_Rates 
                                (Rate, StartDate, EndDate, Description) 
                                VALUES (@Rate, GETDATE(), NULL, @Description)";

					var parameters = DbContext.CreateParameters(new
                    {
                        Rate = newRate * 100,
                        Description = $"עודכן ב-{DateTime.Now}"
                    });

                    // ביצוע הפעולות
                    db.ExecuteNonQuery(updateSql, new List<SqlParameter>());
                    db.ExecuteNonQuery(insertSql, parameters);
                }
                finally
                {
                    db.Close();
                }
            }
        }
    }  
}