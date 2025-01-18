using BLL;
using Data;

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DAL
{
	public class TechnicianAvailabilityDAL
	{

        public static void SaveTechnicianAvailability(List<TechnicianAvailability> availabilities)
        {
            using (var db = new DbContext())
            {
                foreach (var item in availabilities)
                {
                    string sql = @"
                INSERT INTO T_TechnicianAvailability (TechnicianId, DayOfWeek, StartTime, EndTime)
                VALUES (@TechnicianId, @DayOfWeek, @StartTime, @EndTime)";
                    var parameters = new List<SqlParameter>
            {
                new SqlParameter("@TechnicianId", item.TechnicianId),
                new SqlParameter("@DayOfWeek", item.DayOfWeek),
                new SqlParameter("@StartTime", item.StartTime),
                new SqlParameter("@EndTime", item.EndTime)
            };
                    db.ExecuteNonQuery(sql, parameters);
                }
            }
        }

        public static void DeleteTechnicianAvailability(int technicianId)
        {
            string sql = "DELETE FROM T_TechnicianAvailability WHERE TechnicianId = @TechnicianId";
            using (var db = new DbContext())
            {
                var parameters = new List<SqlParameter>
        {
            new SqlParameter("@TechnicianId", technicianId)
        };
                db.ExecuteNonQuery(sql, parameters);
            }
        }

        public static List<TechnicianAvailability> GetTechnicianAvailability(int technicianId)
        {
            string sql = "SELECT * FROM T_TechnicianAvailability WHERE TechnicianId = @TechnicianId";
            using (var db = new DbContext())
            {
                var parameters = new List<SqlParameter>
        {
            new SqlParameter("@TechnicianId", technicianId)
        };

                var dt = db.Execute(sql, parameters);
                var availabilities = new List<TechnicianAvailability>();

                foreach (DataRow row in dt.Rows)
                {
                    availabilities.Add(new TechnicianAvailability
                    {
                        Id = Convert.ToInt32(row["Id"]),
                        TechnicianId = Convert.ToInt32(row["TechnicianId"]),
                        DayOfWeek = Convert.ToInt32(row["DayOfWeek"]),
                        StartTime = TimeSpan.Parse(row["StartTime"].ToString()),
                        EndTime = TimeSpan.Parse(row["EndTime"].ToString())
                    });
                }
                return availabilities;
            }
        }

    }
}