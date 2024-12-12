//using System;
//using System.Data;
//using DAL;

//namespace BLL
//{
//    public class TechnicianNotifications
//    {
//        public int NotificationId { get; set; }
//        public int ReadId { get; set; }
//        public DateTime DateCreated { get; set; }
//        public bool IsViewed { get; set; }
//        public string FullName { get; set; }
//        public string Phone { get; set; }
//        public string Description { get; set; }

//        public static DataTable GetUnviewedNotifications()
//        {
//            return TechnicianNotificationsDAL.GetUnviewedNotifications();
//        }

//        public static void CreateNewNotification(int readId)
//        {
//            TechnicianNotificationsDAL.CreateNotification(readId);
//        }

//        public static void MarkAsViewed(int notificationId)
//        {
//            TechnicianNotificationsDAL.MarkAsViewed(notificationId);
//        }
//    }
//}