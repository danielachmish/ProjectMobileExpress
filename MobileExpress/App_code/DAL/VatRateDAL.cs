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
            DbContext db = new DbContext();
            try
            {
                string sql = @"SELECT TOP 1 Rate 
                          FROM T_VAT_Rates 
                          WHERE EndDate IS NULL 
                          ORDER BY StartDate DESC";

                var result = db.ExecuteScalar(sql, new List<SqlParameter>());
                return result != null ? Convert.ToDecimal(result) / 100 : 0.17m; // ברירת מחדל 17%
            }
            finally
            {
                db.Close();
            }
        }

        public static void UpdateVatRate(decimal newRate)
        {
            DbContext db = new DbContext();
            SqlTransaction transaction = null;

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

                db.ExecuteNonQuery(updateSql, new List<SqlParameter>());
                db.ExecuteNonQuery(insertSql, parameters);
            }
            catch
            {
                if (transaction != null)
                    transaction.Rollback();
                throw;
            }
            finally
            {
                db.Close();
            }
        }
    }
}