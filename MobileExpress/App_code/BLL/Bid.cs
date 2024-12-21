using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL;

namespace BLL
{
    public class Bid
    {
        public string FullName { get; set; } 
        public int BidId { get; set; }
        public string Desc { get; set; }
        public decimal Price { get; set; }
        public bool Status { get; set; }
        public int TecId { get; set; }
        public int ReadId { get; set; }
        public DateTime Date { get; set; }
        
        // השדות החדשים מהטבלה המאוחדת
        public string ItemDescription { get; set; }
        public int ItemQuantity { get; set; }
        public decimal ItemUnitPrice { get; set; }
        public decimal ItemTotal => ItemQuantity * ItemUnitPrice;

        public void SaveNewBid()
        {
            try
            {
                BidId = BidDAL.Save(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת הצעת מחיר חדשה: {ex.Message}");
                throw;
            }
        }

        public void UpdateBid()
        {
            try
            {
                BidDAL.Save(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון הצעת מחיר: {ex.Message}");
                throw;
            }
        }

        public void Save()
        {
            if (BidId <= 0)
            {
                SaveNewBid();
            }
            else
            {
                UpdateBid();
            }
        }

        public static List<Bid> GetAll()
        {
            return BidDAL.GetAll();
        }

        public static Bid GetById(int id)
        {
            return BidDAL.GetById(id);
        }


        public static int DeleteById(int id)
        {
            return BidDAL.DeleteById(id);
        }

        public void CalculateTotalPrice()
        {
            Price = ItemTotal;  // במקרה זה המחיר הכולל הוא פשוט סכום הפריט
        }
    }
}