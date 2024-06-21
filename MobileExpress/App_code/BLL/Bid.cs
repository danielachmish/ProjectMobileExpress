using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL;

namespace BLL
{
    public class Bid
    {
        public int BidId { get; set; } // מזהה הביד
        public string Desc { get; set; } // תיאור הביד
        public int Price { get; set; } // מחיר הביד (כ- string כדי להתאים ל-NVARCHAR)
        public bool Status { get; set; } // סטטוס הביד
        public int TecId { get; set; } // מזהה הטכנאי
        public int ReadId { get; set; } // מזהה הקורא
        public DateTime Date { get; set; } // תאריך הביד

        // שמירת הביד
        public void Save()
        {
            BidDAL.Save(this);
        }

        // אחזור כל הבידים
        public static List<Bid> GetAll()
        {
            return BidDAL.GetAll();
        }

        // אחזור ביד לפי מזהה
        public static Bid GetById(int Id)
        {
            return BidDAL.GetById(Id);
        }

        // מחיקת ביד לפי מזהה
        public static int DeleteById(int Id)
        {
            return BidDAL.DeleteById(Id);
        }
    }
}
