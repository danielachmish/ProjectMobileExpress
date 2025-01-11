//using DAL;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;

//namespace BLL
//{
//	public class NotificationInfo
//	{
//		public int NotificationId { get; set; }
//		public int ReadId { get; set; }
//		public DateTime DateCreated { get; set; }
//		public string FullName { get; set; }
//		public string Phone { get; set; }
//		public string Desc { get; set; }
//		public string Urgency { get; set; }

//		public static void CreateNotification(int readId)
//		{
//			NotificationsDAL.SaveNotification(readId);
//		}

//		public static List<NotificationInfo> GetUnviewed()
//		{
//			return NotificationsDAL.GetUnviewedNotifications();
//		}

//		public static void MarkAsViewed(int notificationId)
//		{
//			NotificationsDAL.MarkAsViewed(notificationId);
//		}
//	}
//}