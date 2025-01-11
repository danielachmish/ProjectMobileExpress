//using System;
//using System.Data;
//using System.Data.SqlClient;

//namespace DAL
//{
//    public class TechnicianNotificationsDAL
//    {
//        public static DataTable GetUnviewedNotifications()
//        {
//            using (SqlConnection conn = new SqlConnection(DBConnect.ConnectionString))
//            {
//                using (SqlCommand cmd = new SqlCommand(@"
//                    SELECT n.NotificationId, n.ReadId, n.DateCreated, 
//                           r.FullName, r.Phone, r.Desc 
//                    FROM T_Notifications n
//                    INNER JOIN T_Readability r ON n.ReadId = r.ReadId
//                    WHERE n.IsViewed = 0
//                    ORDER BY n.DateCreated DESC", conn))
//                {
//                    DataTable dt = new DataTable();
//                    conn.Open();
//                    dt.Load(cmd.ExecuteReader());
//                    return dt;
//                }
//            }
//        }

//        public static void CreateNotification(int readId)
//        {
//            using (SqlConnection conn = new SqlConnection(DBConnect.ConnectionString))
//            {
//                using (SqlCommand cmd = new SqlCommand(@"
//                    INSERT INTO T_Notifications 
//                        (ReadId, DateCreated, IsViewed) 
//                    VALUES 
//                        (@ReadId, @DateCreated, @IsViewed)", conn))
//                {
//                    cmd.Parameters.AddWithValue("@ReadId", readId);
//                    cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
//                    cmd.Parameters.AddWithValue("@IsViewed", false);

//                    conn.Open();
//                    cmd.ExecuteNonQuery();
//                }
//            }
//        }

//        public static void MarkAsViewed(int notificationId)
//        {
//            using (SqlConnection conn = new SqlConnection(DBConnect.ConnectionString))
//            {
//                using (SqlCommand cmd = new SqlCommand(@"
//                    UPDATE T_Notifications 
//                    SET IsViewed = 1 
//                    WHERE NotificationId = @NotificationId", conn))
//                {
//                    cmd.Parameters.AddWithValue("@NotificationId", notificationId);
//                    conn.Open();
//                    cmd.ExecuteNonQuery();
//                }
//            }
//        }
//    }
//}