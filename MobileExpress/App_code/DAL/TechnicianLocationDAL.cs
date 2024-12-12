// DAL/TechnicianNotificationsDAL.cs
using Data;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class TechnicianLocationsDAL
    {
        public static void SaveLocation(int technicianId, decimal latitude, decimal longitude, decimal accuracy)
        {
            try
            {
                string sql = @"INSERT INTO T_TechnicianLocations 
                            (TechnicianId, Latitude, Longitude, Accuracy, Timestamp) 
                            VALUES (@TechnicianId, @Latitude, @Longitude, @Accuracy, @Timestamp)";

                DbContext db = new DbContext();
                var obj = new
                {
                    TechnicianId = technicianId,
                    Latitude = latitude,
                    Longitude = longitude,
                    Accuracy = accuracy,
                    Timestamp = DateTime.Now
                };

                var parameters = DbContext.CreateParameters(obj);
                db.ExecuteNonQuery(sql, parameters);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving location: {ex.Message}");
                throw;
            }
        }

        public static BLL.TechnicianLocationModel GetLastLocation(int technicianId)  // עדכון שם ההחזרה
        {
            string sql = "SELECT TOP 1 * FROM T_TechnicianLocations WHERE TechnicianId = @TechnicianId ORDER BY Timestamp DESC";

            DbContext db = new DbContext();
            var parameters = DbContext.CreateParameters(new { TechnicianId = technicianId });

            try
            {
                DataTable dt = db.Execute(sql, parameters);
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    return new BLL.TechnicianLocationModel  // עדכון שם המחלקה
                    {
                        LocationId = Convert.ToInt32(row["LocationId"]),
                        TechnicianId = Convert.ToInt32(row["TechnicianId"]),
                        Latitude = Convert.ToDecimal(row["Latitude"]),
                        Longitude = Convert.ToDecimal(row["Longitude"]),
                        Accuracy = Convert.ToDecimal(row["Accuracy"]),
                        Timestamp = Convert.ToDateTime(row["Timestamp"])
                    };
                }
                return null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting location: {ex.Message}");
                throw;
            }
            finally
            {
                db.Close();
            }
        }
    }
}