//using BLL;
//using Data;

//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Linq;
//using System.Web;

//namespace DAL
//{
//	public class NotificationsDAL
//	{
//		public static void SaveNotification(int readId)
//		{
//			string sql = "INSERT INTO T_Notifications (ReadId) VALUES (@ReadId)";
//			DbContext Db = new DbContext();
//			try
//			{
//				var Obj = new { ReadId = readId };
//				var LstParma = DbContext.CreateParameters(Obj);
//				Db.ExecuteNonQuery(sql, LstParma);
//			}
//			finally
//			{
//				Db.Close();
//			}
//		}

//		public static List<NotificationInfo> GetUnviewedNotifications()
//		{
//			List<NotificationInfo> notifications = new List<NotificationInfo>();
//			string sql = @"SELECT n.NotificationId, n.DateCreated, r.* 
//                      FROM T_Notifications n 
//                      JOIN T_Readability r ON n.ReadId = r.ReadId 
//                      WHERE n.IsViewed = 0 
//                      ORDER BY n.DateCreated DESC";

//			DbContext Db = new DbContext();
//			try
//			{
//				DataTable dt = Db.Execute(sql);
//				foreach (DataRow row in dt.Rows)
//				{
//					notifications.Add(new NotificationInfo
//					{
//						NotificationId = Convert.ToInt32(row["NotificationId"]),
//						ReadId = Convert.ToInt32(row["ReadId"]),
//						DateCreated = Convert.ToDateTime(row["DateCreated"]),
//						FullName = row["FullName"].ToString(),
//						Phone = row["Phone"].ToString(),
//						Desc = row["Desc"].ToString(),
//						Urgency = row["Urgency"].ToString()
//					});
//				}
//			}
//			finally
//			{
//				Db.Close();
//			}
//			return notifications;
//		}

//		public static void MarkAsViewed(int notificationId)
//		{
//			string sql = "UPDATE T_Notifications SET IsViewed = 1 WHERE NotificationId = @NotificationId";
//			DbContext Db = new DbContext();
//			try
//			{
//				var Obj = new { NotificationId = notificationId };
//				var LstParma = DbContext.CreateParameters(Obj);
//				Db.ExecuteNonQuery(sql, LstParma);
//			}
//			finally
//			{
//				Db.Close();
//			}
//		}
//	}
//}